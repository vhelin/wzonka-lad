;
; Iconstartup.i
;
; include this to allow startup from icon.
; Just code the rest of your program as if you were writing for CLI.
;
; You should also add these lines to your code:
;
;	include "exec/exec_lib.i"
;	include	"exec/exec.i"
;	include	"libraries/dosextens.i

        include "exec/types.i"
        include "exec/tasks.i"
;       include "dos/dosextens.i"

* All DOS processes have this STRUCTure
* Create and DeviceProc returns pointer to the MsgPort in this STRUCTure
* Process_addr = DeviceProc(..) - TC_SIZE

;BPTR	    MACRO		; obsolete
;\1	    EQU     SOFFSET
;SOFFSET    SET     SOFFSET+4
;	    ENDM

 STRUCTURE Process,0
    STRUCT  pr_Task,TC_SIZE
    STRUCT  pr_MsgPort,MP_SIZE	* This is BPTR address from DOS functions
    WORD    pr_Pad		* Remaining variables on 4 byte boundaries
    BPTR    pr_SegList		* Array of seg lists used by this process
    LONG    pr_StackSize	* Size of process stack in bytes
    APTR    pr_GlobVec		* Global vector for this process (BCPL)
    LONG    pr_TaskNum		* CLI task number of zero if not a CLI
    BPTR    pr_StackBase	* Ptr to high memory end of process stack
    LONG    pr_Result2		* Value of secondary result from last call
    BPTR    pr_CurrentDir	* Lock associated with current directory
    BPTR    pr_CIS		* Current CLI Input Stream
    BPTR    pr_COS		* Current CLI Output Stream
    APTR    pr_ConsoleTask	* Console handler process for current window
    APTR    pr_FileSystemTask	* File handler process for current drive
    BPTR    pr_CLI		* pointer to CommandLineInterface
    APTR    pr_ReturnAddr	* pointer to previous stack frame
    APTR    pr_PktWait		* Function to be called when awaiting msg
    APTR    pr_WindowPtr	* Window pointer for errors

* following definitions are new with 2.0
    BPTR    pr_HomeDir		* Home directory of executing program
    LONG    pr_Flags		* flags telling dos about process
    APTR    pr_ExitCode		* code to call on exit of program or NULL
    LONG    pr_ExitData		* Passed as an argument to pr_ExitCode
    APTR    pr_Arguments	* Arguments passed to the process at start
    STRUCT  pr_LocalVars,MLH_SIZE * Local environment variables
    APTR    pr_ShellPrivate	* for the use of the current shell
    BPTR    pr_CES		* Error stream - if NULL, use pr_COS
   LABEL   pr_SIZEOF		* Process

* All DOS processes have this STRUCTure
* Create and DeviceProc returns pointer to the MsgPort in this STRUCTure
* Process_addr = DeviceProc(..) - TC_SIZE

; or similar code for your assembler...
;
; If your assembler won't assemble this, throw it away and buy
; the excellent HISOFT DEVPAC 3.0 from Hisoft Software.

	section start,code

	movem.l	d0/a0,-(sp)

	sub.l	a1,a1
	move.l  execbase,a6
	jsr	FindTask(a6)

; Could use ThisTask(a6) here, but we won't. The general rule
; is that if there is a system function to read a structure, use
; that rather than peeking the structure directly. This gives
; Commodore greater freedom to change things in the future...

	move.l	d0,a4

	clr.b	cli_or_wb	; cli.

	tst.l	pr_CLI(a4)	; was it called from CLI?
	bne.s   fromCLI		; if so, skip out this bit...

	lea	pr_MsgPort(a4),a0
	move.l  execbase,a6
	jsr	WaitPort(A6)
	lea	pr_MsgPort(a4),a0
	jsr	GetMsg(A6)
	move.l	d0,returnMsg

	move.b	#1,cli_or_wb	; wb.

fromCLI
	movem.l	(sp)+,d0/a0

go_program


	bsr.w	gb_emu          	; Calls your code..

; If your code does not allow exit, the following lines are
; not required

	move.l	d0,-(sp)

	tst.l	returnMsg		; Is there a message?
	beq.s	exitToDOS		; if not, skip...

	move.l	execbase,a6
        jsr	Forbid(a6)          ; note! No Permit needed!

	move.l	returnMsg(pc),a1
	jsr	ReplyMsg(a6)

exitToDOS
	move.l	(sp)+,d0		; exit code
	rts

; These next lines are required whether you want to exit or not!


returnMsg:	dc.l	0
		cnop	0,4
		even
