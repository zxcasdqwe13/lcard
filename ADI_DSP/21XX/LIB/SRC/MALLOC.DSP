/*
    This C callable subroutine allocates a range of memory from the
    free memory list. 

    DSP Applications Library.		    Gordon A. Sterling

    Created on 8/18/89
    V 1.1  gnu calling convention      7/21/93   Craig Smilovitz 

    #include <stdlib.h>;
    void *malloc(size_t size);

*/

.MODULE/IMAGE		Memory_Allocator;


#include	<lib_glob.h>;
 /* #include	<slib_glob.h>; */

.EXTERNAL	__mem_heap_space;
.EXTERNAL       ___setup_heap_called,___lib_setup_heap;

.ENTRY		malloc_;

malloc_:	M7=-1;
		MR1=TOPPCSTACK;
		CALL ___lib_save_small_frame;
		AX0 = DM(___setup_heap_called);
		AR = PASS AX0;
		IF EQ JUMP skip_setup;
		CAll ___lib_setup_heap;
		AX0=1;
		DM(___setup_heap_called) = AX0; /* set flag for future malloc calls */
skip_setup:

		AY1=2;				/*Useful constant*/
		AR=AR+AY1;			/*Fetch size of space(adjusted
						  for control area */
		AX0=AR;				/*AX0=size of block wanted (incl prefix)*/
		I6=^__mem_heap_space;
		AX1=^__mem_heap_space;

		DO scan_free UNTIL EQ;
		   AF=PASS AX1, AY0=DM(I6,M5);	/*AF=this addr,AY0=length of this block*/
		   AR=AX0-AY0, AX1=DM(I6,M5);	/*AR=amt block < needed, AX1= next address*/
		   IF LE JUMP block_found;	/*I6-2 holds block address*/
		   AR=PASS AX1;			/*AR= test for end */
scan_free:	   I6=AX1;			/*I6=ptr for next block */

		AR=NULL;			/*Return NULL, no space*/
		JUMP restore_state;

block_found:	POP PC, POP LOOP;
						/*Check for close sizes*/
		AR=AR+AY1;			/*if Free_size-alloc_size=0,1,2*/
		IF GE JUMP same_size;		/* then use it, don't truc. */
		AR=AR-AY1;			/*restore size */
		AF=AF-AR,  SI=DM(I6,M7);	/*AF=new pointer - 2 */
		AR=AY0-AX0,SI=DM(I6,M7);	/* calculate new size */
		DM(I6,M5)=AR;   		/* ar is length of shortened block */
						/* don't change next block pointer */
		AR=PASS AF;			/* recover AF */
		I6=AR;				/*I6-> new block */
		DM(I6,M5)=AX0;			/*AF=end of block to malloc */
		DM(I6,M5)=0;			/* store length of block, AX0 = blockptr */
		AR=I6;				/* return new pointer */

restore_state:	JUMP ___lib_restore_small_frame;

same_size:	AR=PASS AF;
		AX0=AR;				/*Setup address for return*/
		I6=^__mem_heap_space;	
		AY0=^__mem_heap_space; 
		DO find_previous UNTIL EQ;
		   AR=PASS AY0, AY0=DM(I6,M5);
		   AY0=DM(I6,M5);		/*Get next space address*/
		   AF=AX0-AY0;
find_previous:	   I6=AY0;
		I6=AR;				/*AR holds previous array add*/
		AF=PASS AX0, AY0=DM(I6,M5);	/*Point to link pointer*/
		AF=AF+1, DM(I6,M5)=AX1;		/*Put previous link into link*/
		AR=AF+1;
		JUMP restore_state;

.ENDMOD;



