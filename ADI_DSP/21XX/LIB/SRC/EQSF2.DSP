.MODULE/IMAGE	Compare_floats_for_EQ;

/* 
	This routine is part of the floating point support library.  It
	determines if two floating point numbers are equal to each other.

	The C Runtime Library
	
	Gordon A. Sterling		(617) 461 - 3076
	Development Tools Engineering

	Created on 3/13/93

*/

#include "lib_glob.h"
#include "flt_glob.h"

.ENTRY 		__eqsf2_;

__eqsf2_:	MR1=TOPPCSTACK;
		M5=-1;
		CALL ___lib_save_small_frame;

		I6=1;
		M5=1;
		MODIFY(I6,M4);

		reads(AX1,I6,M5);
		reads(AX0,I6,M5);
		AR=PASS -1, reads(AY1,I6,M5);
		AF=AX1-AY1, reads(AY0,I6,M5);

		IF EQ AF=AX0-AY0;	/* Test LSWs for EQ		*/
		IF EQ AR=PASS 0;	/* Entire word is EQ so EQ	*/

__restore_state:JUMP ___lib_restore_small_frame;

.ENDMOD;


