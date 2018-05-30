.8086
.MODEL SMALL
.STACK 2048
 
DADOS   SEGMENT PARA 'DATA'
    ; --- DADOS PRINCIPAIS ---
		POSx_in db 4 ;posicao X dentro do tabul
		POSy_in db 3 ;posicao Y dentro do tabul
		vetor db 108 dup(0) 
		flag_esq_dir db 0 ; se tiver pe�as iguais a esq ou dir = 1
		flag_cim_baix db 0 ;se tiver pe�as iguais cima ou baixo = 1
		ind_alvo db 0 ; indicie no vetor do alvo que foi escolhe
		zona_tipo db 0,0 ; [tipo = 0 � h� explos�o, tipo=1 Horizontal, tipo=2 Vertical, tipo = 3 Estrela] [Indice em Bx do centro]
    ; --- !DADOS PRINCIPAIS ---
   
    ; --- DADOS INICIAIS ---
        tamX db 9 ; Largura do tabuleiro
        tamY db 6 ; Altura do tabuleiro
        iniX dw 60 ; Primeiro ponto do tabuleiro em X
        iniY db 8 ; Primeiro ponto do tabuleiro em Y
    ; --- !DADOS INICIAIS ---
	
	; --- VARIAVEIS DO TABULEIRO ---
        ultimo_num_aleat dw 0
        str_num db 5 dup(?),'$'
        ;cor    db  0
        carESP  db  ' '    
    ; --- !VARIAVEIS DO TABULEIRO ---
   
    ; --- VARIAVEIS DO CURSOR ---
        string  db  "Teste pr�tico de T.I",0
        Car     db  32  ; Guarda um caracter do Ecran
        Cor     db  7   ; Guarda os atributos de cor do caracter
        Car2        db  32  ; Guarda um caracter do Ecran
        Cor2        db  7   ; Guarda os atributos de cor do caracter
        POSy        db  11  ; a linha pode ir de [1 .. 25]
        POSx        db  38  ; POSx pode ir [1..80] 
        iniTabY     db  8  ; pos Y[0]
        iniTabX     db  30  ; Pos X[0]
        POSya       db  5   ; Posi��o anterior de y
        POSxa       db  10  ; Posi��o anterior de x
    ; --- !VARIAVEIS DO CURSOR ---
		
	; --- VARIAVEIS DE MSG DO MENU ---	
	Menu    db      10, 13, 10, 13, "-------------------------------",0Dh,0Ah,0Dh,0Ah,09h
				db      "1 - Jogar",0Dh,0Ah,09h 
				db      "2 - Ver Pontuacoes",0Dh,0Ah,09h     
				db      "3 - Configuracao da Grelha",0Dh,0Ah,09h
				db      "4 - Sair",0Dh,0Ah,09h
				db      10, 13, 10, 13, "-----------------------",0Dh,0Ah,0Dh,0Ah,09h
				db      "Digite um numero: ",10, 13,10, 13,10, 13,10, 13
				db      '$'
				
				
	SubMenu2    db      10, 13, 10, 13, "-------------------------------",0Dh,0Ah,0Dh,0Ah,09h
				db      "1 - Geracao de Grelha de Forma Aleatoria",0Dh,0Ah,09h 
				db      "2 - Carregar Grelha",0Dh,0Ah,09h     
				db      10, 13, 10, 13, "-----------------------",0Dh,0Ah,0Dh,0Ah,09h
				db      "Digite um numero: ",10, 13,10, 13,10, 13,10, 13			
  	; --- !VARIAVEIS DE MSG DO MENU ---	

	; ---- VARIAVEIS MOSTRA VETOR ---
		tamX_v db 9 ; Largura do tabuleiro
        tamY_v db 6 ; Altura do tabuleiro
		linha_v db 0
		coluna_v db 0
	; --- !VARIAVEIS MOSTRA VETOR ---
	
	;------TRATA_HORAS_JOGO E DATA_JOGO ---
	STR12	 		DB 		"            "	; String para 12 digitos
	contaSeg 		dw 		0				;contador que regista a varia��o dos segundos/tempo
	Segundos		dw		?			; Vai guardar os segundos actuais
	Old_seg			dw		0				; Guarda os �ltimos segundos que foram lidos
	;------TRATA_HORAS_JOGO E DATA_JOGO ---
	
	
	
	
	
   
