#!/usr/bin/env python3
"""
Simple DevTools trace analyzer for Flutter traces.
Usage:
  python tools/trace_analyzer.py path/to/trace.json

Outputs the top long events on the main thread and a short summary.
"""
import json
import sys
from collections import defaultdict

MIN_MS = 16.0  # frame budget

def load_trace(path):
    with open(path, 'r', encoding='utf-8') as f:
        return json.load(f)

# Many traces put events in 'traceEvents' or 'events'

def get_events(data):
    if isinstance(data, dict):
        for k in ('traceEvents', 'events', 'traces'):
            if k in data:
                return data[k]
    if isinstance(data, list):
        return data
    return []


def analyze(events):
    # We will look for events with 'dur' or 'ts' and 'dur'
    # and attempt to filter by thread 'Main' or by thread id typical for Flutter (1 or '1')
    long_events = []
    by_name = defaultdict(float)
    for ev in events:
        # skip metadata
        if not isinstance(ev, dict):
            continue
        dur = None
        name = ev.get('name') or ev.get('ph')
        # duration in microseconds
        if 'dur' in ev:
            try:
                dur = float(ev['dur']) / 1000.0
            except Exception:
                dur = None
        elif ev.get('ph') == 'X' and 'dur' in ev:
            try:
                dur = float(ev['dur']) / 1000.0
            except Exception:
                dur = None
        # some traces specify timestamps in ms
        if dur is None and 'ts' in ev and 'tts' in ev:
            try:
                dur = (float(ev['tts']) - float(ev['ts']))
            except Exception:
                pass
        if dur is None:
            continue
        # try to detect main thread events: common thread names
        tid = ev.get('tid') or ev.get('pid')
        tname = ev.get('args', {}).get('thread_name') if isinstance(ev.get('args'), dict) else None
        # Accept events that either have 'Main' in thread name or belong to pid/tid 1 or to 'UI'
        is_main = False
        if tname:
            if 'Main' in tname or 'UI' in tname or 'Raster' in tname:
                is_main = True
        try:
            if tid in (1, '1', 'Main', None):
                is_main = True
        except Exception:
            pass
        if dur >= MIN_MS and is_main:
            long_events.append((dur, name, tid, tname, ev))
            by_name[name] += dur
    long_events.sort(reverse=True, key=lambda x: x[0])
    return long_events, by_name


def print_report(long_events, by_name, limit=20):
    print("DevTools trace analyzer report")
    print("Frame budget threshold: {} ms".format(MIN_MS))
    print()
    if not long_events:
        print("No long main-thread events detected above threshold.")
        return
    print(f"Top {min(limit, len(long_events))} long main-thread events:")
    for i, (dur, name, tid, tname, ev) in enumerate(long_events[:limit], start=1):
        print(f"{i}. {dur:.1f} ms — {name} — tid={tid} thread_name={tname}")
    print()
    print("Aggregated duration by event name (top 10):")
    sorted_by = sorted(by_name.items(), key=lambda kv: kv[1], reverse=True)
    for name, total in sorted_by[:10]:
        print(f"- {name}: {total:.1f} ms")


if __name__ == '__main__':
    if len(sys.argv) < 2:
        print("Usage: python tools/trace_analyzer.py path/to/trace.json")
        sys.exit(2)
    path = sys.argv[1]
    try:
        data = load_trace(path)
    except Exception as e:
        print(f"Failed to load trace: {e}")
        sys.exit(1)
    events = get_events(data)
    long_events, by_name = analyze(events)
    print_report(long_events, by_name)
