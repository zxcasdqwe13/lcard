{Perform interchannel operations}

GetPm(AR, ProcSwitchAddr);
AY1=1;
AR=AR-AY1;
IF EQ JUMP ch1out;
GetPm(AR, ProcSwitchAddr);
AY1=2;
AR=AR-AY1;
IF EQ JUMP ch2out;
GetPm(AR, ProcSwitchAddr);
AY1=3;
AR=AR-AY1;
IF EQ JUMP sumout;
GetPm(AR, ProcSwitchAddr);
AY1=4;
AR=AR-AY1;
IF EQ JUMP difout;


ch1out:
GetPm(AR,FiltBufAddr);
JUMP ENDPIO;

ch2out:
GetPm(AR,FiltBufAddr+1);
JUMP ENDPIO;

sumout:
GetPm(AR,FiltBufAddr);
GetPm(AY1,FiltBufAddr+1);
AR=AR+AY1;
JUMP ENDPIO;

difout:
GetPm(AR,FiltBufAddr);
GetPm(AY1,FiltBufAddr+1);
AR=AR-AY1;
ENDPIO:
{END Perform interchannel operations}
