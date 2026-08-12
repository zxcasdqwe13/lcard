/*
	This routine is used to set errno when a routine detects an error

	The C Runtime Library
	
	Gordon A. Sterling		(617) 461 - 3076
	Development Tools Engineering

	Created on 5/29/93


		Calling Parameters
	     SI Contains new value for errno

		Result Registers
	   None

*/

.MODULE/IMAGE	__errno_;

#include "lib_glob.h"

.ENTRY		___lib_set_errno;
.GLOBAL		_errno;

.VAR/DM/RAM	_errno;

___lib_set_errno:	DM(_errno)=SI;
			RTS;

.ENDMOD;

