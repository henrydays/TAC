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

DADOS	segment para public 'data'
		
   ;~~~~~~~~~~~~~~~~~Variáveis do Cursor~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~    
        string	db	"Teste prático de T.I",0
		Car		db	32	; Guarda um caracter do Ecran 
		Cor		db	7	; Guarda os atributos de cor do caracter
		Car2		db	32	; Guarda um caracter do Ecran 
		Cor2		db	7	; Guarda os atributos de cor do caracter
		POSy		db	8	; a linha pode ir de [1 .. 25]
		POSx		db	30	; POSx pode ir [1..80]	
		POSya		db	5	; Posição anterior de y
		POSxa		db	10	; Posição anterior de x
    ;~~~~~~~~~~~~~~~~~Variáveis do Cursor~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~   

    ;~~~~~~~~~~~~~~~~~Variáveis do Tabuleiro~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 
       
        ultimo_num_aleat dw 0
    	str_num db 5 dup(?),'$'
	    linha		db	0	; Define o n�mero da linha que est� a ser desenhada
        nlinhas		db	0
	    corTab		db 	0
        carTab		db	' '	

   ;~~~~~~~~~~~~~~~~~Variáveis do Tabuleiro~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 


    ;~~~~~~~~~~~~~~~~~~Informações sobre o tabuleiro~~~~~~~~~~~~~~~~~~~~~~~~~
       
        tamX db 9 ; Largura do tabuleiro
        tamY db 6 ; Altura do tabuleiro
        iniX dw 60 ; Primeiro ponto do tabuleiro em X
        iniY db 8 ; Primeiro ponto do tabuleiro em Y
    
    ;~~~~~~~~~~~~~~~~~~Informações sobre o tabuleiro~~~~~~~~~~~~~~~~~~~~~~~~~

    ;~~~~~~~~~~~~~~~~~~~~~~~~Variáveis dos Menus~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

           
	 Menu		db "       _______ _______ __   __ _______ ___     _______ _______ _______  ",10,13
				db "      |       |       |  | |  |  _    |   |   |   _   |       |       | ",10,13
				db "      |_     _|   _   |  |_|  | |_|   |   |   |  |_|  |  _____|_     _| ",10,13
  				db "        |   | |  | |  |       |       |   |   |       | |_____  |   |   ",10,13 
  				db "        |   | |  |_|  |_     _|  _   ||   |___|       |_____  | |   |   ",10,13
  				db "        |   | |       | |   | | |_|   |       |   _   |_____| | |   |   ",10,13
  				db "        |___| |_______| |___| |_______|_______|__| |__|_______| |___|   ",10,13
                db "                                                                        ",10,13
				db "              1 - Jogar                                                 ",10,13
				db "              2 - Ver Pontuacoes                                        ",10,13
				db "              3 - Configuracao da Grelha                                ",10,13
				db "              4 - Sair                                                  ",10,13
				db "                                                                        ",10,13
				db "        Input: ",10, 13,10, 13,10, 13,10, 13
				db  '$'
	
  




DADOS	ends

CODIGO	segment para public 'code'
assume		cs:CODIGO, ds:DADOS



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



;~~~~~~~~~~~~~~~~~~~~~~~ Inicio do programa ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Main  proc

        mov		AX, DADOS
		mov		DS,AX


CICLOMENU:
	
		goto_xy 0,0
		
        ; ~~~~~~~~~~~~~~~Limpar o ecra~~~~~~~~~~~
		MOV		AX,0B800H
		MOV		ES,AX
		
        call APAGA_ECRAN
	

    	;~~~~~~~~~~Imprimir no ecra o Menu~~~~~~~
		
		lea     dx, Menu 
		mov  ah, 07h    ; Espera para que o utilizador insira um caracter
        int  21h
        cmp  al, '1'    ; Se inserir o numero 1
        jmp Jogar
			
	

		
		FORA: 
			CMP AL, 27 ; TECLA ESCAPE
			JE fim;
		
	JMP CICLOMENU

jogar:

        ;#cenas#####
        mov	cx,10		; Faz o ciclo 10 vezes
		;#cenas#####
     
      
    	call APAGA_ECRAN	
		mov		ax,0B800h
		mov		es,ax
	
		goto_xy		POSx,POSy	; Vai para nova possição
		mov 		ah, 08h	; Guarda o Caracter que est� na posição do Cursor
		mov		bh,0		; numero da página
		int		10h			
		mov		Car, al	; Guarda o Caracter que está na posição do Cursor
		mov		Cor, ah	; Guarda a cor que está na posição do Cursor	
		
		inc		POSx
		goto_xy		POSx,POSy	; Vai para nova possição2
		mov 		ah, 08h		; Guarda o Caracter que está na posição do Cursor
		mov		bh,0		; numero da página
		int		10h			
		mov		Car2, al	; Guarda o Caracter que está na posição do Cursor
		mov		Cor2, ah	; Guarda a cor que está na posição do Cursor	
		dec		POSx
	
