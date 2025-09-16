; COLOUR CHART
; 0 - BLACK			| 9 - LIGHT BLUE
; 1 - BLUE			| A - LIGHT GREEN
; 2 - GREEN			| B - LIGHT CYAN
; 3 - CYAN			| C - LIGHT RED
; 4 - RED			| D - LIGHT MAGENTA
; 5 - MAGENTA		| E - YELLOW
; 6 - BROWN			| F - WHITE
; 7 - LIGHT GREY	|
; 8 - DARK GREY		|

[BITS 16]											; DEFINE 16 Bit Mode
[ORG 0x7c00]										; Start Address | First Sector of MBR code

start:												; entry point of the program
; Initialize Segment Registers [16-bit] and Stack Pointer
	xor ax,ax										; Put 0 in ax
	mov ds,ax										; Data Segment  -> 16-bit Register
	mov es,ax										; Extra Segment -> 16-bit Register
	mov ss,ax										; Stack Segment -> 16-bit Register
	mov sp,0x7C00									; Stack Pointer Address = 0x7C00 | Stack Grows Downwards

TestDiskExtension:
	mov [DriveID], dl								; get the current drive id
	mov ah, 0x41									; FUNCTION CODE -> Check Extensions Present / Test Whether Extensions Are Available
	mov bx, 0x55AA
	int 0x13										; Interrupt 13h or 19 -> Provides Sector-Based Disk Access
	jc NotSupported									; Carry Flag -> 0=Supported, 1=Not Supported
	cmp bx,0xAA55									; compare return
	jne NotSupported

LoadLoader:
	mov si, ReadPacket								; Get Address of ReadPacket
;	Fill ReadPacket [Little Endian]
	mov word[si], 0x10								; Size of DAP [1 byte] + Unused [1 byte]
	mov word[si+2], 5								; Number of sectors to be read [2 bytes]
	mov word[si+4], 0x7E00							; Segment - LOW
	mov word[si+6], 0								; Segment - HIGH
	mov dword[si+8], 1								; ??? - LOW
	mov dword[si+0xc], 0							; ??? - HIGH
	mov dl, [DriveID]
	mov ah, 0x42									; FUNCTION CODE -> Read Sectors From Drive
	int 0x13										; Interrupt 13h or 19 -> Provides Sector-Based Disk Access 
	jc ShowError

	mov dl, [DriveID]								; store the drive id
	jmp 0x7E00										; loader.asm code start

;TestMessage:										; for testing purpose only
ShowError:
NotSupported:										; INT 10H or 0x10: https://en.wikipedia.org/wiki/INT_10H

	mov ah, 0x13									; FUNCTION CODE -> WRITE STRING
	mov al, 1										; WRITE MODE 
	mov bx, 0xC										; Attribute -> Page Number - Colour
	xor dx, dx										; ROW - COLUMN
	mov bp, Message									; Start Address of Message
	mov cx, MessageLen								; Number of Characters
	int 0x10										; Interrupt 10h or 16 -> Provides Video Service

End:												; Infinite Loop of Halt CPU, and JMP to End
	hlt
	jmp End
   
DriveID:	db 0  
ReadPacket: times 16 db 0
Message:    db "Boot Process Failed! Check for errors in ASM file..."
MessageLen: equ $-Message							; Constant

; I don't fully understand the code below me rn
times (0x1BE - ($-$$)) db 0
	
	db 80h											; Boot Indicator -> 0x80 = Bootable
	db 0,2,0										; START CHS -> [Cylinder Head Sector] Structure
	db 0f0h											; TYPE
	db 0ffh,0ffh,0ffh								; END CHS
	dd 1											; STARTING SECTOR
	dd (20*16*63-1)									; Size

	times (16*3) db 0								; ??

;	Signature
	db 0x55	
	db 0xAA	

