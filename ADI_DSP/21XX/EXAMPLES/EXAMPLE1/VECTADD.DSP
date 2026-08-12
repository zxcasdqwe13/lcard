.MODULE                 vector_add;

.CONST                  n=10;           {Set vector dimension}
.VAR/DM/RAM             x_input[n];
.VAR/PM/RAM/ABS=100     y_input[n];
.INIT                   x_input: <xin.dat>;
.INIT                   y_input: <yin.dat>;
.PORT                   z_out;

        JUMP start; NOP; NOP; NOP;      {Interupt vector table}
        RTI; NOP; NOP; NOP;             {No interrupts used}
        RTI; NOP; NOP; NOP;
        RTI; NOP; NOP; NOP;
        RTI; NOP; NOP; NOP;
        RTI; NOP; NOP; NOP;
        RTI; NOP; NOP; NOP;

start:  I2=^x_input;
        L2=0;
        I6=^y_input;
        L6=0;
        M0=1;   L0=0;
        M5=1;   L5=0;
        CNTR=n-1;
        AX0=DM(I2,M0), AY0=PM(I6,M5);           {Get first data}
        DO add_loop UNTIL CE;
           AR=AX0+AY0,  AX0=DM(I2,M0), AY0=PM(I6,M5);
add_loop:  DM(z_out)=AR;                        {Write output}
        AR=AX0+AY0;
        DM(z_out)=AR;
        IDLE;

.ENDMOD;