ciclo4:
		call	CalcAleat
		pop	ax 		; vai buscar 'a pilha o n�mero aleat�rio

		mov	dl,cl	
		mov	dh,70
		push	dx		; Passagem de par�metros a impnum (posição do ecran)
		push	ax		; Passagem de par�metros a impnum (número a imprimir)
		;call	impnum		; imprime 10 aleatórios na parte direita do ecran
		loop	ciclo4		; Ciclo de impress�o dos n�meros aleat�rios
		
		mov   	ax, 0b800h	; Segmento de mem�ria de v�deo onde vai ser desenhado o tabuleiro
		mov   	es, ax	
		mov	linha, 	8	; O Tabuleiro vai começar a ser desenhado na linha 8 
		mov	nlinhas, 6	; O Tabuleiro vai ter 6 linhas
ciclo2:		mov	al, 160		
		mov	ah, linha
		mul	ah
		add	ax, 60
		mov 	bx, ax		; Determina Endere�o onde come�a a "linha". bx = 160*linha + 60

		mov	cx, 9		; São 9 colunas 
ciclo1:  	
		mov 	dh,	carTab	; vai imprimir o caracter "SpCE"
		mov	es:[bx],dh	;


novacor:	
		call	CalcAleat	; Calcula próximo aleatório que é colocado na pinha 
		pop	ax ; 		; Vai buscar 'a pilha o número aleatório
		and 	al,01110000b	; posição do ecran com cor de fundo aleat�rio e caracter a preto
		cmp	al, 0		; Se o fundo de ecran é preto
		je	novacor		; vai buscar outra cor 

		mov 	dh,	   carTab	; Repete mais uma vez porque cada pe�a do tabuleiro ocupa dois carecteres de ecran
		mov	es:[bx],   dh		
		mov	es:[bx+1], al	; Coloca as caracter�sticas de cor da posi��o atual 
		inc	bx		
		inc	bx		; pr�xima posi��o e ecran dois bytes � frente 

		mov 	dh,	   carTab	; Repete mais uma vez porque cada pe�a do tabuleiro ocupa dois carecteres de ecran
		mov	es:[bx],   dh
		mov	es:[bx+1], al
		inc	bx
		inc	bx
		
		mov	di,1 ;delay de 1 centesimo de segundo
		call	delay
		loop	ciclo1		; continua at� fazer as 9 colunas que correspondem a uma liha completa
		
		inc	linha		; Vai desenhar a pr�xima linha
		dec	nlinhas		; contador de linhas
		mov	al, nlinhas
		cmp	al, 0		; verifica se j� desenhou todas as linhas 
		jne	ciclo2		; se ainda h� linhas a desenhar continua 



CICLO_CURSOR:		goto_xy	POSxa,POSya	; Vai para a posição anterior do cursor
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
		mov		Cor, ah	; Guarda a cor que est� na posição do Cursor
		
		inc		POSx
		goto_xy		POSx,POSy	; Vai para nova possi��o
		mov 		ah, 08h
		mov		bh,0		; numero da p�gina
		int		10h		
		mov		Car2, al	; Guarda o Caracter2 que est� na posi��o do Cursor2
		mov		Cor2, ah	; Guarda a cor que est� na posi��o do Cursor2
		dec		POSx
		
		
		goto_xy		77,0		; Mostra o caractr que estava na posi��o do AVATAR
		mov		ah, 02h		; IMPRIME caracter da posição no canto
		mov		dl, Cor	
		int		21H		
        	
		
		goto_xy		78,0		; Mostra o caractr2 que estava na posi��o do AVATAR
		mov		ah, 02h		; IMPRIME caracter2 da posição no canto
		mov		dl, Car2	

		int		21H			
		
        
	
		goto_xy		POSx,POSy	; Vai para posição do cursor

IMPRIME:	mov		ah, 02h
		mov		dl, '('	; Coloca AVATAR1
		int		21H
		
		inc		POSx
		goto_xy		POSx,POSy		
		mov		ah, 02h
		mov		dl, ')'	; Coloca AVATAR2
		int		21H	
		dec		POSx
		
		goto_xy		POSx,POSy	; Vai para posição do cursor
		
		mov		al, POSx	; Guarda a posiçãoo do cursor
		mov		POSxa, al
		mov		al, POSy	; Guarda a posição do cursor
		mov 		POSya, al
		
