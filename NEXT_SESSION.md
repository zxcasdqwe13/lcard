# Handoff: E440 IIR filter test on Windows 10 VM

This file is for the next Kilo Code session started inside the Windows 10 VM
with the E14-440 connected.

## Environment (verified 2026-10-31)

- Repo root in the VM: `F:\` (the project is mounted/shared from
  `/home/torysh/my_share` on the Linux host).
- **Do not use `python`**: it is the Microsoft Store stub and silently produces
  no output. Use `py -3` (Python 3.14.10, 64-bit).
- `numpy` is **not installed** and the VM has no internet (`pypi.org` does not
  resolve). The filter model is pure Python, so the test still works.
  `filter-capture` falls back to CSV; the spectral-coverage part of the report
  is skipped when numpy is missing.
- Device: L-Card E14-440, serial `10T321757`.
- Working invocation:

  ```powershell
  $repo = "F:"
  Set-Location $repo
  $env:PYTHONPATH = "$repo\python\src"
  py -3 -m e440 info --bios "$repo\ADI_DSP\E440.BIO" --dll "$repo\MyCppLib\Lusbapi64.dll"
  ```

  `info` currently reports the BIOS defaults, not the test configuration:
  `ADC rate=100 kHz channels=8`, `PM[NTaps]=0x007F`, `PM[Decim]=0xFFFC`.
  The test command overwrites these with `ntaps=32`, `decimation=10`,
  `channels=2`.

## What was implemented

- `python/src/e440/filter_model.py`
  - bit-oriented Q15 model of `ch1processor`: 40-bit accumulator, RND on the
    initial calibration term and the final IIR term, optional 32-bit
    saturation, sparse FIR/IIR history, selectable accumulator word
    (`MR1`/`MR0`);
  - one-step prediction (uses recorded feedback history) and free-running
    simulation (mixed `MR0` history / `MR1` output);
  - `compare_signals`, delay/word search, capture loaders (NPY/NPZ/CSV/JSON),
    optional 99% input-bandwidth estimate.
- `python/src/e440/filter_test.py`
  - synthetic closed-loop mock, gain/bias fit, `auto_analyze` over
    `MR1/MR1`, `MR0/MR0`, `MR0/MR1` free-run and `MR1/MR1` free-run.
- CLI:
  - `filter-test` — compare a capture or mock with the model;
  - `filter-capture` — configure ADC/filters, optionally start the DAC, capture
    both ADC channels;
  - `acquire --start-dac` and `E440.start_dac()/stop_dac()` were added.
- `test_coeffs/fir_zero.hex`, `test_coeffs/iir_first_order.hex` — a controlled
  IIR-only test:
  - FIR: 64 zero taps (`ntaps=32`);
  - IIR: `[0xC000, 0, ...]` (`n2taps=2`), i.e. `y[n] = x[n] + 0.5*y[n-1]`.
- Tests: `py -3 -m unittest discover -s python/tests -v` (67 tests; numpy-based
  tests skip when numpy is absent).

## First action

Run the prepared script from the repo root:

```powershell
powershell -ExecutionPolicy Bypass -File F:\tools\run_filter_test.ps1
```

If the DAC channel is silent in the quick check, rerun with `-StartDac`:

```powershell
powershell -ExecutionPolicy Bypass -File F:\tools\run_filter_test.ps1 -StartDac
```

If the noise is on ADC channel 1 (the quick-check stats show it), use:

```powershell
powershell -ExecutionPolicy Bypass -File F:\tools\run_filter_test.ps1 -ProcSwitch 2 -StartDac
```

The script writes:

- `F:\filter_test_log.txt` — full console transcript;
- `F:\filter_capture.npz` or `F:\filter_capture.csv` — captured ADC channels;
- `F:\filter_report.json` — model comparison metrics.

## How to interpret the result

The report shows a candidate table. The key line is the best `mode` and
`word/output_word`:

- `mr1/mr1 one_step` passes — the device behaves like the intended `MR1`
  output with the recorded history; good.
- `mr0/mr1 free_run` passes — the device is on the current firmware path where
  the DAC FIFO/history receives `MR0` while `TX0` sends `MR1`.  This is the most
  likely match for the current `ADC-fir.H`.
- `mr0/mr0` matches — the DAC is fed from the FIFO and gets the low word; this
  is the suspicious path (with `b0=1.0`, `MR0` is mostly the rounding word).
- None match with reasonable correlation — likely one of:
  - the DAC is not running (try `-StartDac`);
  - the noise/DAC channels are swapped (try `-ProcSwitch 2`);
  - the external loop is not the filter input (ProcSwitch 3/4);
  - the shared DAC FIFO history is written by the other ADC channel, which the
    single-channel model does not represent;
  - the input is clipping (check quick-check min/max).

## Known limitations / next steps

1. The model currently handles **one** input channel and `ProcSwitch` 1 or 2.
   `ProcSwitch` 3/4 (sum/difference) requires a two-channel model.
2. The firmware writes `MR0` to the DAC FIFO in `ch1processor` while the
   inter-channel path uses `MR1`.  The test can distinguish the paths, but if
   neither matches, inspect how the two ADC channel calls overwrite the shared
   FIFO history.
3. `noise_lowpass_5e3kHz.wav` is a ~5 kHz lowpass (99% energy below ~7.3 kHz).
   With `rate=200 kHz`, 2 channels and `decimation=10`, the decimated Nyquist is
   5 kHz, so the file covers the passband but does not excite resonances above
   ~7 kHz.  For high-frequency stability, use broadband noise or an impulse
   after the first low-frequency comparison.
4. `filter-capture` overwrites the device filter parameters.  Restore the
   user's MATLAB/BIOS configuration after the experiment.
5. Do not commit unless the user explicitly asks.

## Manual commands (if the script is not used)

```powershell
$repo = "F:"
Set-Location $repo
$env:PYTHONPATH = "$repo\python\src"