DADOS   ENDS
 
CODIGO  SEGMENT PARA 'CODE'
    ASSUME CS:CODIGO, DS:DADOS
   
; ---- PROCEDIMENTOS TABULEIRO ---
    ; ---- PROCEDIMENTO GERA ALEATORIO ---
    CalcAleat proc near
        sub sp,2        ;
        push    bp
        mov bp,sp
        push    ax
        push    cx
        push    dx 
        mov ax,[bp+4]
        mov [bp+2],ax
 
        mov ah,00h
        int 1ah
 
        add dx,ultimo_num_aleat ; vai buscar o aleat�rio anterior
        add cx,dx  
        mov ax,65521
        push    dx
        mul cx         
        pop dx           
        xchg    dl,dh
        add dx,32749
        add dx,ax
 
        mov ultimo_num_aleat,dx ; guarda o novo numero aleat�rio  
 
        mov [BP+4],dx       ; o aleat�rio � passado por pilha
 
        pop dx
        pop cx
        pop ax
        pop bp
        ret
    CalcAleat endp
   
 
    ; ---- PROCEDIMENTO DELAY ---
    delay proc
        pushf
        push    ax
        push    cx
        push    dx
        push    si
       
        mov ah,2Ch
        int 21h
        mov al,100
        mul dh
        xor dh,dh
        add ax,dx
        mov si,ax
 
    ciclo:  mov ah,2Ch
        int 21h
        mov al,100
        mul dh
        xor dh,dh
        add ax,dx
 
        cmp ax,si
        jnb naoajusta
        add ax,6000 ; 60 segundos
    naoajusta:
        sub ax,si
        cmp ax,di
        jb  ciclo
 
        pop si
        pop dx
        pop cx
        pop ax
        popf
        ret
    delay endp
   
; ---- !PROCEDIMENTOS TABULEIRO ---
   
; ---- PROCEDIMENTOS/ROTINAS CURSOR ---
    ; ---- VAI PARA X E Y ---
    goto_xy macro       POSx,POSy
        mov     ah,02h
        mov     bh,0        ; numero da p�gina
        mov     dl,POSx
        mov     dh,POSy
        int     10h

    endm
	; MOSTRA - Faz o display de uma string terminada em $

MOSTRA MACRO STR 
	MOV AH,09H
	LEA DX,STR 
	INT 21H
ENDM
   
    ;ROTINA PARA APAGAR ECRAN
    apaga_ecran proc
            xor     bx,bx
            mov     cx,25*80
           
    apaga:          mov byte ptr es:[bx],' '
            mov     byte ptr es:[bx+1],7
            inc     bx
            inc         bx
            loop        apaga
            ret
    apaga_ecran endp
   
    ; LE UMA TECLA
    LE_TECLA    PROC
 sem_tecla:
		call trata_horas_jogo
		mov	ah,0bh
		int 21h
		cmp al,0
		je	sem_tecla
		
            mov     ah,08h
            int     21h
            mov     ah,0
            cmp     al,0
            jne     SAI_TECLA
            mov     ah, 08h
            int     21h
            mov     ah,1
    SAI_TECLA:  RET
    LE_TECLA    endp
; ---- !PROCEDIMENTOS/ROTINAS CURSOR ---
   
   
;########################################################################
; IMPRIME O TEMPO E A DATA NO MONITOR

