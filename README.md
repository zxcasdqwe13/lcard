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
| `check_filt(...)` | `dev.read_dac_history()` (только старое ПЗУ `0x3FD0`) |

## Тестирование БИХ-фильтра в замкнутом контуре

Сценарий: на входной канал АЦП подаётся зацикленный белый шум, выход ЦАП
заводится на второй канал АЦП.  Команда `filter-test` сравнивает записанный
отклик устройства с фиксированной моделью `ch1processor` (Q15, 40-битный
аккумулятор, разреженная история БИХ с шагом децимации).

Проверка без железа:

```bash
python -m e440 filter-test --mock --samples 20000 --analog-noise 50
```

Запись и анализ реального отклика:

```bash
# запись замкнутого контура (DAC -> ADC ch1); --start-dac если ЦАП должен работать
python -m e440 filter-capture --blocks 20 --channels 2 --start-dac \
    --fir-file fir.hex --iir-file iir.hex --out filter_capture.npz

# первый проход: определить, какое слово/режим совпадает с устройством
python -m e440 filter-test --capture filter_capture.npz --channels 2 --auto

# точечная проверка с известными коэффициентами
python -m e440 filter-test --capture filter_capture.npz --channels 2 \
    --decimation 10 --fir-file fir.hex --iir-file iir.hex \
    --input-channel 0 --dac-channel 1 --refine-scale 2
```

`--input-channel` — канал с шумом, `--dac-channel` — канал с сигналом ЦАП.
Если в файле есть отдельный столбец `dac`, добавьте `--prefer-dac-column`.
`filter-capture` сохраняет `.npz` с массивом `adc` (`N x C`) и метаданными
(`ntaps`, `n2taps`, `decimation`, `rate_khz`, коэффициенты).
С `--mock` команда создаёт синтетический замкнутый контур (проверка формата и
сквозного сценария без железа).

Форматы capture:

- `.npy` — 1D чередующиеся отсчёты (`--channels 2`) или 2D `N x C`;
- `.npz` — массивы `adc` (2D) либо `ch0`, `ch1`, ... и опционально `dac`;
- `.csv`/`.txt` — столбцы `adc0,adc1,...,dac` (заголовок определяется
  автоматически);
- `.json` — `{"adc": [[...], [...]], "dac": [...]}`.

Модель и реальные данные сравниваются после подгонки линейного усиления и
смещения (масштаб ЦАП/АЦП в аналоговом кольце неизвестен).  Отчёт содержит
корреляцию, RMS/нормированную ошибку, SNR и оценку усиления кольца.
Модель предполагает один входной канал (`ProcSwitch` 1 или 2) и `shift=-1`
(история того же канала); для режимов суммы/разности (`ProcSwitch` 3/4) или
другого `shift` нужен отдельный сценарий.

Ключевые параметры модели:

- `--word mr1` (по умолчанию) — слово, записываемое в историю обратной связи;
- `--output-word` — наблюдаемое слово (по умолчанию совпадает с `--word`);
  текущая прошивка пишет в историю `MR0`, а на ЦАП через `TX0` отдаёт `MR1`,
  поэтому её точный режим — `--word mr0 --output-word mr1` (free-run);
- `--fir-delay`, `--iir-delay`, `--fir-step`, `--iir-step` — задержки и шаг
  истории в кадрах (по умолчанию `decimation`, `2/channels`, `decimation`,
  `decimation`);
- `--search` — перебор задержек и обоих слов аккумулятора;
- `--free-run` — модель использует собственную историю обратной связи, а не
  записанную;
- `--auto` — перебрать `MR1`/`MR0` и one-step/free-run и показать лучший
  вариант (удобно для первого запуска на реальных данных);
- `--refine-scale N` — уточнение масштаба обратной связи по данным;
- `--rate-khz` — частота АЦП для расчёта покрытия полосы (по умолчанию
  берётся из метаданных `.npz`).

Отчёт также показывает 99%-полосу входного шума, частоту Найквиста после
децимации и предупреждение о покрытии полосы.  Это важно для оценки
устойчивости: например, `noise_lowpass_5e3kHz.wav` имеет 99% энергии ниже
~7.3 кГц; при `rate=200 кГц`, 2 каналах и `decimation=10` полоса после
децимации (до 5 кГц) покрыта, но резонансы выше ~7 кГц таким сигналом почти
не возбуждаются.  Для проверки высокочастотной устойчивости нужен широкополосный
шум или импульсное воздействие.

Обратите внимание на несоответствие в `ADC-fir.H`: в историю/DAC FIFO
пишется `MR0` (`DM(I1,M1)=MR0`), а в `FiltBuf` и `TX0` — `MR1`.  При
`b0=0x8000` младшее слово почти постоянно (это в основном бит округления),
поэтому полезный сигнал должен соответствовать `MR1`.  Если реальные данные
лучше совпадают с `--word mr0 --output-word mr0`, это указывает на то, что
DAC тактируется из FIFO и получает младшее слово; если лучше с
`--word mr0 --output-word mr1` — работает путь через `TX0`.

### Запуск в Windows VM с реальным модулем

В VM `python` — заглушка Microsoft Store; используйте `py -3` (64-bit).
`numpy` может отсутствовать: `filter-capture` тогда пишет CSV, а модель и
сравнение работают на чистом Python.

```powershell
powershell -ExecutionPolicy Bypass -File F:\tools\run_filter_test.ps1
# если ЦАП молчит:
powershell -ExecutionPolicy Bypass -File F:\tools\run_filter_test.ps1 -StartDac
# если шум на втором канале АЦП:
powershell -ExecutionPolicy Bypass -File F:\tools\run_filter_test.ps1 -ProcSwitch 2 -StartDac
```

Скрипт сохраняет `filter_test_log.txt`, `filter_capture.npz`/`.csv` и
`filter_report.json`.  Подробный handoff — в `NEXT_SESSION.md`.

## Разработка

```bash
export PYTHONPATH=$PWD/python/src
python -m unittest discover -s python/tests -v
```

Тесты на Linux работают на `MockBackend` и проверяют карту памяти, упаковку
коэффициентов, размеры ctypes-структур и полный сценарий «открыть → залить
BIOS → настроить фильтр → собрать данные».

Подробности для агентов и правила работы с репозиторием — в `AGENTS.md`.
