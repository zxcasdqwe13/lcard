# AGENTS.md

## Что это

Драйвер/BIOS (LBIOS) для DSP ADSP-2181 модуля LCard E14-440 на ассемблере
21XX + MATLAB/Python-скрипты управления. Прошивка лежит в `ADI_DSP/`,
Python-обёртка — в `python/`.

## Быстрые команды

```bash
# Сборка прошивки (Linux, DOSBox 0.74; на Windows работает ADI_DSP/GoDsp.bat)
tools/build_bios.sh
tools/build_bios.sh --clean

# Python: тесты без железа (Linux/Windows)
export PYTHONPATH=$PWD/python/src
python -m unittest discover -s python/tests -v

# Python: симулятор (Linux/Windows, без драйвера)
python -m e440 selftest
python -m e440 info --mock
python -m e440 acquire --mock --blocks 2
python -m e440 filter-test --mock --samples 20000 --analog-noise 50
python -m e440 filter-capture --mock --blocks 2 --out /tmp/filter_capture.npz

# Python: реальный модуль (Windows 10, 64-bit Python, драйвер L-Card)
# В VM использовать py -3, не python (см. раздел ниже).
py -3 -m e440 info --bios ADI_DSP\E440.BIO --dll MyCppLib\Lusbapi64.dll
py -3 -m e440 acquire --blocks 10 --out data.npy
```

## Windows VM (реальный E14-440)

- В VM `python` в PATH — заглушка Microsoft Store и молча ничего не печатает.
  Использовать `py -3` (проверено: Python 3.14.10, 64-bit).
- `numpy` в VM нет и интернета нет; модель БИХ работает на чистом Python.
  `filter-capture` без numpy пишет CSV, `filter-test` читает CSV и считает
  корреляцию/ошибку, но пропускает спектральную оценку полосы.
- Проверенный запуск:
  `py -3 -m e440 info --bios F:\ADI_DSP\E440.BIO --dll F:\MyCppLib\Lusbapi64.dll`
- Сквозной сценарий: `powershell -ExecutionPolicy Bypass -File tools\run_filter_test.ps1`
  (при необходимости `-StartDac`, `-ProcSwitch 2`).
- Подробный handoff и текущие ограничения модели — в `NEXT_SESSION.md`.

## Карта проекта

- `ADI_DSP/E440.DSP` — точка входа LBIOS (`StartBios`, `Irq1Handler`,
  `CommandProcessing`).
- `ADI_DSP/CONST.H` — все адреса переменных/регистров DSP.
- `ADI_DSP/VAR.H`, `VAR-user.H`, `user-par.h`, `param.h` — размещение
  переменных и параметры фильтра по умолчанию.
- `ADI_DSP/ADC.H`, `ADC-fir.H`, `DAC.H`, `FIFO.H` — обработка потоков.
- `ADI_DSP/GoDsp.bat` — эталонная последовательность сборки.
- `LCardControl.m`, `main_ir.m` — эталон поведения MATLAB-обвязки.
- `tools/run_filter_test.ps1` — сквозной запуск теста БИХ в Windows VM.
- `NEXT_SESSION.md` — handoff для продолжения на Windows с устройством.
- `python/src/e440/` — пакет (запускать с `PYTHONPATH=python/src`):
  - `dsp.py` — карта памяти, Q15, упаковка PM (кроссплатформенно);
  - `model.py` — dataclass-модели параметров;
  - `structs.py` — ctypes-структуры SDK (`#pragma pack(1)`);
  - `backend/windows.py` — `ctypes` + `Lusbapi64.dll` (vtable `ILE440`);
  - `backend/mock.py` — симулятор для Linux/тестов;
  - `device.py` — высокоуровневый `E440`;
  - `acquisition.py` — двойная буферизация асинхронного чтения;
  - `cli.py` — `python -m e440 {info,acquire,selftest,filter-test,filter-capture}`.
  - `filter_model.py` — фиксированная Q15-модель `ch1processor` и метрики
    сравнения; `filter_test.py` — замкнутый контур и анализ capture.
- `stuffs/DLL/` — локальный SDK L-Card (заголовки `Lusbapi.h`,
  `LusbapiTypes.h`, исходники `E440.cpp`, `.def`, MinGW `.a`). В git не входит.

## Инварианты и подводные камни

1. **Кодировка legacy-файлов** — CP1251. Не пересохранять `.H`/`.DSP`/`.bat`
   в UTF-8: сломаются комментарии и, возможно, сборка. Python-файлы — UTF-8.
2. **PM-слова 24-битные, выровнены влево** в 32-битном контейнере:
   `PUT_PM_WORD/PUT_PM_ARRAY` получают `value << 8`, `GET_*` возвращают
   значение, которое надо сдвинуть `>> 8`. Это делает `dsp.pm_pack/pm_unpack`.
3. **`ReleaseLInstance()` удаляет объект** (`delete this`) и закрывает
   устройство. Не вызывать после неё `CloseLDevice()`.
4. **`long` в API — 32 бита** (Windows LLP64). В ctypes использовать
   `c_uint32/c_int32`, а не `c_long` (на Linux `c_long` — 64 бита).
5. **DLL только x86-64** — Python должен быть 64-битным.
6. **Двойная буферизация**: `ReadData` асинхронный, событие —
   `OVERLAPPED.hEvent` (auto-reset). Ждать `WaitForSingleObject`, таймаут —
   код `258` (`WAIT_TIMEOUT`). В async-режиме `NumberOfWordsPassed`
   заполняется при постановке запроса (часто 0), поэтому фактический объём
   берётся через `GetOverlappedResult`.
7. **Децимация**: `DecimAddr` — отрицательный шаг в отсчётах АЦП. Для двух
   каналов шаг `-2*decim`; в старом MATLAB-коде была неоднозначность.
   `FilterConfig.decimation` + `channels` считает `0x10000 - decimation*channels`.
8. **`MyCppLibInterface.dll` — MATLAB pass-through**, у неё нет C-экспортов,
   кроме `cppGetPassThrough`. Python должен ходить напрямую в
   `Lusbapi64.dll` через `CreateLInstance("e440")`.
9. **Драйвер L-Card** должен быть установлен на Windows; `Lusbapi64.dll`
   берётся из `MyCppLib/`, `--dll` или `E440_LUSBAPI64`. Без устройства
   используйте `MockBackend`/`--mock`.
10. **`stuffs/`** игнорируется git (`.gitignore` + `.git/info/exclude`).
   Не добавлять туда нужные проекту файлы; нужное выносить в `python/` или
   `tools/`.

## Стиль

- Python: стандартная библиотека + опционально NumPy; без обязательных
  внешних зависимостей. Типизация, dataclass, docstrings.
- Не менять поведение MATLAB-скриптов без явной просьбы: они остаются
  эталоном для сверки.
- Коммиты — только по явной просьбе пользователя.
