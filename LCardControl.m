%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%     _ ___ _   _ _____   ____      _    ____  %%%
%%%    | |_ _| | | |_   _| |  _ \    / \  / ___| %%%
%%% _  | || || |_| | | |   | |_) |  / _ \ \___ \ %%%
%%%| |_| || ||  _  | | |   |  _ <  / ___ \ ___) |%%%
%%% \___/|___|_| |_| |_|   |_| \_\/_/   \_\____/ %%%
%%%                                              %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Version 0.4 - EA
%
clear all
close all
% 
BaseAddr = 0x30;
Addr = {};
% ---- Количество элементов КИХ-фильтра -----
NTaps = 64;     Addr.NTapsAdrdr = BaseAddr + 0x4B;
% ---- Усиление ЦАП -----
DACAmp = 0;     Addr.DACAmpAddr = BaseAddr + 0x4C;
% DACRate= 0xFFFF;       Addr.DACRateAddr = BaseAddr + 0x38;
% ---- Сдвиг КИХ фильтрации -----
% по умолчанию - сдвиг на -1 дает последний отсчет АЦП
Shift = 0xFFFF;      Addr.ShiftAddr = BaseAddr + 0x4D;
% ---- Режим фильтрации -----
ProcSwitch = 1; Addr.ProcSwitchAddr = BaseAddr + 0x4E;
% ---- Шаг децимации -----
% шаг без децимации для одного канала 0xFFFF=-1, шаг для двух каналов
% каналов 0xFFFE=-2, 
DecimUser=20;    
 Decim = 0x10000-DecimUser;   
   Addr.DecimAddr = BaseAddr + 0x4F;
