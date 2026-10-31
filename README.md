# ADI_DSP — LCard E440: прошивка + управление из Python

Проект содержит две независимые части:

1. **Прошивка LBIOS** для DSP ADSP-2181 модуля LCard E14-440 (ассемблер 21XX).
   Исходники: `ADI_DSP/*.DSP`, `ADI_DSP/*.H`. Результат сборки: `ADI_DSP/E440.BIO`.
2. **Управление модулем** с ПК. Исторически — MATLAB-скрипты в корне
   (`LCardControl.m`, `main_ir.m`) через `clib.MyCppLib`. Теперь есть
   Python-пакет `python/`, который работает с тем же `Lusbapi64.dll`.

## Структура репозитория

```
ADI_DSP/                 прошивка и DOS-инструменты ассемблера/линкера
  21XX/                  SDK ADSP-21xx (BIN, INCLUDE, LIB, EXAMPLES)
  E440.DSP               основная программа LBIOS
  ADC.H, ADC-fir.H       обработка АЦП, КИХ/БИХ фильтрация
  CONST.H, VAR*.H        карта памяти DSP
  param.h, user-par.h    параметры фильтра по умолчанию
  GoDsp.bat              оригинальная сборка (Windows/DOS)
LCardControl.m           MATLAB-обвязка (эталон поведения)
main_ir.m                MATLAB-скрипт настройки и сбора
MyCppLib/, xzMyCppLib/   DLL LCard (Lusbapi64.dll, обёртка для MATLAB)
python/                  Python-пакет e440 + тесты + примеры
tools/                   вспомогательные скрипты (сборка прошивки)
stuffs/                  локальный SDK L-Card, архивы, старые версии (не в git)
```

## Сборка прошивки

Оригинальный `ADI_DSP/GoDsp.bat` требует DOS и путей `C:\ADI_DSP\...`.
На Linux сборка воспроизводится в DOSBox:

```bash
tools/build_bios.sh              # соберёт ADI_DSP/E440.BIO
tools/build_bios.sh --clean      # удалить промежуточные файлы после сборки
```

Скрипт монтирует корень репозитория как `C:` и запускает `GoDsp.bat`
внутри DOSBox с изолированным конфигом (~/.dosbox не используется).
Проверено: результат байт-в-байт совпадает с текущим `E440.BIO`.

На Windows можно по-прежнему запускать `GoDsp.bat` из `ADI_DSP/`.

## Python: быстрый старт

Требуется **64-битный Python** (DLL `Lusbapi64.dll` — x86-64) и Windows 10
для работы с реальным модулем. На Windows должны быть установлены **драйверы
L-Card** для E14-440; без них `OpenLDevice` не найдёт устройство. Ядро (карта
памяти, коэффициенты, mock-бэкенд) работает и на Linux.

```bash
# без установки пакета
export PYTHONPATH=$PWD/python/src

python -m e440 selftest                  # полный сценарий на симуляторе
python -m e440 info --mock               # проверка без железа
python -m e440 info --bios ADI_DSP/E440.BIO          # реальный модуль (Windows)
python -m e440 acquire --blocks 10 --out data.npy
```

Если `Lusbapi64.dll` лежит не в `MyCppLib/`, укажите путь:
`--dll C:\path\to\Lusbapi64.dll` или переменную окружения `E440_LUSBAPI64`.

Минимальный пример:

```python
from e440 import E440, FilterConfig

with E440.open() as dev:
    dev.load_bios(r"ADI_DSP\E440.bio")
    dev.test_module()
    print(dev.description.company_name, dev.description.device_name)

    dev.configure_adc(rate=200.0, channels=2, inter_kadr_delay=0.002,
                      control_table=[128, 131])  # MATLAB: [0 3]+2*64

    dev.apply_filters(FilterConfig(
        ntaps=32,
        fir_coef1=[0x8000] + [0] * 63,
        decimation=10,          # шаг -10 или -20 отсчётов, см. ниже
        channels=2,
        proc_switch=1,
    ))

    for block in dev.acquire_blocks(blocks=10, timeout_ms=3_500_000):
        print(len(block), min(block), max(block))
```

Порт `main_ir.m` целиком: `python/examples/main_ir_port.py`.

## Карта памяти DSP (ключевое)

`VariableBaseAddress = 0x30`, программа — с `0x400`.

| Адрес | Имя | Назначение |
|---|---|---|
| `0x7B` | `NTapsAddr` | число КИХ-коэффициентов |
| `0x7C` | `DACAmpAddr` | усиление ЦАП (`2^(amp-4)`) |
| `0x7D` | `ShiftAddr` | сдвиг окна КИХ |
| `0x7E` | `ProcSwitchAddr` | режим обработки (1..4) |
| `0x7F` | `DecimAddr` | шаг децимации, отрицательный |
| `0x72` | `N2TapsAddr` | число БИХ-коэффициентов |
| `0x80` | `ControlTableAddr` | таблица каналов АЦП (128 слов) |
| `0x300` | `FirCoefAddr1` | КИХ-коэффициенты канала 1 (64) |
| `0x380` | `FirCoefAddr2` | КИХ-коэффициенты канала 2 (64) |
| `0x3C0` | `IirBCoefAddr` | БИХ-коэффициенты B (8) |

Важные соглашения, унаследованные от MATLAB-обвязки:

- Слова памяти программ передаются в `PUT_PM_*` **сдвинутыми влево на 8**
  (24-битное значение в старших битах 32-битного слова). Обёртка делает это
  автоматически.
- `DecimAddr` хранит **отрицательный шаг в отсчётах АЦП**. По журналу изменений
  для двух каналов шаг равен `-2*decim`. В старом `main_ir.m` записывалось
  `0x10000 - DecimUser`, то есть шаг `-DecimUser`; при двух каналах это даёт
  децимацию `DecimUser/2`, поэтому значение нужно удваивать.
  В Python: `FilterConfig(decimation=D, channels=C)` даёт слово
  `(0x10000 - D*C) & 0xFFFF`; при необходимости задайте `decim_word` вручную.
- `ReleaseLInstance()` в SDK закрывает устройство и делает `delete this`.
  Повторно вызывать `CloseLDevice()` после неё нельзя (в MATLAB это делается,
  но это use-after-free). Python-обёртка вызывает только `ReleaseLInstance()`.

## Python ↔ MATLAB

| MATLAB | Python |
|---|---|
| `e440_interface.OpenLDevice(i)` | `E440.open()` |
| `e440_interface.LOAD_MODULE(path)` | `dev.load_bios(path)` |
| `e440_interface.TEST_MODULE()` | `dev.test_module()` |
| `GET/SET_ADC_PARS` | `dev.get_adc_params()` / `dev.configure_adc(...)` |
| `PUT_PM_WORD/GET_PM_WORD` | `dev.write_pm_word()` / `dev.read_pm_word()` |
| `PUT_PM_ARRAY` | `dev.write_pm_array()` |
| `write_iir_coef` | `dev.write_iir_coefs()` |
| `run_ADC(...)` | `dev.acquire_blocks(...)` |
| `check_filt(...)` | `dev.read_dac_history()` |

## Разработка

```bash
export PYTHONPATH=$PWD/python/src
python -m unittest discover -s python/tests -v
```

Тесты на Linux работают на `MockBackend` и проверяют карту памяти, упаковку
коэффициентов, размеры ctypes-структур и полный сценарий «открыть → залить
BIOS → настроить фильтр → собрать данные».

Подробности для агентов и правила работы с репозиторием — в `AGENTS.md`.
