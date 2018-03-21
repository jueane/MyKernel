[SECTION .gdt]
LABEL_GDT:				Descriptor	0,				0,				0
LABEL_DESC_NORMAL:		Descriptor	0,				0ffffh,			DA_DRW
LABEL_DESC_CODE32:		Descriptor	0,				SegCode32Len-1,	DA_C+DA_32
LABEL_DESC_CODE16:		Descriptor	0,				0ffffh,			DA_C
LABEL_DESC_DATA:		Descriptor	0,				DataLen-1,		DA_DRW
LABEL_DESC_STACK:		Descriptor	0,				TopOfStack,		DA_DRWA+DA_32
LABEL_DESC_TEST:		Descriptor	0500000h,		0ffffh,			DA_DRW
LABEL_DESC_VIDEO:		Descriptor	0B8000h,		0ffffh,			DA_DRW

GdtLen			equ		$-LABEL_GDT			;GDT长度
GdtPtr			dw		GdtLen-1
				dd		0

;GDT选择子
SelectorNormal			equ		LABEL_DESC_NORMAL-LABEL_GDT
SelectorCode32			equ		LABEL_DESC_CODE32-LABEL_GDT
SelectorCode16			equ		LABEL_DESC_CODE16-LABEL_GDT
SelectorData			equ		LABEL_DESC_DATA-LABEL_GDT
SelectorStack			equ		LABEL_DESC_STACK-LABEL_GDT
SelectorTest			equ		LABEL_DESC_TEST-LABEL_GDT
SelectorVideo			equ		LABEL_DESC_VIDEO-LABEL_GDT

[SECTION .data1]
ALIGN 32
[BITS 32]
LABEL_DATA:
SPValueInRealMode	dw		0
;字符串
PMMessage:			db		"In protected mode now",0
OffsetPMMessage		equ		PMMessage-$$
StrTest:			db		"abcdefghijk"
OffsetStrTest		equ		StrTest-$$
DataLen				equ		$-LABEL_DATA

;全局堆栈段
[SECTION .gs]
ALIGN 32
[BITS 32]
LABEL_STACK:
	times 512 db 0
TopOfStack			equ		$-LABEL_STACK

;32位
LABEL_SEG_CODE32:
	mov ax,SelectorData
	mov ds,ax
	mov ax,SelectorTest
	mov es,ax
	mov ax,SelectorVideo
	mov gs,ax

	mov ax,SelectorStack
	mov ss,ax

	mov esp,TopOfStack

	;下面显示一个字符串
	mov ah,0ch
	xor esi,esi
	xor edi,edi
	mov esi,OffsetPMMessage
	mov edi,(80*10+0)*2
	cld
.1:
	lodsb
	test al,al
	jz .2
	mov [gs:edi],ax
	add edi,2
	jmp .1
.2:
	call DispReturn
	
	call TestRead
	call TestWrite
	call TestRead

	;至此停止
	jmp SelectorCode16:0

;--------------------------------------
TestRead:
	xor esi,esi
	mov ecx,8
.loop:
	mov al,[es:esi]
	call DispAL
	inc esi
	loop .loop

	call DispReturn

	ret
;TestRead 结束--------------------------

;---------------------------------------
TestWrite:
	push esi
	push edi
	xor esi,esi
	xor edi,edi
	mov esi,OffsetStrTest
	cld
.1:
	lodsb
	test al,al
	jz .2
	mov [es:edi],al
	inc edi
	jmp .1
.2:
	pop edi
	pop esi

	ret
;testWrite 结束--------------------------

DispAL:
	push ecx
	push edx

	mov ah,0ch
	mov dl,al
	shr al,4
	mov ecx,2
.begin:
	and al,01111b
	cmp al,9
	ja .1
	add al,'0'
	jmp .2
.1:
	sub	al,0ah
	add	al,'A'
.2:
	mov [gs:edi],ax
	add edi,2

	mov al,dl
	loop .begin
	add edi,2

	pop edx
	pop ecx
	
	ret
;DispAL 结束 -----------------------------

;------------------------------------
DispReturn
	push eax
	push ebx
	mov eax,edi
	mov bl,160
	div bl
	and eax,0ffh
	inc eax
	mov bl,160
	mul bl
	mov edi,eax
	pop ebx
	pop eax

	ret
;DispReturn 结束 ---------------------------
