py -3 -m e440 info --bios "$repo\ADI_DSP\E440.BIO" --dll "$repo\MyCppLib\Lusbapi64.dll"

py -3 -m e440 acquire --no-filters --blocks 2 --buffer-words 32768 `
  --channels 2 --control-table 128 131 --timeout-ms 120000 `
  --bios "$repo\ADI_DSP\E440.BIO" --dll "$repo\MyCppLib\Lusbapi64.dll" `
  --out "$repo\quick_check.npy"

py -3 -m e440 filter-capture `
  --blocks 2 --buffer-words 32768 --timeout-ms 120000 `
  --channels 2 --rate 200 --control-table 128 131 --proc-switch 1 `
  --decimation 10 --ntaps 32 --n2taps 2 `
  --fir-file "$repo\test_coeffs\fir_zero.hex" `
  --iir-file "$repo\test_coeffs\iir_first_order.hex" `
  --bios "$repo\ADI_DSP\E440.BIO" --dll "$repo\MyCppLib\Lusbapi64.dll" `
  --out "$repo\filter_capture.npz"

# use filter_capture.csv if numpy is absent and the command printed that path
py -3 -m e440 filter-test `
  --capture "$repo\filter_capture.csv" `
  --channels 2 --ntaps 32 --n2taps 2 --decimation 10 `
  --fir-file "$repo\test_coeffs\fir_zero.hex" `
  --iir-file "$repo\test_coeffs\iir_first_order.hex" `
  --rate-khz 200 --auto `
  --out-json "$repo\filter_report.json"
```


## Update 2026-11-01: MR1 feedback fix, Windows build, PASS

Root cause of the IIR mismatch: `ADI_DSP/ADC-fir.H` stored `MR0` (the low
accumulator word, which is `0x0000` for this filter) into the DAC/IIR history.
It was changed to store `MR1`; `E440.BIO` was rebuilt (md5
`FF85ADB06CD2508F73743BD0FE1CD07A`).  A model-free least-squares fit on the
loopback now gives `y = x + 0.48*y_prev` (R2 = 0.977), so the IIR coefficient
is actually applied.

DOSBox 0.74 cannot mount the VirtualBox shared folder `F:`, so the build runs
against a local mirror and copies `E440.BIO` back:

```powershell
powershell -ExecutionPolicy Bypass -File tools\build_bios.ps1
powershell -ExecutionPolicy Bypass -File tools\build_bios.ps1 -KeepSymbols
# -KeepSymbols keeps e440.exe/e440.sym in %TEMP%\e440-build\ADI_DSP for SIM2181
```

The end-to-end test now passes:

```powershell
powershell -ExecutionPolicy Bypass -File tools\run_filter_test.ps1
# PASS: corr=0.989, NRMSE=14.8%, SNR=16.6 dB, mode mr1/mr1 free_run
```

Defaults of the runner: `inter_kadr_delay=0.01 ms` (0.002 ms breaks the
loopback), `iir_step=1` (the IIR runs per frame, not per decimated sample),
`input_delay=2` (transport delay of the analog loop), inverted loopback
polarity, and `--max-nrmse 0.2`.  The remaining ~15% RMS error is the analog
loop noise floor (a plain x -> y fit gives the same residual); the correlation
criterion (0.95) is met.

Files changed in this update: `ADI_DSP/ADC-fir.H` (MR0 -> MR1),
`ADI_DSP/E440.BIO` (rebuilt), `python/src/e440/cli.py` (DAC prime, invert
output, input delay), `python/src/e440/filter_model.py` (input delay),
`tools/build_bios.ps1` (new Windows build runner), and
`tools/run_filter_test.ps1` (new defaults).
