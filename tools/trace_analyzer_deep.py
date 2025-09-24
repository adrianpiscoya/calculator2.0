#!/usr/bin/env python3
"""
Deeper DevTools trace analyzer.
- Looks for events with 'dur' or 'ts' in any thread
- Reports events above a lower threshold (8ms) and groups by thread name/pid/tid
- Attempts to show stack or args "flutter" category entries
"""
import json
import sys
from collections import defaultdict

MIN_MS = 8.0


def load(path):
    with open(path, 'r', encoding='utf-8') as f:
        return json.load(f)


def get_events(data):
    if isinstance(data, dict):
        for k in ('traceEvents', 'events', 'traces'):
            if k in data:
                return data[k]
    if isinstance(data, list):
        return data
    return []


def extract_name(ev):
    name = ev.get('name') or ev.get('ph') or ev.get('cat')
    return name


def extract_thread(ev):
    tname = None
    if isinstance(ev.get('args'), dict):
        a = ev.get('args')
        tname = a.get('thread_name') or a.get('name') or a.get('label')
    tid = ev.get('tid') or ev.get('pid')
    return tid, tname


def dur_ms(ev):
    if 'dur' in ev:
        try:
            return float(ev['dur'])/1000.0
        except:
            pass
    # some traces use 'tDur' or nested timestamps
    for k in ('tDur','duration'):
        if k in ev:
            try:
                return float(ev[k])/1000.0
            except:
                pass
    return None


def analyze(events):
    long = []
    by_thread = defaultdict(float)
    by_name = defaultdict(float)
    for ev in events:
        if not isinstance(ev, dict):
            continue
        d = dur_ms(ev)
        if d is None:
            continue
        if d >= MIN_MS:
            name = extract_name(ev)
            tid, tname = extract_thread(ev)
            long.append((d, name, tid, tname, ev))
            key = f"tid={tid} thread={tname}"
            by_thread[key] += d
            by_name[name] += d
    long.sort(reverse=True)
    return long, by_thread, by_name


def print_report(long, by_thread, by_name, limit=30):
    print(f"Deeper trace analyzer (threshold {MIN_MS}ms)")
    if not long:
        print("No events above threshold found.")
        return
    print(f"Top {min(limit, len(long))} events:")
    for i,(d,name,tid,tname,ev) in enumerate(long[:limit],1):
        print(f"{i}. {d:.1f}ms — {name} — tid={tid} thread_name={tname}")
    print('\nAggregated by thread:')
    for k,v in sorted(by_thread.items(), key=lambda kv: kv[1], reverse=True):
        print(f"- {k}: {v:.1f}ms")
    print('\nAggregated by name:')
    for k,v in sorted(by_name.items(), key=lambda kv: kv[1], reverse=True)[:20]:
        print(f"- {k}: {v:.1f}ms")


if __name__=='__main__':
    if len(sys.argv)<2:
        print('Usage: python tools/trace_analyzer_deep.py path/to/trace.json')
        sys.exit(2)
    path=sys.argv[1]
    data=load(path)
    events=get_events(data)
    long,by_thread,by_name=analyze(events)
    print_report(long,by_thread,by_name)
