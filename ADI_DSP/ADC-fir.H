ch1processor:

TOPPCSTACK=L6; TOPPCSTACK=M6; TOPPCSTACK=I6; 
TOPPCSTACK=L7; TOPPCSTACK=M7; TOPPCSTACK=I7;
TOPPCSTACK=L3; TOPPCSTACK=M3; TOPPCSTACK=I3; TOPPCSTACK=AX0; 



{ --- [БЛОК 1:  Вычисление КИХ-части (Входные отсчеты АЦП)] --- }


GetPm(AX0, ShiftAddr);  { Шаг в буфере АЦП -> записался в AX0 }
M3 = AX0; 
MODIFY (I3, M3);        { Сдвигаем указатель истории АЦП }


GetPm(AX0, DecimAddr);  { Коэффициент децимации }
M3 = AX0;               { Теперь M3 хранит шаг децимации для КИХ-фильтра }

GetPm(AX0, NTapsAddr);  { Количество КИХ-коэффициентов }

{Определимся с адресом таблицы коэффициентов для текущего канала ЦАП}
{Сейчас номер канала в SR1, а начало таблицы в FirCoefAddr1}

I6 = FirCoefAddr1;
M6 = 1;
L6 = AX0;               { Длина буфера КИХ-коэффициентов }

AR = AX0 - 1;           { Количество шагов цикла КИХ = NTaps - 1 }
CNTR = AR;             {буфер КИХ-коэффициентов НЕ циклический}

AR = AX0 - 1;           { Количество шагов цикла КИХ = NTaps - 1 }
CNTR = AR;

MR = 0, MX0 = DM(I3, M3), MY0 = PM(I6, M6);
DO fir_loop UNTIL CE;
fir_loop: MR = MR + MX0 * MY0(SS), MX0 = DM(I3, M3), MY0 = PM(I6, M6);


{ Последнее перемножение КИХ-части }
MR = MR + MX0 * MY0(SS); 

{ --- [БЛОК 2:Вычисление БИХ-части (История ЦАП)] --- }
GetPm(AX0, DacHistoryCurrentHdAddr);
I3 = AX0;               { Указатель на новое значение в истории ЦАП (DM) }
L3 = 8;                 { Включаем циклический буфер для ЦАП на 8 элементов }
M3 = 1;                 { Шаг смещения = 1 }

I6 = IirBCoefAddr;      { Указатель на коэффициенты B в PM }
L6 = 0;                 { Выключаем циклический режим для I6 }
M6 = 1;


MX0 = DM(I3, M3), MY0 = PM(I6, M6); 

CNTR = 5;               {1 до цикла, 5 в цикле, 1 после цикла = 7 элементов }
DO iir_b_loop UNTIL CE;
iir_b_loop: MR = MR - MX0 * MY0(SS), MX0 = DM(I3, M3), MY0 = PM(I6, M6);

{ Финальное 7-е накопление с округлением (RND) и проверкой насыщения }
MR = MR - MX0 * MY0(RND);
IF MV SAT MR;

{ --- [БЛОК 3: Сохранение нового результата] --- }
{ Пишем в историю ЦАП. I3 встал в новую позицию и перезапишет самый старый элемент }
{I3 = 0x3FD0;}
DM(I3, M3) = MR0;


{ Сохраняем новую начальную позицию в истории отсчётов цап }
AX0 = I3;
PutPm(AX0, DacHistoryCurrentHdAddr);

{Установим адресацию каналов}

AX0 = I5;             {перенесем адрес текущей строки контрольной таблицы в опреационный регистр}
I4 = AX0;
M4 = relDacAddr;           {сдвиг между управляющими таблицами ADC и DAC-1}
MODIFY(I4,M4);      {передвинемся в новый указатель}
AX0 = PM(I4, M4);    {прочитаем логический адрес канала ЦАП}
M4=1;


{amplific coef}
GetPm(SE, DACAmpAddr); {READ AND SHIFT DAC Value}
SR = ASHIFT MR1 (HI);

{CONVERT to 12 bit and add address DAQ startbits and load to DAQ port}
SR = LSHIFT SR1 BY -4 (HI);
AR=SR1;


/*разбор логического адреса и адресация */

{Установим номер ЦАПА}
AF = TSTBIT 9 of AX0;
if NE JUMP dac2;
 
dac1: 
    AR = CLRBIT 12 OF AR; {This sets DAC number 0 }
JUMP enddac;
dac2: 
    AR = CLRBIT 12 OF AR; {This sets DAC number  1}
enddac:

TX0 = AR; {отсчет ушел в ЦАП}

/*выставим адрес для демультиплексора*/
IO(TTL_OUT) = AR; {ноги с 9 по 16 болтаются}



AX0=TOPPCSTACK; I3=TOPPCSTACK; M3=TOPPCSTACK; L3=TOPPCSTACK; I7=TOPPCSTACK; M7=TOPPCSTACK; L7=TOPPCSTACK; I6=TOPPCSTACK; M6=TOPPCSTACK; L6=TOPPCSTACK;
NOP;
RTS;
