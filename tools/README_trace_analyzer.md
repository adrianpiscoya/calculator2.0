Trace analyzer helper

Usage (PowerShell):

1. Ensure Python 3 is installed.
2. From repository root run:

   python .\tools\trace_analyzer.py .\assets\icons\buttons\dart_devtools_2025-09-13_14_05_55.488.json

The script prints the top long main-thread events (threshold 16 ms) and aggregated durations per event name.

If the trace is large, consider zipping it before uploading.