LER_SETA:	

        call 		LE_TECLA
		cmp		ah, 1
		je		ESTEND
		CMP 		AL, 27	;  27=> ESC ascii
		JE		FIM
		jmp		LER_SETA
		
ESTEND:		
        cmp 		al,48h
		jne		BAIXO

		dec		POSy		;cima
		jmp		CICLO_CURSOR

BAIXO:		
        cmp		al,50h
		jne		ESQUERDA
		inc 		POSy		;Baixo
		jmp		CICLO_CURSOR

ESQUERDA:
		cmp		al,4Bh
		jne		DIREITA
		dec		POSx		;Esquerda
		dec		POSx		;Esquerda

		jmp		CICLO_CURSOR

DIREITA:
		cmp		al,4Dh
		jne		LER_SETA 
		inc		POSx		;Direita
		inc		POSx		;Direita
		
		jmp		CICLO_CURSOR

ESPACO:

        cmp al,71

fim:	
		mov		ah,4CH
		INT		21H
Main	endp

;------------------------------------------------------
;CalcAleat - calcula um numero aleatorio de 16 bits
;Parametros passados pela pilha
;entrada:
;n�o tem parametros de entrada
;saida:
;param1 - 16 bits - numero aleatorio calculado
;notas adicionais:
; deve estar definida uma variavel => ultimo_num_aleat dw 0
; assume-se que DS esta a apontar para o segmento onde esta armazenada ultimo_num_aleat
CalcAleat proc near

	sub	sp,2		; 
	push	bp
	mov	bp,sp
	push	ax
	push	cx
	push	dx	
	mov	ax,[bp+4]
	mov	[bp+2],ax

	mov	ah,00h
	int	1ah

	add	dx,ultimo_num_aleat	; vai buscar o aleat�rio anterior
	add	cx,dx	
	mov	ax,65521
	push	dx
	mul	cx			
	pop	dx			 
	xchg	dl,dh
	add	dx,32749
	add	dx,ax

	mov	ultimo_num_aleat,dx	; guarda o novo numero aleat�rio  

	mov	[BP+4],dx		; o aleat�rio � passado por pilha

	pop	dx
	pop	cx
	pop	ax
	pop	bp
	ret
CalcAleat endp

;------------------------------------------------------
;impnum - imprime um numero de 16 bits na posicao x,y
;Parametros passados pela pilha
;entrada:
;param1 -  8 bits - posicao x
;param2 -  8 bits - posicao y
;param3 - 16 bits - numero a imprimir
;saida:
;n�o tem parametros de sa�da
;notas adicionais:
; deve estar definida uma variavel => str_num db 5 dup(?),'$'
; assume-se que DS esta a apontar para o segmento onde esta armazenada str_num
; sao eliminados da pilha os parametros de entrada
impnum proc near
	push	bp
	mov	bp,sp
	push	ax
	push	bx
	push	cx
	push	dx
	push	di
	mov	ax,[bp+4] ;param3
	lea	di,[str_num+5]
	mov	cx,5
prox_dig:
	xor	dx,dx
	mov	bx,10
	div	bx
	add	dl,'0' ; dh e' sempre 0
	dec	di
	mov	[di],dl
	loop	prox_dig

	mov	ah,02h
	mov	bh,00h
	mov	dl,[bp+7] ;param1
	mov	dh,[bp+6] ;param2
	int	10h
	mov	dx,di
	mov	ah,09h
	int	21h
	pop	di
	pop	dx
	pop	cx
	pop	bx
	pop	ax
	pop	bp
	ret	4 ;limpa parametros (4 bytes) colocados na pilha
impnum endp






;recebe em di o n�mero de milisegundos a esperar
delay proc
	pushf
	push	ax
	push	cx
	push	dx
	push	si
	
	mov	ah,2Ch
	int	21h
	mov	al,100
	mul	dh
	xor	dh,dh
	add	ax,dx
	mov	si,ax


ciclo1:	mov	ah,2Ch
	int	21h
	mov	al,100
	mul	dh
	xor	dh,dh
	add	ax,dx

	cmp	ax,si 
	jnb	naoajusta
	add	ax,6000 ; 60 segundos
naoajusta:
	sub	ax,si
	cmp	ax,di
	jb	ciclo1

	pop	si
	pop	dx
	pop	cx
	pop	ax
	popf
	ret
delay endp

CODIGO	ends
end	Main


		
