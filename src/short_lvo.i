; Short names for jsr Name(a6).
; The library headers define _LVOName. execbase is absolute address 4.

	include	"lvo/exec_lib.i"
	include	"lvo/graphics_lib.i"
	include	"lvo/intuition_lib.i"
	include	"lvo/diskfont_lib.i"
	include	"lvo/gadtools_lib.i"
	include	"lvo/lowlevel_lib.i"

execbase	equ	4

Mode_Old	equ	MODE_OLDFILE
Mode_New	equ	MODE_NEWFILE
AHIRequest_SIZEOF	equ	ahir_SIZEOF
AHISampleInfo_SIZEOF	equ	ahisi_SIZEOF

; AHI v4 requester and attribute tags. This ahi.i stops before them.
AHIR_Window		equ	(AHI_TagBase+200)
AHIR_TitleText		equ	(AHI_TagBase+222)
AHIR_InitialAudioID	equ	(AHI_TagBase+244)
AHIR_InitialMixFreq	equ	(AHI_TagBase+245)
AHIR_DoMixFreq		equ	(AHI_TagBase+260)
AHIDB_BufferLen		equ	(AHI_TagBase+122)

new_RTFI_Flags		equ	RTFI_Flags
xRTFI_Dir		equ	RTFI_Dir
xRTSC_DisplayID		equ	RTSC_DisplayID