TRATA_HORAS_JOGO PROC

	PUSHF
	PUSH AX
	PUSH BX
	PUSH CX
	PUSH DX		

	cmp 	segundos, 0
	je 		FIM_HORAS
	CALL 	LER_TEMPO_JOGO				; Horas MINUTOS e segundos do Sistema
	
	MOV		AX, contaSeg
	cmp		AX, Old_seg			; VErifica se os segundos mudaram desde a ultima leitura
	je		FIM_HORAS			; Se a hora n�o mudou desde a �ltima leitura sai.
	mov		Old_seg, AX			; Se segundos s�o diferentes actualiza informa��o do tempo

	dec Segundos
	cmp Segundos, 0
	jne CONTINUA

	
CONTINUA:
	
	
	mov 	ax,Segundos
	MOV 	bl, 10     
	div 	bl
	add 	al, 30h				; Caracter Correspondente �s dezenas
	add		ah,	30h				; Caracter Correspondente �s unidades
	MOV 	STR12[0],al			; 
	MOV 	STR12[1],ah
	MOV 	STR12[2],'s'		
	MOV 	STR12[3],'$'
	GOTO_XY	75,4
	MOSTRA	STR12 			
		
		goto_xy	POSy,POSx			; Volta a colocar o cursor onde estava antes de actualizar as horas
	
FIM_HORAS:		
		POPF
		POP DX		
		POP CX
		POP BX
		POP AX
		RET		
			
TRATA_HORAS_JOGO ENDP


;########################################################################
; HORAS  - LE HORA DO SISTEMA E COLOCA EM TRES VARIAVEIS (HORAS, MINUTOS, SEGUNDOS)

LER_TEMPO_JOGO PROC	
 
		PUSH AX
		PUSH BX
		PUSH CX
		PUSH DX
	
		PUSHF
		
		MOV AH, 2CH             ; Buscar a hORAS
		INT 21H                 
		
		XOR AX,AX
		MOV AL, DH              ; segundos para al
		mov contaSeg, AX		; guarda segundos na variavel correspondente
 
		POPF
		POP DX
		POP CX
		POP BX
		POP AX
 		RET 
LER_TEMPO_JOGO   ENDP 


;########################################################################	
ImprimeVetor proc
	; ---- MOSTRA VETOR --- BrunoFilipe22/05/2018
	xor si,si
	xor di,di
	xor bx, bx
	xor cx,cx
	xor ax,ax
	
	mov bx, 160*8
	add bx, 60
	mov coluna_v,0
	mov linha_v,0
		
	jmp mostra_vetor
	
	br:
		mov coluna_v,0
		inc linha_v
		
		add bx, 160
		sub bx, 36
		
	mostra_vetor:
		
		cmp coluna_v,18
		je br
				
		mov cl, vetor[si]
        mov dh, carESP   ; Repete mais uma vez porque cada pe�a do tabuleiro ocupa dois carecteres de ecran
        mov es:[bx],   dh      
        mov es:[bx+1], cl   ; Coloca as caracter�sticas de cor da posi��o atual
        inc bx     
        inc bx 
		
		inc si
		inc coluna_v
		
		cmp si, 108
		jne mostra_vetor
		
		mov coluna_v,0
		mov linha_v,0
; ---- !MOSTRA VETOR ---		
	SAI:  RET
ImprimeVetor endp  
 
