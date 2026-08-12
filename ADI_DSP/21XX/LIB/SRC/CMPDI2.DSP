/* 
	This routine compares to unsigned long integer values to 
	see if how they compare.

	The C Runtime Library
	
	Gordon A. Sterling		(617) 461 - 3076
	Development Tools Engineering

	Created on 5/8/93
*/

.MODULE/IMAGE	__cmpdi2__;

#include "lib_glob.h"
#include "int_glob.h"

.ENTRY 		__cmpdi2_;

__cmpdi2_:	MR1=TOPPCSTACK;
		CALL ___lib_frame_swap;

		reads(SR1,I6,M5);
		reads(SR0,I6,M5);
		reads(MR1,I6,M5);
		AF=PASS MR1, reads(AY1,I6,M5);

		AR=SR0-AY1;		/* Subtract in double precision	*/
		AR=SR1-AF+C-1;		/* Subtract MSWs now		*/
		IF EQ AR=SR0-AY1;	/* MSW was zero, so compare LSW	*/
		IF EQ JUMP __restore_state;/* Numbers are equal, so ret	*/
		AR=-1;			/* Assume that X < Y		*/
		IF AC AR=PASS 1;	/* If AC then X > Y		*/

__restore_state:JUMP ___lib_frame_restore;
.ENDMOD;


