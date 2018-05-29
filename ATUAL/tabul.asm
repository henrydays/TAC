;------------------------------------------------------------------------
;	Base para TRABALHO PRATICO - TECNOLOGIAS e ARQUITECTURAS de COMPUTADORES
;   
;	ANO LECTIVO 2017/2018
;--------------------------------------------------------------
; Demonstra��o duma forma poss�vel de desenhar o tabuleiro do jogo 
;
; Inclui uma rotina de gera��o de n�meros aleat�rios 	
;	
;
;--------------------------------------------------------------


.8086
.MODEL SMALL
.STACK 2048

DADOS	SEGMENT PARA 'DATA'
	ultimo_num_aleat dw 0

	str_num db 5 dup(?),'$'
	
        linha		db	0	; Define o n�mero da linha que est� a ser desenhada
        nlinhas		db	0
	cor		db 	0
	car		db	' '	
	
DADOS	ENDS

CODIGO	SEGMENT PARA 'CODE'
	ASSUME CS:CODIGO, DS:DADOS

PRINC PROC
	MOV	AX, DADOS
	MOV	DS, AX

	mov	cx,10		; Faz o ciclo 10 vezes
ciclo4:
		call	CalcAleat
		pop	ax 		; vai buscar 'a pilha o n�mero aleat�rio

		mov	dl,cl	
		mov	dh,70
		push	dx		; Passagem de par�metros a impnum (posi��o do ecran)
		push	ax		; Passagem de par�metros a impnum (n�mero a imprimir)
		call	impnum		; imprime 10 aleat�rios na parte direita do ecran
		loop	ciclo4		; Ciclo de impress�o dos n�meros aleat�rios
		
		mov   	ax, 0b800h	; Segmento de mem�ria de v�deo onde vai ser desenhado o tabuleiro
		mov   	es, ax	
		mov	linha, 	8	; O Tabuleiro vai come�ar a ser desenhado na linha 8 
		mov	nlinhas, 6	; O Tabuleiro vai ter 6 linhas
		
ciclo2:		mov	al, 160		
		mov	ah, linha
		mul	ah
		add	ax, 60
		mov 	bx, ax		; Determina Endere�o onde come�a a "linha". bx = 160*linha + 60

		mov	cx, 9		; S�o 9 colunas 
ciclo:  	
		mov 	dh,	car	; vai imprimir o caracter "SpCE"
		mov	es:[bx],dh	;
	
novacor:	
		call	CalcAleat	; Calcula pr�ximo aleat�rio que � colocado na pinha 
		pop	ax ; 		; Vai buscar 'a pilha o n�mero aleat�rio
		and 	al,01110000b	; posi��o do ecran com cor de fundo aleat�rio e caracter a preto
		cmp	al, 0		; Se o fundo de ecran � preto
		je	novacor		; vai buscar outra cor 

		mov 	dh,	   car	; Repete mais uma vez porque cada pe�a do tabuleiro ocupa dois carecteres de ecran
		mov	es:[bx],   dh		
		mov	es:[bx+1], al	; Coloca as caracter�sticas de cor da posi��o atual 
		inc	bx		
		inc	bx		; próxima posição e ecran dois bytes à frente 

		mov 	dh,	   car	; Repete mais uma vez porque cada peçaa do tabuleiro ocupa dois carecteres de ecran
		mov	es:[bx],   dh
		mov	es:[bx+1], al
		inc	bx
		inc	bx
		
		mov	di,1 ;delay de 1 centesimo de segundo
		call	delay
		loop	ciclo		; continua at� fazer as 9 colunas que correspondem a uma liha completa
		
		inc	linha		; Vai desenhar a pr�xima linha
		dec	nlinhas		; contador de linhas
		mov	al, nlinhas
		cmp	al, 0		; verifica se j� desenhou todas as linhas 
		jne	ciclo2		; se ainda h� linhas a desenhar continua 
FIM:
	MOV	AH,4Ch
	INT	21h
PRINC ENDP

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


ciclo:	mov	ah,2Ch
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
	jb	ciclo

	pop	si
	pop	dx
	pop	cx
	pop	ax
	popf
	ret
delay endp


CODIGO	ENDS
END	PRINC