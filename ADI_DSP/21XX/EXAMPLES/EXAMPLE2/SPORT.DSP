.MODULE/RAM/BOOT=0/ABS=0                talktrhu;
{------Interrupt vector table------}
        JUMP start; NOP; NOP; NOP;      {reset vector}
        RTI; NOP; NOP; NOP;             {IRQ2}
        RTI; NOP; NOP; NOP;             {SPORT0 transmit}
        RTI; NOP; NOP; NOP;             {SPORT0 receive}
        RTI; NOP; NOP; NOP;             {SPORT1 transmit}
        JUMP sample; NOP; NOP; NOP;     {SPORT1 receive}
        RTI; NOP; NOP; NOP;             {timer}

{------Initializations-------------}
start:  AX0=0x0000;
        DM(0x3FFE)=AX0;                 {all DM wait states 0}
        DM(0x3FFD)=AX0;                 {timer not used}
        DM(0x3FFC)=AX0;                 {registers cleared}
        DM(0x3FFB)=AX0;                 
        DM(0x3FFA)=AX0;                 {receive multichannels}
        DM(0x3FF9)=AX0;                 {disabled}
        DM(0x3FF8)=AX0;                 {transmit multichannels}
        DM(0x3FF7)=AX0;                 {disabled}
        DM(0x3FF6)=AX0;                 {SPORT0 control not used}
        DM(0x3FF5)=AX0;                 {SPORT0 timing not used}
        DM(0x3FF4)=AX0;                 {SPORT0 timing not used}
        DM(0x3FF3)=AX0;                 {SPORT0 autobuf disabled}
        AX0=0x6B27;                     {internal serial clock}
        DM(0x3FF2)=AX0;                 {RFS reqd, normal framing,}
                                        {TFS reqd, normal framing,}
                                        {internal RFS, TFS, mu-law} 
                                        {companding, 8-bit words}

        AX0=0x0002;                     {generate 2.048 MHz SCLK1}
        DM(0x3FF1)=AX0;                 {from 12.288 MHz CLKIN}
        AX0=255;                        {divide by 256 for 8 kHz}
        DM(0x3FF0)=AX0;                 {sampling rate}
        AX0=0x0000;
        DM(0x3FEF)=AX0;                 {SPORT1 autobuf disabled}

        ICNTL=0x07;                     {enable edge sensitive IRQs}
        IMASK=0x02;                     {enable SPORT1 receive IRQ}

        AX0=0x0C00;                     {SPORT1 enabled, PM wait}
        DM(0x3FFF)=AX0;                 {states 0, boot wait}
                                        {states 0, boot page 0}

{------Wait for sample------------}
wait:   IDLE;                           {wait for receive IRQ}
        Jump wait;

{------Process sample-------------}
sample: AX0=RX1;                        {put receive sample in AX0}
        TX1=AX0;                        {transmit sample in AX0}
        RTI;

.ENDMOD;
