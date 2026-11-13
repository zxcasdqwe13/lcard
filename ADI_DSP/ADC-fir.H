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



{Определимся с адресом таблицы коэффициентов для текущего канала ЦАП}
{Сейчас номер канала в SR1, а начало таблицы в FirCoefAddr1}

AX0 = I5;             {перенесем адрес текущей строки контрольной таблицы в адресный регистр}
I6 = AX0;
M6 = relFirCoefAddr1;           {в М6 сдвиг между управляющими таблицами ADC и DAC-1}
MODIFY(I6,M6);                {теперь указатель сдвинут относительно начала таблицы на номер канала}
{то есть, указывает на начало таблицы коэффициентов для данного канала} 



GetPm(AX0, NTapsAddr);  { Количество КИХ-коэффициентов на канал}
M6 = AX0;               {Шаг по таблице - NTaps}
              

AR = AX0 - 1;           { Количество шагов цикла КИХ = NTaps - 1 }
GetPm(AX0, TotFirLenAddr); { Длина буфера КИХ-коэффициентов }
L6 = AX0;
CNTR = AR;              {буфер КИХ-коэффициентов циклический, длина-256}



MR = 0, MX0 = DM(I3, M3), MY0 = PM(I6, M6);
DO fir_loop UNTIL CE;
fir_loop: MR = MR + MX0 * MY0(SS), MX0 = DM(I3, M3), MY0 = PM(I6, M6);


{ Последнее перемножение КИХ-части }
MR = MR + MX0 * MY0(SS); 
{Выход процедуры сейчас в МR1}


{Установим адресацию каналов}

AX0 = I5;             {перенесем адрес текущей строки контрольной таблицы в опреационный регистр}
I6 = AX0;
M6 = relDacAddr;           {сдвиг между управляющими таблицами ADC и DAC-1}
MODIFY(I6,M6);      {передвинемся в новый указатель}
AX0 = PM(I6, M6);    {прочитаем логический адрес канала ЦАП}
M4=1;
IO(TTL_OUT) = AX0; {выставляем логический адрес ЦАП, INH высокий}


/*подготовим отсчет ЦАП*/
{amplific coef}
GetPm(SE, DACAmpAddr); {READ AND SHIFT DAC Value}
SR = ASHIFT MR1 (HI);

{CONVERT to 12 bit and add address DAQ startbits and load to DAQ port}
SR = LSHIFT SR1 BY -4 (HI);
{AR=SR1;}


/*разбор логического адреса и адресация */

{откроем демультиплексор, чтобы выставить на выход прошлый отсчет- тот, 
    который отправили в ЦАП в конце прошлого цикла}
I4 = demultAddr;  AR = PM(I4, M4);
IO(TTL_OUT) = AR;
NOP;NOP;NOP;NOP;NOP;NOP;NOP;NOP;
NOP;NOP;NOP;NOP;NOP;NOP;NOP;NOP;
NOP;NOP;NOP;NOP;NOP;NOP;NOP;NOP;
NOP;NOP;NOP;NOP;NOP;NOP;NOP;NOP;
AR=demultCloseCode; {закроем демультиплексор}
IO(TTL_OUT) = AR; 


{Установим номер ЦАП}

AR=TSTBIT 8 of AX0;
if NE JUMP dac1;
 
dac0: 
    AR=SR1;
    AR = CLRBIT 12 OF AR; {This sets DAC number 0 }
    TX0 = AR; {отсчет ушел в ЦАП}
   
    AR = CLRBIT 3 OF AX0;
    I4 = demultAddr; PM(I4, M4) = AR;
     JUMP enddac;
dac1: 
    AR=SR1;
    AR = SETBIT 12 OF AR; {This sets DAC number  1}
    TX0 = AR; {отсчет ушел в ЦАП}
    AR = CLRBIT 7 OF AX0;
    I4 = demultAddr; PM(I4, M4) = AR;
    
enddac:





AX0=TOPPCSTACK; I3=TOPPCSTACK; M3=TOPPCSTACK; L3=TOPPCSTACK; I7=TOPPCSTACK; M7=TOPPCSTACK; L7=TOPPCSTACK; I6=TOPPCSTACK; M6=TOPPCSTACK; L6=TOPPCSTACK;
NOP;
RTS;