PRINC PROC
    MOV AX, DADOS
    MOV DS, AX
	MOV		AX,0B800H
	MOV		ES,AX
	
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	CICLOMENU:
	
		goto_xy 0,0
		
        ; ------LIMPAR ECRA ----
		
		call APAGA_ECRAN

		; ------ !LIMPAR ECRA ----
		

        ;~~~~~~~~ Print Menu~~~~~~~~
		lea     dx, Menu 
		mov     ah, 09h
		int     21h
		;~~~~~~~~ Print Menu~~~~~~~~

            mov  ah, 07h ; Esperar que o utilizador insira um caracter
            int  21h
            cmp  al, '1' ; Se inserir 1
                je Jogar
			
			
			
		;SUBMENU: ; sub menu do desenho
		
			;CICLOd:
		
			;goto_xy 4,0
						; funcao apagar ecran
			;MOV		AX,0B800H
			;MOV		ES,AX
			;call APAGA_ECRAN
			; fim apaga ecran
			
			;lea     dx, SubMenu2
			;mov     ah, 09h
			;int     21h
			;call LE_TECLA
				;D1:			
					;CMP 	AL, '1'	  ; jogar - definer labirinto como defalt
					;JNE		D2
					;CALL	defineDefault
					;jmp		CICLO
				;FORAd: 
					;CMP AL, 27 ; TECLA ESCAPE so sub menu do desenho
					;JE CICLOMENU;
					
			;jmp CICLOd
		FORA: 
			CMP AL, 27 ; TECLA ESCAPE
			JE fim;
		
	JMP CICLOMENU
	
	
	
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	

jogar:
; ------LIMPAR ECRA ----
		MOV		AX,0B800H
		MOV		ES,AX
		call APAGA_ECRAN
; ------ !LIMPAR ECRA ----
 
     mov Segundos, 61 ; iniciou o jogo
	 goto_xy	20,20
	
		
	 
 
; --- TABULEIRO ---
    mov cx,10       ; Faz o ciclo 10 vezes
	xor si,si ;BrunoFilipe22/05/2018
ciclo4:
        call    CalcAleat
        pop ax      ; vai buscar 'a pilha o n�mero aleat�rio
 
        mov dl,cl  
        mov dh,70
        push    dx      ; Passagem de par�metros a impnum (posi��o do ecran)
        push    ax      ; Passagem de par�metros a impnum (n�mero a imprimir)
        ;call   impnum      ; imprime 10 aleat�rios na parte direita do ecran
        loop    ciclo4      ; Ciclo de impress�o dos n�meros aleat�rios
       
       mov     ax, 0b800h  ; Segmento de mem�ria de v�deo onde vai ser desenhado o tabuleiro
       mov     es, ax 
       ;mov iniY,8
	   ;mov tamY,6
ciclo2: 
		mov al, 160    
        mov ah, iniY
        mul ah
        add ax, iniX
        mov     bx, ax      ; Determina Endere�o onde come�a a "linha". bx = 160*linha + 60
 
        mov cl, tamX    ;Numero de colunas usando a variavel tamX
ciclo:     
        mov     dh, carESP  ; vai imprimir o caracter "SAPCE"
        mov es:[bx],dh  ;
   
novacor:   
       
        call    CalcAleat   ; Calcula pr�ximo aleat�rio que � colocado na pinha
        pop ax ;        ; Vai buscar 'a pilha o n�mero aleat�rio
        and al,01110000b   ; posi��o do ecran com cor de fundo aleat�rio e caracter a preto		
        cmp al, 0       ; Se o fundo de ecran � preto
        je  novacor     ; vai buscar outra cor
 
        mov     dh,    carESP   ; Repete mais uma vez porque cada pe�a do tabuleiro ocupa dois carecteres de ecran
        mov es:[bx],   dh      
        mov es:[bx+1], al   ; Coloca as caracter�sticas de cor da posi��o atual
        inc bx     
        inc bx      ; pr�xima posi��o e ecran dois bytes � frente
		
        mov     dh,    carESP   ; Repete mais uma vez porque cada pe�a do tabuleiro ocupa dois carecteres de ecran
        mov es:[bx],   dh
        mov es:[bx+1], al
        inc bx
        inc bx

;--------- Copiar para o vetor  -------------------------		
        ;--- Retifica cor de fundo
		mov ah,cl ; PASSAR CL PARA AH PARA O CICLO N�O MORRER
		; mov cl, 4 ; PARA FAZER O ROR TEM DE SR COM CL
		; ror al, cl
		
		; add al, 48
		;--- Retifica cor de fundo
	  
        mov vetor[si], al 
		inc si
	    mov vetor[si], al 
		inc si

	    mov cl,ah
