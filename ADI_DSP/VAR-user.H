#include <user-par.h>


.var/SEG=INT_PM_USER/ABS=FirCoefAddr1/PM/RAM firCoef1[64];
.INIT firCoef1: dfilt;

.var/SEG=INT_PM_USER/ABS=FirCoefAddr2/PM/RAM firCoef2[64];
.INIT firCoef2: dfilt;

{not used-------------------------}
.var/SEG=INT_PM_USER/ABS=DelayTTLAddr/PM/RAM DelayTTL;
.init DelayTTL: M(0x3);

.var/SEG=INT_PM_USER/ABS=DurationTTLAddr/PM/RAM DurationTTL;
.init DurationTTL: M(0x5);

.var/SEG=INT_PM_USER/ABS=FiltBufAddr/PM/RAM FiltBuf[2];
.init DurationTTL: d#0, d#0;

{.var/SEG=INT_PM_USER/ABS=IntCoefAddr/PM/RAM IntCoef[4];}
{.INIT firCoef: <IntCoef.dat>;}
{.INIT IntCoef: 0x7FFF, 0x7fff, 0x7FFF, 0x7FFF;}

{----------------------------------}

.var/SEG=INT_PM_USER/ABS=NTapsAddr/PM/RAM NTaps;
.init NTaps: M(127); {Taps to use -1}

.var/SEG=INT_PM_USER/ABS=DACAmpAddr/PM/RAM DACAmp;
.init DACAmp: M(amp);

.var/SEG=INT_PM_USER/ABS=ShiftAddr/PM/RAM TShift;
.init TShift: M(-shift);  {1+Shift*nChannels (default=-1)}

.var/SEG=INT_PM_USER/ABS=ProcSwitchAddr/PM/RAM ProcSwitch;
.init ProcSwitch: pnum;

.var/SEG=INT_PM_USER/ABS=DecimAddr/PM/RAM Decim;
.init Decim: M(-dec*2);

{массив коэффициентов b БИХ фильтра в области программ}
.var/SEG=INT_PM_USER/ABS=IirBCoefAddr/PM/RAM IirBCoef[8];
.INIT IirBCoef: 0, 0, 0, 0, 0, 0, 0, 0;

{циклический буфер в области данных для истории отсчётов цап DacHistoryAddr = 0x3FD0}
.VAR/SEG=INT_DM_USER/ABS=DacHistoryAddr/DM/RAM/CIRC DacHistoryCIRC[8];
.INIT DacHistoryCIRC: 0, 1, 0, 0, 0, 0, 0, 0;

.var/SEG=INT_PM_USER/ABS=DacHistoryCurrentHdAddr/PM/RAM DacHistoryCurrentHd;
.init DacHistoryCurrentHd: M(DacHistoryAddr);
