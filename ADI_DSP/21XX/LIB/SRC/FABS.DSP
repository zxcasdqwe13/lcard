/*
    	This C callable subroutine returns the absolute value of
	it's floating point input.

	The C Runtime Library
	
	Gordon A. Sterling		(617) 461 - 3076
	Development Tools Engineering

    	Created on 5/5/93

	#include <math.h>
	double fabs(double x);
*/

.MODULE/IMAGE	__fabs_;

#include	"lib_glob.h";
#include 	"mth_glob.h";

.ENTRY		fabs_;

fabs_:		MR1=TOPPCSTACK;		/* Get return address		*/
		CALL ___lib_frame_swap;	/* Swap stack and frame		*/

		reads(SR1,I6,M5);	/* Read MSW of FP-word		*/
		reads(SR0,I6,M5);	/* Read LSW of FP-word		*/

		AY1=0x7fff;		/* Used to mask sign bit	*/
		AR=SR1 AND AY1;		/* AND out sign bit return pos	*/
		SR1=AR;			/* Set return value		*/
__restore_state:JUMP ___lib_frame_restore;

.ENDMOD