;--------- Copiar para o vetor------------------------		
		
        mov di,1 ;delay de 1 centesimo de segundo
        call    delay
        loop    ciclo       ; continua at� fazer as 9 colunas que correspondem a uma liha completa
       
        inc iniY        ; Vai desenhar a pr�xima linha
        dec tamY        ; contador de linhas
        mov al, tamY
        cmp al, 0       ; verifica se j� desenhou todas as linhas
        jne ciclo2      ; se ainda h� linhas a desenhar continua
; ---- !TABULEIRO ---

; ---- CURSOR ---
    goto_xy     iniY,POSy   ; Vai para nova possi��o
    mov     ah, 08h ; Guarda o Caracter que est� na posi��o do Cursor
    mov     bh,0        ; numero da p�gina
    int     10h        
    mov     Car, al ; Guarda o Caracter que est� na posi��o do Cursor
   ; mov     Cor, ah ; Guarda a cor que est� na posi��o do Cursor
    ;--- Retifica cor de fundo
	mov cl, 4 ; PARA FAZER O ROR TEM DE SR COM CL
	ror ah, cl
		
	add ah, 48
	mov Cor, ah ; Guarda a cor que est� na posi��o do Cursor
	;--- Retifica cor de fundo
   
   
    inc     POSx
    goto_xy     POSx,POSy   ; Vai para nova possi��o2
    mov         ah, 08h     ; Guarda o Caracter que est� na posi��o do Cursor
    mov     bh,0        ; numero da p�gina
    int     10h        
    mov     Car2, al    ; Guarda o Caracter que est� na posi��o do Cursor
    ;ov     Cor2, ah    ; Guarda a cor que est� na posi��o do Cursor
	;--- Retifica cor de fundo
	mov cl, 4 ; PARA FAZER O ROR TEM DE SR COM CL
	ror ah, cl
		
	add ah, 48
	mov Cor2, ah ; Guarda a cor que est� na posi��o do Cursor
	;--- Retifica cor de fundo
    dec     POSx
 
CICLO_CURSOR:       
        
        goto_xy POSxa,POSya ; Vai para a posi��o anterior do cursor

		call	ImprimeVetor

        mov     ah, 02h
        mov     dl, Car ; Repoe Caracter guardado
        int     21H
 
        inc     POSxa
        goto_xy     POSxa,POSya
        mov     ah, 02h
        mov     dl, Car2    ; Repoe Caracter2 guardado
        int     21H
        dec         POSxa
       
        goto_xy POSx,POSy   ; Vai para nova possi��o
        mov         ah, 08h
        mov     bh,0        ; numero da p�gina
        int     10h    
        mov     Car, al ; Guarda o Caracter que est� na posi��o do Cursor
        ;mov     Cor, ah ; Guarda a cor que est� na posi��o do Cursor
		;--- Retifica cor de fundo
		mov cl, 4 ; PARA FAZER O ROR TEM DE SR COM CL
		ror ah, cl
			
		add ah, 48
		mov Cor, ah ; Guarda a cor que est� na posi��o do Cursor
		;--- Retifica cor de fundo
       
        inc     POSx
        goto_xy     POSx,POSy   ; Vai para nova possi��o
        mov         ah, 08h
        mov     bh,0        ; numero da p�gina
        int     10h    
        mov     Car2, al    ; Guarda o Caracter2 que est� na posi��o do Cursor2
        ;mov     Cor2, ah    ; Guarda a cor que est� na posi��o do Cursor2
        
		;--- Retifica cor de fundo
		mov cl, 4 ; PARA FAZER O ROR TEM DE SR COM CL
		ror ah, cl
			
		add ah, 48
		mov Cor2, ah ; Guarda a cor que est� na posi��o do Cursor
		;--- Retifica cor de fundo
		dec     POSx
       
       
        goto_xy     77,0        ; Mostra o caractr que estava na posi��o do AVATAR
        mov     ah, 02h     ; IMPRIME caracter da posi��o no canto
        mov     dl, Car
        int     21H        
       
        goto_xy     78,0        ; Mostra o caractr2 que estava na posi��o do AVATAR
        mov     ah, 02h     ; IMPRIME caracter2 da posi��o no canto
        mov     dl, Cor2   
        int     21H 

		goto_xy     60,0        ; Mostra o caractr2 que estava na posi��o do AVATAR
		mov al, 48
		add al, POSx_in
        mov     ah, 02h     ; IMPRIME caracter2 da posi��o no canto
        mov     dl, al   
        int     21H 
		
		goto_xy     61,0        ; Mostra o caractr2 que estava na posi��o do AVATAR
		mov al, 48
		add al, POSy_in
        mov     ah, 02h     ; IMPRIME caracter2 da posi��o no canto
        mov     dl, al   
        int     21H 
       
   
        goto_xy     POSx,POSy   ;Vai para posi��o do cursor

