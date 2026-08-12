.MODULE/ABS=0		ADSP2100_Runtime_Header;

.EXTERNAL   main_, ___lib_setup_args, ___lib_setup_environment,___lib_setup_heap;
.EXTERNAL	___lib_int0_ctrl,___lib_int1_ctrl, ___lib_int2_ctrl, ___lib_int3_ctrl;


___interrupt0:		JUMP ___lib_int0_ctrl;
___interrupt1:		JUMP ___lib_int1_ctrl;
___interrupt2:		JUMP ___lib_int2_ctrl;
___interrupt3:		JUMP ___lib_int3_ctrl;

___reset:		CALL ___lib_setup_environment;
		        CALL ___lib_setup_args;
			CALL main_;
			TRAP;

.ENDMOD;

