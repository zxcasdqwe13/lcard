ch1processor:

TOPPCSTACK=L6; TOPPCSTACK=M6; TOPPCSTACK=I6; 
TOPPCSTACK=M1; TOPPCSTACK=I1;
TOPPCSTACK=M3; TOPPCSTACK=I3; 
TOPPCSTACK=AX0; 

{ --- [БЛОК 1:  Вычисление КИХ-части (Входные отсчеты АЦП)] --- }


GetPm(AX0, ShiftAddr);  { Шаг в буфере АЦП -> записался в AX0 }
M3 = AX0; 
MODIFY (I3, M3);        { Сдвигаем указатель истории АЦП }
M1=-2;                  
MODIFY (I1, M1);        { Указатель ЦАП - на два шага назад}

GetPm(AX0, DecimAddr);  { Коэффициент децимации }
M3 = AX0;               { Теперь M3 хранит шаг децимации для КИХ-фильтра }
            
M1 = AX0;               { Теперь M1 хранит шаг децимации для БИХ-фильтра}

  



{Блок 0.5 Сглаживание высоких частот при децимации - сейчас не работает}

{TOPPCSTACK=I3;}
{M1=-2;}                     { Указатель на коэффициенты B в PM }

{AR = -AX0;}
{AR=AR-1; }          { Количество шагов цикла КИХ = NTaps - 1 }
{CNTR = 9;}

{MR = 0, MX0 = DM(I3, M3);
MY0 = 1; 
DO iir_p_loop UNTIL CE;
iir_p_loop: MR = MR - MX0 * MY0(SS), MX0 = DM(I3, M3);
MR = MR + MX0 * MY0(SS); 


I3=TOPPCSTACK;
M1=AX0;}

GetPm(AX0, NTapsAddr);  { Количество КИХ-коэффициентов }
I6 = FirCoefAddr1;
M6 = 1;
L6 = 0; 

AR = AX0 - 1;           { Количество шагов цикла КИХ = NTaps - 1 }
CNTR = AR;

MX0 = DM(I3, M3);
MX0 = DM(I3, M3), MY0 = PM(I6, M6);
DO fir_loop UNTIL CE;
fir_loop: MR = MR + MX0 * MY0(SS), MX0 = DM(I3, M3), MY0 = PM(I6, M6);

{ Последнее перемножение КИХ-части }
MR = MR + MX0 * MY0(SS); 

{ --- [БЛОК 2:Вычисление БИХ-части (История ЦАП)] --- }

GetPm(AX0, N2TapsAddr);  { Количество БИХ-коэффициентов }
I6 = IirBCoefAddr;      { Указатель на коэффициенты B в PM }




AR = AX0 - 1;           { Количество шагов цикла БИХ = NTaps - 1 }
CNTR = AR;


MX0 = DM(I1, M1), MY0 = PM(I6, M6); 
DO iir_b_loop UNTIL CE;
iir_b_loop: MR = MR - MX0 * MY0(SS), MX0 = DM(I1, M1), MY0 = PM(I6, M6);

{ Финальное  накопление с округлением (RND) и проверкой насыщения }
MR = MR - MX0 * MY0(RND);
IF MV SAT MR;



{ Финальное  накопление с округлением (RND) и проверкой насыщения }
MR = MR - MX0 * MY0(RND);
IF MV SAT MR;



AX0=TOPPCSTACK; 
I3=TOPPCSTACK; M3=TOPPCSTACK;
I1=TOPPCSTACK; M1=TOPPCSTACK; 
I6=TOPPCSTACK; M6=TOPPCSTACK; L6=TOPPCSTACK;

{ --- [БЛОК 3: Сохранение нового результата] --- }
{ Пишем в историю ЦАП. I1 после восстановления регистра стоит в голове буфера ЦАП, M1=1}
M1=1;
DM(I1, M1) = MR0;

NOP;
RTS;