IMPRIME:    mov     ah, 02h
        mov     dl, 177 ;Coloca AVATAR1  Gon�alo Muda para 176, 177, 178 e v� qual fica melhor
        int     21H
       
        inc     POSx
        goto_xy     POSx,POSy      
        mov     ah, 02h
        mov     dl, 177 ; Coloca AVATAR2 Gon�alo Muda para 176, 177, 178 e v� qual fica melhor
        int     21H
        dec     POSx
       
        goto_xy     POSx,POSy   ; Vai para posi��o do cursor
       
        mov     al, POSx    ; Guarda a posi��o do cursor
        mov     POSxa, al
        mov     al, POSy    ; Guarda a posi��o do cursor
        mov         POSya, al
       
LER_SETA:
   
; ---- MOSTRA VETOR --- BrunoFilipe22/05/2018
; xor si,si
; xor di,di
	; ;linha_v
	; ;coluna_v
	; br:
	; mov coluna_v,0
	; inc linha_v
	; mostra_vetor:
		
		; cmp coluna_v,18
		; je br
				
		; goto_xy coluna_v,linha_v	
		; mov     ah, 02h     
        ; mov     dl, vetor[si]  
        ; int     21H
		
		; inc si
		; inc coluna_v
		
		; cmp si, 108
		; jne mostra_vetor
		
		; mov coluna_v,0
		; mov linha_v,0
; ---- !MOSTRA VETOR ---

		call        LE_TECLA
        cmp     ah, 1
        je      ESTEND
        CMP         AL, 27  ; ESCAPE
        JE      FIM
        jmp     LER_SETA
       
ESTEND:     cmp         al,48h
        jne     BAIXO
        mov ah,iniTabY
        cmp ah,POSy
        je Teste
        dec     POSy        ;cima
		dec POSy_in
        jmp     CICLO_CURSOR ;repor as cenas
 
 
BAIXO:      cmp     al,50h
        jne     ESQUERDA
        mov ah,iniTabY
        add ah,5 ;;limite inferior
        cmp ah,POSy
        je Teste
        inc         POSy        ;Baixo
		inc POSy_in
        jmp     CICLO_CURSOR
 
ESQUERDA:
        cmp     al,4Bh
        jne     DIREITA
        mov ah,iniTabX
        cmp ah,POSx
        je Teste
        dec     POSx        ;Esquerda
        dec     POSx        ;Esquerda
		dec     POSx_in       ;Esquerda
        jmp     CICLO_CURSOR ;repor as cenas
 
 
