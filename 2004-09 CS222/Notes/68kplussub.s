
*Example program for 68000  john van rees 16 Nov 01
* THIS PROGRAM PROMPTS THE USER FOR TWO 32-BIT SIGNED INTEGERS A AND B;
* AND CALCULATES THE SUM IN A SUBROUTINE AND PRINTS A+B. It also fakes 
* some unneeded parameters to show subroutine linkage.  This is not how any
* one adds 2 numbers, not even in a subroutine.  Run this with break points 
* looking at registers and memory.
*
* REGISTER USAGE
*     D3 - THE VALUE OF A
*     D4 - THE VALUE OF B 
*     D5 - THE VALUE OF A+B
* *****************************************************************************
*PRINT IDENTIFICATION
START:  JSR		initIO
	LEA		IDBANNER,A0		;ADDRESS OF ID BANNER
        JSR		STROUT			;WRITE BANNER

*INITIALIZATION FOR REGISTERS USED IN SUBROUTINE
	MOVE.L      	#17,D6
        LEA         	IDBANNER,A4

* PROMPT FOR A AND READ IT

	LEA		APROMPT,A0		;ADDRESS OF STRING
	JSR		STROUT			;WRITE THE STRING

	JSR		DECIN			;READ AN INTEGER
	MOVE.L		D0,D3			;PLACE IT IN D3

* PROMPT FOR B AND READ IT

	LEA		BPROMPT,A0		;ADDRESS OF STRING
	JSR		STROUT			;WRITE THE STRING

	JSR		DECIN			;READ AN INTEGER
	MOVE.L		D0,D4			;PLACE IT IN D4

* CALLING SEQUENCE FOR ADDITION SUBROUTINE

      MOVE.L	  D3,-(SP)	;SET UP FIRST PARAMETER
      MOVE.L      D4,-(SP) 	;SET UP SECOND PARAMETER
      JSR         ADDER		;CALL ROUTINE TO ADD PARAMETERS
      ADD.L       #8,SP		;POP PARAMETERS OFF STACK
      MOVE.L      D0,D5		;STORE SUM IN D5



* PRINT A+B WITH A HEADING

	LEA		OUTHDG,A0		;ADDRESS OF STRING
	JSR		STROUT			;WRITE THE STRING

	MOVE.L		D5,D0			;PUT THE ANSWER IN D0
	JSR		DECOUT			;AND PRINT IT
	JSR		NEWLINE
        JSR         	NEWLINE

* PRINT END OF PROCESSING MESSAGE

	LEA		EOP,A0			;ADDRESS OF STRING
	JSR		STROUT			;WRITE THE STRING
	JSR		NEWLINE
        JSR         	NEWLINE

* END PROGRAMMING

	JSR		finish

*	DATA	PUT YOUR PROGRAM DATA BELOW THIS LINE
***********************************************************************
IDBANNER:   DC.B		'NAME	  	JANE SMITH',10,13
            DC.B		'STUDENT NUMBER	1234567',10,13
            DC.B		'COURSE		74.222',10,13
 	    DC.B		'INSTRUCTOR	JOHN VAN REES',10,13
	    DC.B		'ASSIGNMENT 	1',10,13
	    DC.B		'QUESTION		4',10,13,10,13,0
APROMPT:    DC.B		'ENTER A:',0			
BPROMPT:    DC.B		'ENTER B:',0		
EOP:	    DC.B		'NORMAL TERMINATION',0
OUTHDG:	    DC.B		'A+B= ',0
	    DS.W		0			;ENSURES NEXT ADDRESS IS EVEN


ADDER:	
*********************************************************************
*THIS ROUTINE ADDS TWO NUMBERS IN A VERY INEFFICIENT FASHION AS IT IS
*AN EXAMPLE OF A GENERAL ROUTINE SHOWING SUBROUTINE LINKAGE.  THE ANSWER 
*IS RETURNED IN D0
* REGISTER USAGE
*  D3,D4 ARE NOT USED FOR ANY PURPOSE. USED TO SHOW HOW TO SAVE REGISTERS
*   D0 RETURNS SUM
* STACK FRAME
*   SP+0  = Y SECOND LOCAL VARIABLE
*   SP+4  = X FIRST LOCAL VARIABLE
*   SP+8  = SAVED REGISTERS
*   SP+16 = RETURN ADDRESS
*   SP+20 = SECOND PARAMETER
*   SP+24 = FIRST PARAMETER
*****************************************************************************

		MOVEM.L	D6/A4,-(SP)		;SAVE 2 REGISTERS
		SUB.L		#8,SP		;SPACE FOR 2 LOCAL VARIABLES
AOFF:		EQU		24
BOFF:		EQU		20
XOFF:       	EQU  	 	4
YOFF:       	EQU		0

 		MOVE.L      AOFF(SP),XOFF(SP)	;MOVE A TO X
            	MOVE.L      BOFF(SP),YOFF(SP)	;MOVE B TO Y
		MOVE.L      YOFF(SP),D6         ;MOVE Y TO D6
            	MOVE.L      XOFF(SP),A4 	;MOVE X TO A4
            	ADDA.L      D6,A4               ;ADD REGISTERS
		MOVE.L      A4,D0		;STORE RETURN VALUE
		ADD.L	    #8,SP		;REMOVE VARIABLES FROM STACK
		MOVEM.L     (SP)+,D6/A4		;RESTORE REGISTERS
		RTS				;RETURN TO CALLING ROUTINE








          include   68kIO.s             Input/Output routines
          end