% ---- % Массив новых коэффициентов FIR фильтра 1 -----
% FirCoef1(:,1) = ((65280:(65280+63)))';  %0xff00 + ii
% FirCoef1(:,1) = zeros(64,1); FirCoef1(1,1) = 0x8000;
% f=fopen('fir64.dat'); ma=fscanf(f,'%x\n'); fclose(f); FirCoef1(:,1) = ma;
ma=fi(sin([0:63]*2*pi/32).*hann(64)',1,16,15)/2;
FirCoef1(:,1) = sscanf(ma.hex,'%x\n');

Addr.FirCoef1Addr = 0x300;
% ---- % Массив новых коэффициентов IIR фильтра -----
IirCoef1(:,1) = [1; 2; 1; 1; 8; 1; 1]*0;  % 7 шт
Addr.IirCoef1Addr = 0x3c0;
%
%%% -- Настройки АЦП -- %%%
%
% Количество циклов опроса АЦП
Nloop = 3;
% Режим обновления графика%
append=0;
% Время ожидания новой порции значений АЦП
TimeWait = 35000;
% ---- Частота -----
AdcRate = 200;
% ---- Количество каналов -----
NChannels = 2;
% ---- Калибровка -----
IsCorrectionEnabled = false;
% ---- Таблица каналов -----
ControlTable = [[0 3]]+1*64+0*32;

% Функция записи данных в память программ
% write_PM_varible(Значение, Адрес)

% Функция записи массива данных в память программ
% write_PM_array(Вектор-столбец, Адрес)

% Функция чтения данных в памяти программ
% Значение = read_PM_varible(Адрес)

% Функция чтения данных буфера АЦП в асинхронном режиме
% последний буфер = run_ADC(Кол-во циклов, Время ожидания, Обновление графика)

% Функция проверки записанного значения
% check_write_by_read(Ответ, Образец, Адрес)

% Функция записи БИХ фильтра
% write_iir_coef(Вектор-стобец, Адрес)

% Функция проверки работы фильтра по истории ЦАП и АЦП
% check_filt(last_data, FirCoef1, Decim, Shift, IirCoef1, BaseAddr);

% Структура интерфеса LCard
global e440_interface;
% Структура сообщения об ошибке LCard
global lastErrInfo;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ну, понеслась
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Инициализируем интерфейс управления
e440_interface = clib.MyCppLib.GetILE440Instance();
% Инициализируем структуру сообщения об ошибке
lastErrInfo = clib.MyCppLib.LAST_ERROR_INFO_LUSBAPI();
% Инициализируем структуру параметров АЦП
adc_param=clib.MyCppLib.ADC_PARS_E440();

% Проверяем подключение устрйства
for i=0:8
    if e440_interface.OpenLDevice(i)
        disp(['Модуль подключен по USB, порт ', num2str(i)])
        break
    end
    if i==8
        e440_interface.ReleaseLInstance;
        error("Ошибка соединения");
    end
end

% Загружаем LBIOS из файла
%if e440_interface.LOAD_MODULE('C:\Program Files (x86)\LCard\LGRAPH\E440.bio') %  биос штатный
%if e440_interface.LOAD_MODULE('C:\Users\lab21_3\Documents\MATLAB\ADI_DSP\E440.bio') %  биос модифицированный
if (e440_interface.LOAD_MODULE('E440.bio')) % биос модифицирванный с БИХ
    disp('Bios загружен из файла')
else
    check_error(false);
    e440_interface.ReleaseLInstance;
    error('Ошибка загрузки bios из файла')
end

%test module
if e440_interface.TEST_MODULE()
    disp('Проверка модуля - OK')
else
    check_error(false);
    e440_interface.ReleaseLInstance;
    error('Ошибка проверки модуля')
end

disp('Получаем описание модуля');
descr=clib.MyCppLib.MODULE_DESCRIPTION_E440();
e440_interface.GET_MODULE_DESCRIPTION(descr);

% Проверяем описание
fprintf('Имя модуля: %s\n', char(uint8(descr.Module.CompanyName)))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Устанавливаем параметры АЦП');
e440_interface.STOP_ADC();

e440_interface.GET_ADC_PARS(adc_param);
adc_param.AdcRate=AdcRate;
adc_param.IsCorrectionEnabled = IsCorrectionEnabled;
adc_param.ChannelsQuantity=NChannels;
adc_param.InterKadrDelay=0.002;
arr_def(adc_param.ControlTable, ControlTable);

e440_interface.SET_ADC_PARS(adc_param);
e440_interface.GET_ADC_PARS(adc_param);
check_error(false);
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Параметры фильтрации:');

% Устанавливаем количество элементов КИХ-фильтра
write_PM_varible(NTaps, Addr.NTapsAdrdr);
fprintf('NTaps: %d\n', read_PM_varible(Addr.NTapsAdrdr))
% Устанавливаем усиление ЦАП
write_PM_varible(DACAmp, Addr.DACAmpAddr);
fprintf('DACAmp: %d\n', read_PM_varible(Addr.DACAmpAddr))
% Устанавливаем сдвиг КИХ фильтрации
write_PM_varible(Shift, Addr.ShiftAddr);
fprintf('Shift: %d\n', read_PM_varible(Addr.ShiftAddr))
% Устанавливаем режим фильтрации
write_PM_varible(ProcSwitch, Addr.ProcSwitchAddr);
fprintf('ProcSwitch: %d\n', read_PM_varible(Addr.ProcSwitchAddr))
% Устанавливаем шаг децимации
write_PM_varible(Decim, Addr.DecimAddr);
fprintf('Decim: %d\n', read_PM_varible(Addr.DecimAddr))
%Устанавливаем частоту ЦАП
% write_PM_varible(DACRate, Addr.DACRateAddr);
% fprintf('DAC Rate: %d\n', read_PM_varible(Addr.DecimAddr))



% Запишем массив новых коэффициентов фильтра в E14-440
write_PM_array(FirCoef1, Addr.FirCoef1Addr);
write_iir_coef(IirCoef1, Addr.IirCoef1Addr);


disp('  Проверяем массив коэффициентов FirCoef1 в устройстве, читая  по одному элементу')
% Для проверки можно использовать значение  0xffc1, которое устанавливается по умолчанию (dfilt) в 8-м элементе фильтра FirCoef1
% Переменная и массив для работы с данными памяти программ
% pm_word=clib.array.MyCppLib.Long(1);
% get_PM_res=e440_interface.GET_PM_WORD(0x307, pm_word);
% dec2hex(bitshift(uint32(pm_word),-8))
fprintf('FirCoef1[0]: %x, FirCoef1[1]: %x, FirCoef1[63]: %x\n', read_PM_varible(0x300), read_PM_varible(0x301), read_PM_varible(0x33f))


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Включаем трансляцию с АЦП');

% Читаем данные буфера АЦП в асинхронном режиме
last_data = run_ADC(Nloop, TimeWait, append,AdcRate/NChannels);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('В последний раз проверяем сообщение об ошибке:')
check_error(true);

fprintf('Максимальное значение в буфере %d\n',max(last_data));


% e440_interface.PUT_DM_WORD(0x3FD0, 22)
%
% Проверим работу фильтра по истории ЦАП и АЦП
% check_filt(last_data, FirCoef1, Decim, Shift, IirCoef1, BaseAddr);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Закрываемся
e440_interface.ReleaseLInstance();
if e440_interface.CloseLDevice()
    disp ('Соединение закрыто')
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function check_error(forcePrint)
global e440_interface;
global lastErrInfo;

e440_interface.GetLastErrorInfo(lastErrInfo);
if(lastErrInfo.ErrorNumber ~= 100 || forcePrint == true)
    fprintf('\tLCard: %s\n', native2unicode(lastErrInfo.ErrorString, 'UTF-8'))
end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Функция проверки записанного значения
function check_write_by_read(res, Sample, VarAdrr)
    global e440_interface;
    if(res == 1)
        % Проверяем запись
        CurrentValue = read_PM_varible(VarAdrr);
        if (Sample ~= CurrentValue)
            e440_interface.ReleaseLInstance;
            error('Ошибка записи по адрессу %x: значение записи %d отличается от исходного варианта %d', VarAdrr, CurrentValue, Sample);
        end
    else
        check_error(false);
        e440_interface.ReleaseLInstance;
        error('Ошибка записи по адрессу %x', VarAdrr);
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Значения в памяти програм хранятся в элементе памяти 24 бит, поэтому "контейнер" long (32бита) нужно модифицировать с помощью сдвига на 8 бит
% При чтении сдвигаем вправо, при записе сдвигаем влево


% Функция записи массива данных в память программ
function res = write_PM_array(VarArray, VarAdrr)
global e440_interface;
pm_array=clib.array.MyCppLib.Long(64);
res = 0;
[rw_ar, col_ar] = size(VarArray);

% TODO: размер 64 элемента зафиксирован в dll. Нужно сделать изменяемым без без пересборки dll
if((rw_ar ~= 64) || (col_ar ~= 1))
    e440_interface.ReleaseLInstance;
    error("Неверный размер массива")
end
% Для памяти программ каждое значение сдвигаем на
% 8 бит влево (32 бита -> 24 бита)
%%%%%%%%%%%%%
for ii=1:rw_ar
    pm_array(ii) = bitshift(uint32(VarArray(ii,1)),8); % VarArray << 8
end
%%%%%%%%%%%%%

res = e440_interface.PUT_PM_ARRAY(VarAdrr, 64, pm_array);
% Проверяем запись последнего элементаы
check_write_by_read(res, VarArray(end,1), VarAdrr + 63);

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Функция записи данных в памяти программ
function res = write_PM_varible(VarValue, VarAdrr)
    global e440_interface;
    % Переменная для работы с данными памяти программ
    local_pm_word=clib.array.MyCppLib.Long(1);

    local_pm_word(1)=bitshift(uint32(VarValue),8);
    res = e440_interface.PUT_PM_WORD(uint16(VarAdrr), local_pm_word(1));
    % Проверяем запись
    check_write_by_read(res, VarValue, VarAdrr);

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Функция чтения данных в памяти программ
function res = read_PM_varible(VarAdrr)

    global e440_interface;

    pm_read_res = 0;
    % Переменная для работы с данными памяти программ
    local_pm_word=clib.array.MyCppLib.Long(1);

    
    pm_read_res = e440_interface.GET_PM_WORD(uint16(VarAdrr), local_pm_word);
 
    if(pm_read_res == 1)
        res = bitshift(uint32(local_pm_word(1)),-8);
    else
        check_error(false);
        e440_interface.ReleaseLInstance;
        error('Ошибка чтения данных по адрессу %x', VarAdrr);
    end

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Функция чтения данных буфера АЦП в асинхронном режиме
function last_data = run_ADC(Nloop, WaitTime, append,SampFreq)

global e440_interface;
last_data = 0;

% Выходим без ошибки, если циклов меньше 1
if (Nloop<1)
    return;
end

disp('Стоп АЦП');
e440_interface.STOP_ADC();



%req=clib.MyCppLib.IO_REQUEST_LUSBAPI();
% массив IO_REQUEST_LUSBAPI для попеременоого чтения
ioReq = clib.array.MyCppLib.IO_REQUEST_LUSBAPI(2);

ioReq(1).TimeOut=WaitTime;
ioReq(2).TimeOut=WaitTime;

%%%%%%%
buffer_count = 256*1024;
%dataInt16 = int16(ones(1,buffer_count));
%Buffer = clib.array.MyCppLib.Short(dataInt16);
Buffer_1 = clib.array.MyCppLib.Short(buffer_count);
Buffer_2 = clib.array.MyCppLib.Short(buffer_count);

clib.MyCppLib.SetBuffer(ioReq(1), Buffer_1, buffer_count);
clib.MyCppLib.SetBuffer(ioReq(2), Buffer_2, buffer_count);

buf_arr = {Buffer_1 Buffer_2};
%%%%%%%
% req.NumberOfWordsPassed = 0x0;

ov_1 = clib.MyCppLib.myOVERLAPPED;
ov_2 = clib.MyCppLib.myOVERLAPPED;

clib.MyCppLib.SetOverlapped(ioReq(1), ov_1, false, false);
clib.MyCppLib.SetOverlapped(ioReq(2), ov_2, false, false);



%fileID = fopen('myfile.bin','ab');
% h = animatedline('Color', 'b', 'LineWidth', 2);
% window_width = 100;
% h.MaximumNumPoints = window_width;
% grid on;
% xlim([0 window_width]);
% y_min = 0;
% y_max = 300;
% ylim([y_min y_max]);
total_points = 0;

figure;
hAx=axes(gcf);

disp('Старт АЦП');
e440_interface.START_ADC();


requestNumber=1;
e440_interface.ReadData(ioReq(requestNumber));
for ii=1:Nloop

    requestNumber = 3 - requestNumber;

    e440_interface.ReadData(ioReq(requestNumber));

    %disp('Test Asinc OK');

    status = clib.MyCppLib.MyWaitForEvent(ioReq(3 - requestNumber), WaitTime);

    if (status == 258)
        clib.MyCppLib.MyCloseHandle(ioReq(1));
        clib.MyCppLib.MyCloseHandle(ioReq(2));
        check_error(false);
        e440_interface.ReleaseLInstance;
        error('timeout');
    end
% pause(1)
    % запись в файл
    % if(status==0)
    %     fwrite(fileID, int16(Buffer_1), 'int16');
    % end

    xnew = (total_points + 1):(total_points + buffer_count);
    ynew =  int16(buf_arr{3-requestNumber});
    
 

    if append==0
           nexttile(1);
    plot(xnew(1:2:end)-min(xnew(1:2:end)),ynew(1:2:end));
    hold on;
    plot(xnew(2:2:end)-min(xnew(1:2:end)),ynew(2:2:end));
        hold off
    end

    if append==0
           nexttile(1);
        plot((xnew(1:2:end)-min(xnew(1:2:end)))/SampFreq,ynew(1:2:end));
        hold on;
        plot(xnew(2:2:end)-min(xnew(1:2:end))/SampFreq,ynew(2:2:end));
        hold off
    end

    if append==0
           nexttile(1);
        plot((xnew(1:2:end))/SampFreq,ynew(1:2:end));
        hold on;
        plot((xnew(2:2:end))/SampFreq,ynew(2:2:end));
        
    end

    nexttile(2);
    [sp,ff,~]=spectrogram(double(ynew(1:2:end)),hann(8192),4096,[],200);
    spm=mean(abs(sp).^2,2);
    loglog(ff(2:end),spm(2:end));
    hold on
    [sp,ff,~]=spectrogram(double(ynew(2:2:end)),hann(8192),4096,[],200);
    spm=mean(abs(sp).^2,2);
    loglog(ff(2:end),spm(2:end));
    hold off   
    drawnow limitrate;

    % if (status==0)
    %     clib.MyCppLib.MyResetEvent(ioReq(1))
    % end

    total_points = total_points + buffer_count;


end

% fclose(fileID);


disp('Стоп АЦП');
e440_interface.STOP_ADC();

clib.MyCppLib.MyCloseHandle(ioReq(1));
clib.MyCppLib.MyCloseHandle(ioReq(2));

if (requestNumber==1)
    last_data = int16(Buffer_1);
else
    last_data = int16(Buffer_2);
end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function arr_def(arr,input)
for i=1:size(input,2)
    arr(i)=uint8(input(i));
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function write_iir_coef(array, VarAdrr)
for ii=0:size(array,1)-1
    write_PM_varible(array(ii+1,1),VarAdrr+ii);
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function dac_model = check_filt(adc_samples, fir_filt, fir_decim, fir_shift, iir_filt, BaseAddr)
global e440_interface;
N = 8;
dac_history_unsorted = zeros(1,N);
% Переменная для работы с данными памяти данных
dm_word=clib.array.MyCppLib.Short(1);

DACHCurAdr = read_PM_varible(BaseAddr+0x42);
fprintf('DACHCurAdr: %x\n', DACHCurAdr);
% Текущая позиция в цикл. буфере истории цап
dac_his_pos = double(double(DACHCurAdr) - 0x3fd0);

get_DM_res=e440_interface.GET_DM_WORD(0x3FD0,dm_word);
% fprintf('0x3FD0: %d\n',uint16(dm_word));
dac_history_unsorted(1, 1) = uint16(dm_word);

get_DM_res=e440_interface.GET_DM_WORD(0x3FD1,dm_word);
% fprintf('0x3FD1: %d\n',uint16(dm_word))
dac_history_unsorted(1,2) = uint16(dm_word);

get_DM_res=e440_interface.GET_DM_WORD(0x3FD2,dm_word);
% fprintf('0x3FD2: %d\n',uint16(dm_word))
dac_history_unsorted(1,3) = uint16(dm_word);

get_DM_res=e440_interface.GET_DM_WORD(0x3FD3,dm_word);
% fprintf('0x3FD3: %d\n',uint16(dm_word))
dac_samples_unsorted(1,4) = uint16(dm_word);

get_DM_res=e440_interface.GET_DM_WORD(0x3FD4,dm_word);
% fprintf('0x3FD4: %d\n',uint16(dm_word))
dac_history_unsorted(1,5) = uint16(dm_word);

get_DM_res=e440_interface.GET_DM_WORD(0x3FD5,dm_word);
% fprintf('0x3FD5: %d\n',uint16(dm_word))
dac_history_unsorted(1,6) = uint16(dm_word);

get_DM_res=e440_interface.GET_DM_WORD(0x3FD6,dm_word);
% fprintf('0x3FD6: %d\n',uint16(dm_word))
dac_history_unsorted(1,7) = uint16(dm_word);

get_DM_res=e440_interface.GET_DM_WORD(0x3FD7,dm_word);
% fprintf('0x3FD7: %d\n',uint16(dm_word))
dac_history_unsorted(1,8) = uint16(dm_word);

% Цикл. буфер "прокручиваем" до текущей начальной позиции + 1
idx = mod((0:N-1) + dac_his_pos+1, N) + 1
dac_history_unsorted
dac_history = dac_history_unsorted(idx)

dac_model = 0;

for ii = 0:size(fir_filt,1)-1
    dac_model = dac_model + double(adc_samples(end-ii-fir_decim))*fir_filt(ii+1,1);
end


for ii = 1:7
    dac_model = dac_model - dac_history(ii)*iir_filt(ii,1);
end

fprintf('Проверяем работу фильтра. Модель: %d, Устройство: %d\n', dac_model, dac_history(end));

end