DIREITA:
        cmp     al,4Dh
        jne     ESPACO
        mov ah,iniTabX
        add ah,16 ;; posiscao x[8] -> 16 cursor ocupa dois espacos
        cmp ah,POSx
        je Teste
        inc     POSx        ;Direita
        inc     POSx        ;Direita
		inc     POSx_in        ;Direita
        jmp     CICLO_CURSOR ;repor as cenas
		
ESPACO:
        
       
        mov  ah, 07h ; Esperar que o utilizador insira um caracter
        int  21h
        cmp  al, ' '  ; Se inserir 1
     
        jne     LER_SETA
        mov ah,iniTabX
        add ah,16 ;; posiscao x[8] -> 16 cursor ocupa dois espacos
        cmp ah,POSx
        je Teste
        
		
		
		;-- PUMMMM E TCHHHHHHH
		; vector -> Array onde temos o numero de cores do tabul
		; Cor2 -> Cor que o cursor esta em cima
		;flag_esq_dir -> se tiver pe�as iguais a esq ou dir = 1
		;flag_cim_baix -> se tiver pe�as iguais cima ou baixo = 1
		; POS_PRETENDIDA = ((POSy_in - 1)*19)+POSx_in
		;Ver a Dir e Esq
		xor di, di
		xor ax, ax
		xor bx, bx
		xor cx, cx
		xor dx, dx
				
		mov ax, 2
		mul POSx_in
		mov cx, ax

		mov ax, 18
		mul POSy_in
		
		add cx, ax
		
		mov bx,cx		
		; mov vetor[bx], 0
		; inc bx
		; mov vetor[bx], 0
		; mov bx, 16
		; mov vetor[bx], 0
		
				
		xor dx,dx
		mov dl, vetor[bx] ;guardar conteudo do vector
		
	explosao_dir:
		cmp POSx_in, 8
		je explosao_esq
		cmp dl, vetor[bx+2]
		jne explosao_esq 
		muda_dir:

			mov vetor[bx], 0
			mov vetor[bx+1], 0
			mov vetor[bx+2], 0
			mov vetor[bx+3], 0
			
			; ;ir ao ecra tirar as pe�as
			; xor si, si
			; xor cx, cx
			; xor ax,ax
			
			; mov ax, 1
			; mul POSx
			; mov cx, ax

			; mov ax, 80
			; mul POSy
			
			; add cx, ax
					
			; inc_si:
				; inc si
				; inc si
			; loop inc_si
			
			; mov dh,    carESP   ; Repete mais uma vez porque cada pe�a do tabuleiro ocupa dois carecteres de ecran
			; mov al, 0000000b
			; ;-------------------
			; mov es:[si],   dh      
			; mov es:[si+1], al   ; Coloca a cor na posi��o atual
			; add si, 2
			; mov es:[si],   dh      
			; mov es:[si+1], al   ; Coloca a cor na posi��o atual
			; ;-------------------
			; add si, 2
			; mov es:[si],   dh      
			; mov es:[si+1], al   ; Coloca a cor na posi��o a frente
			; add si, 2
			; mov es:[si],   dh      
			; mov es:[si+1], al   ; Coloca a cor na posi��o frente
						
	explosao_esq:
		cmp POSx_in, 0
		je explosao_baixo	
		cmp dl, vetor[bx-2]
		jne explosao_baixo 
		muda_esq:

			mov vetor[bx], 0
			mov vetor[bx+1], 0			
			mov vetor[bx-1], 0
			mov vetor[bx-2], 0
			
			; ;ir ao ecra tirar as pe�as
			; xor si, si
			; xor cx, cx
			; xor dx,dx
			; xor ax,ax
			
			; mov ax, 1
			; mul POSx
			; mov cx, ax

			; mov ax, 80
			; mul POSy
			
			; add cx, ax
					
			; inc_si1:
				; inc si
				; inc si
			; loop inc_si1
			
			; mov dh,    carESP   ; Repete mais uma vez porque cada pe�a do tabuleiro ocupa dois carecteres de ecran
			; mov al, 0000000b
			; ;-------------------
			; mov es:[si],   dh      
			; mov es:[si+1], al   ; Coloca a cor na posi��o atual
			; add si, 2
			; mov es:[si],   dh      
			; mov es:[si+1], al   ; Coloca a cor na posi��o atual
			; ;-------------------
			; sub si, 4
			; mov es:[si],   dh      
			; mov es:[si+1], al   ; Coloca a cor na posi��o atras
			; sub si, 2
			; mov es:[si],   dh      
			; mov es:[si+1], al   ; Coloca a cor na posi��o atras
			; ;-------------------
			
	explosao_baixo:
		cmp POSy_in, 5
		je explosao_cima
		cmp dl, vetor[bx+18]
		jne explosao_cima 
		
		muda_baixo:
			mov vetor[bx], 0
			mov vetor[bx+1], 0
			mov vetor[bx+18], 0
			mov vetor[bx+19], 0
			
			; ;ir ao ecra tirar as pe�as
			; xor si, si
			; xor cx, cx
			; xor dx,dx
			; xor ax,ax
			
			; mov ax, 1
			; mul POSx
			; mov cx, ax

			; mov ax, 80
			; mul POSy
			
			; add cx, ax
					
			; inc_si3:
				; inc si
				; inc si
			; loop inc_si3
			
			; mov dh,    carESP   ; Repete mais uma vez porque cada pe�a do tabuleiro ocupa dois carecteres de ecran
			; mov al, 0000000b
			; ;-------------------
			; mov es:[si],   dh      
			; mov es:[si+1], al   ; Coloca a cor na posi��o atual
			; add si, 2
			; mov es:[si],   dh      
			; mov es:[si+1], al   ; Coloca a cor na posi��o atual
			; ;-------------------
			; add si, 158
			; mov es:[si],   dh      
			; mov es:[si+1], al   ; Coloca a cor na posi��o a baixo
			; add si, 2
			; mov es:[si],   dh      
			; mov es:[si+1], al   ; Coloca a cor na posi��o baixo
	
	explosao_cima:
		cmp POSy_in, 0
		je CICLO_CURSOR
		cmp dl, vetor[bx-18]
		jne CICLO_CURSOR
		
		muda_cima:
			mov vetor[bx-18], 0
			mov vetor[bx-17], 0
			mov vetor[bx], 0
			mov vetor[bx+1], 0
			
			; ;ir ao ecra tirar as pe�as
			; xor si, si
			; xor cx, cx
			; xor dx,dx
			; xor ax,ax
			
			; mov ax, 1
			; mul POSx
			; mov cx, ax

			; mov ax, 80
			; mul POSy
			
			; add cx, ax
					
			; inc_si2:
				; inc si
				; inc si
			; loop inc_si2
			
			; mov dh,    carESP   ; Repete mais uma vez porque cada pe�a do tabuleiro ocupa dois carecteres de ecran
			; mov al, 0000000b
			; ;-------------------
			; mov es:[si],   dh      
			; mov es:[si+1], al   ; Coloca a cor na posi��o atual
			; add si, 2
			; mov es:[si],   dh      
			; mov es:[si+1], al   ; Coloca a cor na posi��o atual
			; ;-------------------
			; sub si, 160
			; mov es:[si],   dh      
			; mov es:[si+1], al   ; Coloca a cor na posi��o cima
			; sub si, 2
			; mov es:[si],   dh      
			; mov es:[si+1], al   ; Coloca a cor na posi��o cima
			; ;-------------------
	
		; ;-- !PUMMMM E TCHHHHHHH
		
		
    jmp CICLO_CURSOR ;repor as cenas
Teste:
    jmp CICLO_CURSOR
; ---- !CURSOR ---

 
 
FIM:
    MOV AH,4Ch
    INT 21h
PRINC ENDP
 
 
 
CODIGO  ENDS
END PRINC