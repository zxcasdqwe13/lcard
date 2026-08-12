{ значения адресов управляющих регистров DSP}
.const Sys_Ctrl_Reg=0x3FFF;
.const Dm_Wait_Reg=0x3FFE;
.const Tperiod_Reg=0x3FFD;
.const Tcount_Reg=0x3FFC;
.const Tscale_Reg=0x3FFB;
.const Sport1_Ctrl_Reg= 0x3FF2;
.const Sport1_Sclkdiv= 0x3FF1;
.const Sport1_Rfsdiv=0x3FF0;
.const Sport1_Autobuf_Ctrl= 0x3FEF;
.const Sport0_Ctrl_Reg= 0x3FF6;
.const Sport0_Sclkdiv= 0x3FF5;
.const Sport0_Rfsdiv=0x3FF4;
.const Sport0_Autobuf_Ctrl=0x3FF3;
.const Prog_Flag_Comp_Sel_Ctrl =0x3FE6;
.const Prog_Flag_Data =0x3FE5;
.const BDMA_Word_Count =0x3FE4;
.const BDMA_Control =0x3FE3;
.const BDMA_External_Address =0x3FE2;
.const BDMA_Internal_Address =0x3FE1;

{ константы расположения LBIOS в памяти программ}
.const ProgaramBaseAddress =0x400;
.const VariableBaseAddress =0x30;
.constProgaramBaseAddressValAddr= VariableBaseAddress + 0x0;
.constReadyAddr= VariableBaseAddress + 0x1;
.constTMode1Addr= VariableBaseAddress + 0x2;
.constTMode2Addr = VariableBaseAddress + 0x3;
.constTestLoadVarAddr = VariableBaseAddress + 0x4;
.constCommandAddr=VariableBaseAddress + 0x5;
.constImaskValueAddr=VariableBaseAddress + 0x6;
.constSclk0DivAddr=VariableBaseAddress + 0x7;
.constDacRateAddr=VariableBaseAddress + 0x8;
.constAdcRateAddr=VariableBaseAddress + 0x9;
.constAdcEnableAddr=VariableBaseAddress + 0xA;
.constAdcFifoBaseAddressAddr=VariableBaseAddress + 0xB;
.constCurAdcFifoLengthAddr=VariableBaseAddress + 0xC;
.constAdcFifoLengthOver2Addr=VariableBaseAddress + 0xD;
.constAdcFifoLengthAddr=VariableBaseAddress + 0xE;
.constIsCorrectionEnabledAddr=VariableBaseAddress + 0xF;
/*.constLbiosVersionAddr=VariableBaseAddress + 0x10;*/
.constAdcSampleAddr=VariableBaseAddress + 0x11;
.constAdcSampleChannelAddr=VariableBaseAddress + 0x12;
.constInputModeAddr=VariableBaseAddress + 0x13;
.constIsTtlKadrSynchroAddr=VariableBaseAddress + 0x14;
.constSynchroAdFlagAddr=VariableBaseAddress + 0x15;
.constSynchroAdChannelAddr=VariableBaseAddress + 0x16;
.constSynchroAdPorogAddr=VariableBaseAddress + 0x17;
.constSynchroAdModeAddr=VariableBaseAddress + 0x18;
.constSynchroAdTypeAddr=VariableBaseAddress + 0x19;
.constSynchroAdStepAddr=VariableBaseAddress + 0x1A;
.constControlTableLenghtAddr=VariableBaseAddress + 0x1B;
.constFirstSampleDelayAddr=VariableBaseAddress + 0x1C;
.constInterKadrDelayAddr=VariableBaseAddress + 0x1D;
.constAdcChannelAddr=VariableBaseAddress + 0x1E;
.constCorrectableAdcChannelAddr=VariableBaseAddress + 0x1F;

.constDacSampleAddr=VariableBaseAddress + 0x20;
.constDacEnableAddr=VariableBaseAddress + 0x21;
.constDacFifoBaseAddressAddr=VariableBaseAddress + 0x22;
.constDacFifoLengthOver2Addr=VariableBaseAddress + 0x23;
.constCurDacFifoLengthAddr=VariableBaseAddress + 0x24;
.constDacFifoLengthAddr=VariableBaseAddress + 0x25;
.constEnableFlashAddr=VariableBaseAddress + 0x26;
.constFlashAddressAddr=VariableBaseAddress + 0x27;
.constFlashDataAddr=VariableBaseAddress + 0x28;

.constEnableTtlOutAddr=VariableBaseAddress + 0x29;
.constTtlOutAddr=VariableBaseAddress + 0x2A;
.constTtlInAddr=VariableBaseAddress + 0x2B;

.constScaleFactorAddr=VariableBaseAddress + 0x30;
.constZeroOffsetAddr=VariableBaseAddress + 0x34;

{ диапазон адресов от 0x35 до 0x80 - свободен}

.constControlTableAddr=0x80;{ массив на 128 слов}
.constCalibrationArrayAddr=0x100;{ массив на 256 слов}
.constDspInfoStructAddr=0x200;{ массив на 256 слов}


{ текущая версия LBIOS}
/*.constLBIOS_VERMAJOR =3;*/ { старший байт версии}
/*.constLBIOS_VERMINOR =0;*/{ младший байт версии}

{ регистры со стороны DSP}
.const TTL_IN=0x0;
.const TTL_OUT=0x0;
.const READ_ADC=0x1;
.const SET_ADC_CHANNEL=0x1;