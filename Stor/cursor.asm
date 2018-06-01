;------------------------------------------------------------------------
;	Base para TRABALHO PRATICO - TECNOLOGIAS e ARQUITECTURAS de COMPUTADORES
;   
;	ANO LECTIVO 2017/2018
;--------------------------------------------------------------
; Demostra��o da navega��o do Ecran com um avatar
;
;		arrow keys to move 
;		press ESC to exit
;
;--------------------------------------------------------------

.8086
.model small
.stack 2048

dseg	segment para public 'data'
		string	db	"Teste pr�tico de T.I",0
		Car		db	32	; Guarda um caracter do Ecran 
		Cor		db	7	; Guarda os atributos de cor do caracter
		Car2		db	32	; Guarda um caracter do Ecran 
		Cor2		db	7	; Guarda os atributos de cor do caracter
		POSy		db	15	; a linha pode ir de [1 .. 25]
		POSx		db	10	; POSx pode ir [1..80]	
		POSya		db	5	; Posição anterior de y
		POSxa		db	10	; Posição anterior de x
dseg	ends

cseg	segment para public 'code'
assume		cs:cseg, ds:dseg


;########################################################################
goto_xy	macro		POSx,POSy
		mov		ah,02h
		mov		bh,0		; numero da p�gina
		mov		dl,POSx
		mov		dh,POSy
		int		10h
endm

;########################################################################
;ROTINA PARA APAGAR ECRAN

apaga_ecran	proc
		xor		bx,bx
		mov		cx,25*80
		
apaga:			mov	byte ptr es:[bx],' '
		mov		byte ptr es:[bx+1],7
		inc		bx
		inc 		bx
		loop		apaga
		ret
apaga_ecran	endp


;########################################################################
; LE UMA TECLA	

LE_TECLA	PROC

		mov		ah,08h
		int		21h
		mov		ah,0
		cmp		al,0
		jne		SAI_TECLA
		mov		ah, 08h
		int		21h
		mov		ah,1
SAI_TECLA:	RET
LE_TECLA	endp
;########################################################################

Main  proc
		mov		ax, dseg
		mov		ds,ax
		mov		ax,0B800h
		mov		es,ax
	
		goto_xy		POSx,POSy	; Vai para nova possi��o
		mov 		ah, 08h	; Guarda o Caracter que est� na posi��o do Cursor
		mov		bh,0		; numero da p�gina
		int		10h			
		mov		Car, al	; Guarda o Caracter que está na posiçãoo do Cursor
		mov		Cor, ah	; Guarda a cor que est� na posi��o do Cursor	
		
		inc		POSx
		goto_xy		POSx,POSy	; Vai para nova possi��o2
		mov 		ah, 08h		; Guarda o Caracter que est� na posi��o do Cursor
		mov		bh,0		; numero da p�gina
		int		10h			
		mov		Car2, al	; Guarda o Caracter que est� na posi��o do Cursor
		mov		Cor2, ah	; Guarda a cor que est� na posi��o do Cursor	
		dec		POSx
	

CICLO:		goto_xy	POSxa,POSya	; Vai para a posi��o anterior do cursor
		mov		ah, 02h
		mov		dl, Car	; Repoe Caracter guardado 
		int		21H	

		inc		POSxa
		goto_xy		POSxa,POSya	
		mov		ah, 02h
		mov		dl, Car2	; Repoe Caracter2 guardado 
		int		21H	
		dec 		POSxa
		
		goto_xy	POSx,POSy	; Vai para nova possi��o
		mov 		ah, 08h
		mov		bh,0		; numero da p�gina
		int		10h		
		mov		Car, al	; Guarda o Caracter que est� na posi��o do Cursor
		mov		Cor, ah	; Guarda a cor que est� na posi��o do Cursor
		
		inc		POSx
		goto_xy		POSx,POSy	; Vai para nova possi��o
		mov 		ah, 08h
		mov		bh,0		; numero da p�gina
		int		10h		
		mov		Car2, al	; Guarda o Caracter2 que est� na posi��o do Cursor2
		mov		Cor2, ah	; Guarda a cor que est� na posi��o do Cursor2
		dec		POSx
		
		
		goto_xy		77,0		; Mostra o caractr que estava na posi��o do AVATAR
		mov		ah, 02h		; IMPRIME caracter da posi��o no canto
		mov		dl, Car	
		int		21H			
		
		goto_xy		78,0		; Mostra o caractr2 que estava na posi��o do AVATAR
		mov		ah, 02h		; IMPRIME caracter2 da posi��o no canto
		mov		dl, Car2	
		int		21H			
		
	
		goto_xy		POSx,POSy	; Vai para posi��o do cursor
IMPRIME:	mov		ah, 02h
		mov		dl, '-'	; Coloca AVATAR1
		int		21H
		
		inc		POSx
		goto_xy		POSx,POSy		
		mov		ah, 02h
		mov		dl, '-'	; Coloca AVATAR2
		int		21H	
		dec		POSx
		
		goto_xy		POSx,POSy	; Vai para posi��o do cursor
		
		mov		al, POSx	; Guarda a posi��o do cursor
		mov		POSxa, al
		mov		al, POSy	; Guarda a posi��o do cursor
		mov 		POSya, al
		
LER_SETA:	call 		LE_TECLA
		cmp		ah, 1
		je		ESTEND
		CMP 		AL, 27	; ESCAPE
		JE		FIM
		jmp		LER_SETA
		
ESTEND:		cmp 		al,48h
		jne		BAIXO
		dec		POSy		;cima
		jmp		CICLO

BAIXO:		cmp		al,50h
		jne		ESQUERDA
		inc 		POSy		;Baixo
		jmp		CICLO

ESQUERDA:
		cmp		al,4Bh
		jne		DIREITA
		dec		POSx		;Esquerda
		dec		POSx		;Esquerda

		jmp		CICLO

DIREITA:
		cmp		al,4Dh
		jne		LER_SETA 
		inc		POSx		;Direita
		inc		POSx		;Direita
		
		jmp		CICLO

fim:	
		mov		ah,4CH
		INT		21H
Main	endp
Cseg	ends
end	Main


		