OpenLibrary	equ	_LVOOpenLibrary
Open	equ	_LVOOpen
Write	equ	_LVOWrite
Output	equ	_LVOOutput
LockPubScreen	equ	_LVOLockPubScreen
GetVisualInfoA	equ	_LVOGetVisualInfoA
CreateMsgPort	equ	_LVOCreateMsgPort
AddPort	equ	_LVOAddPort
CacheClearU	equ	_LVOCacheClearU
AHI_AllocAudioRequestA	equ	_LVOAHI_AllocAudioRequestA
CreateContext	equ	_LVOCreateContext
CloseLibrary	equ	_LVOCloseLibrary
OpenDiskFont	equ	_LVOOpenDiskFont
rtAllocRequestA	equ	_LVOrtAllocRequestA
InitRastPort	equ	_LVOInitRastPort
ReadPixelArray8	equ	_LVOReadPixelArray8
Lock	equ	_LVOLock
Examine	equ	_LVOExamine
ExNext	equ	_LVOExNext
UnLock	equ	_LVOUnLock
IoErr	equ	_LVOIoErr
ObtainBestPenA	equ	_LVOObtainBestPenA
OpenWindowTagList	equ	_LVOOpenWindowTagList
SetMenuStrip	equ	_LVOSetMenuStrip
BltBitMapRastPort	equ	_LVOBltBitMapRastPort
PrintIText	equ	_LVOPrintIText
SetWindowTitles	equ	_LVOSetWindowTitles
AddGList	equ	_LVOAddGList
RefreshGList	equ	_LVORefreshGList
GT_RefreshWindow	equ	_LVOGT_RefreshWindow
OffGadget	equ	_LVOOffGadget
GT_GetIMsg	equ	_LVOGT_GetIMsg
GetMsg	equ	_LVOGetMsg
Delay	equ	_LVODelay
ReplyMsg	equ	_LVOReplyMsg
AllocBitMap	equ	_LVOAllocBitMap
InitBitMap	equ	_LVOInitBitMap
CreateGadgetA	equ	_LVOCreateGadgetA
GT_SetGadgetAttrsA	equ	_LVOGT_SetGadgetAttrsA
FreeVec	equ	_LVOFreeVec
AllocVec	equ	_LVOAllocVec
SetWindowPointerA	equ	_LVOSetWindowPointerA
ClearPointer	equ	_LVOClearPointer
Forbid	equ	_LVOForbid
GetVPModeID	equ	_LVOGetVPModeID
IsCyberModeID	equ	_LVOIsCyberModeID
ScreenToFront	equ	_LVOScreenToFront
OpenDevice	equ	_LVOOpenDevice
OpenScreenTagList	equ	_LVOOpenScreenTagList
LoadView	equ	_LVOLoadView
WaitTOF	equ	_LVOWaitTOF
Supervisor	equ	_LVOSupervisor
CloseDevice	equ	_LVOCloseDevice
FindDisplayInfo	equ	_LVOFindDisplayInfo
GetDisplayInfoData	equ	_LVOGetDisplayInfoData
CloseScreen	equ	_LVOCloseScreen
rtFileRequestA	equ	_LVOrtFileRequestA
XpkOpen	equ	_LVOXpkOpen
XpkClose	equ	_LVOXpkClose
XpkUnpack	equ	_LVOXpkUnpack
Close	equ	_LVOClose
Read	equ	_LVORead
XpkPack	equ	_LVOXpkPack
FindPort	equ	_LVOFindPort
Permit	equ	_LVOPermit
PutMsg	equ	_LVOPutMsg
WaitPort	equ	_LVOWaitPort
rtScreenModeRequestA	equ	_LVOrtScreenModeRequestA
GT_GetGadgetAttrsA	equ	_LVOGT_GetGadgetAttrsA
AHI_AudioRequestA	equ	_LVOAHI_AudioRequestA
AHI_GetAudioAttrsA	equ	_LVOAHI_GetAudioAttrsA
rtChangeReqAttrA	equ	_LVOrtChangeReqAttrA
Seek	equ	_LVOSeek
DeleteFile	equ	_LVODeleteFile
ReleasePen	equ	_LVOReleasePen
UnlockPubScreen	equ	_LVOUnlockPubScreen
CloseFont	equ	_LVOCloseFont
ClearMenuStrip	equ	_LVOClearMenuStrip
FreeVisualInfo	equ	_LVOFreeVisualInfo
RemPort	equ	_LVORemPort
DeleteMsgPort	equ	_LVODeleteMsgPort
rtFreeRequest	equ	_LVOrtFreeRequest
CloseWindow	equ	_LVOCloseWindow
FreeGadgets	equ	_LVOFreeGadgets
FreeBitMap	equ	_LVOFreeBitMap
CreateIORequest	equ	_LVOCreateIORequest
DoIO	equ	_LVODoIO
DeleteIORequest	equ	_LVODeleteIORequest
OnGadget	equ	_LVOOnGadget
WritePixelArray8	equ	_LVOWritePixelArray8
WritePixelArray	equ	_LVOWritePixelArray
DrawBevelBoxA	equ	_LVODrawBevelBoxA
EraseRect	equ	_LVOEraseRect
RemoveGList	equ	_LVORemoveGList
AHI_FreeAudioRequest	equ	_LVOAHI_FreeAudioRequest
AHI_AllocAudioA	equ	_LVOAHI_AllocAudioA
AHI_LoadSound	equ	_LVOAHI_LoadSound
AHI_SetSound	equ	_LVOAHI_SetSound
AHI_ControlAudioA	equ	_LVOAHI_ControlAudioA
AHI_FreeAudio	equ	_LVOAHI_FreeAudio
IntuiTextLength	equ	_LVOIntuiTextLength
WaitIO	equ	_LVOWaitIO
AHI_SetFreq	equ	_LVOAHI_SetFreq
AHI_SetVol	equ	_LVOAHI_SetVol
AHI_UnloadSound	equ	_LVOAHI_UnloadSound
SendIO	equ	_LVOSendIO
ReadJoyPort	equ	_LVOReadJoyPort
ScreenToBack	equ	_LVOScreenToBack
FindTask	equ	_LVOFindTask
LoadRGB32	equ	_LVOLoadRGB32
ScrollVPort	equ	_LVOScrollVPort

; controlpad.library 40.2. controlpad.i is not in Includes.
cpAlloc	equ	-30
cpFree	equ	-54
cpGet	equ	-60

CPB_UP	equ	0
CPB_DOWN	equ	1
CPB_LEFT	equ	2
CPB_RIGHT	equ	3
CPB_A	equ	4
CPB_B	equ	5
CPB_C	equ	6
CPB_START	equ	7

CPU_JOYPORT	equ	2
