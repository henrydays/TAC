.8086
.MODEL SMALL
.STACK 2048
 
DADOS   SEGMENT PARA 'DATA'

	indiceVetor dw 0
	count db 0

fimTempo db 0

;~~~~~~~Variavel tipo flag para dizer se está no modo de edição ou de jogo ~~~~~~~~~~~~~~
		editor db 0
		usarEditado db 0
;~~~~~~~Variavel tipo flag para dizer se está no modo de edição ou de jogo ~~~~~~~~~~~~~~


		explodiuMeio db 0

		pontuacao dw 0
		pontuacao_total db 0
	    Cor3        db  7 
    ; --- DADOS PRINCIPAIS ---
		POSx_in db 4 ;posicao X dentro do tabul
		POSy_in db 3 ;posicao Y dentro do tabul
		vetor db 108 dup(0) 
		vetor1 db 108 dup(0)
		nlinha db 5
		aux db 0
		aux2 db 0
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

	Menu db " ",10,13   
		db "																	     ",10,13
		db "  	 _______ _______ __   __   _______ ___     _______ _______ _______   ",10,13
		db "   	|       |       |  | |  | |  _    |   |   |   _   |       |       |  ",10,13
		db "   	|_     _|   _   |  |_|  | | |_|   |   |   |  |_|  |  _____|_     _|  ",10,13
  		db "   	  |   | |  | |  |       | |       |   |   |       | |_____  |   |    ",10,13
  		db "   	  |   | |  |_|  |_     _| |  _   ||   |___|       |_____  | |   |    ",10,13
  		db "   	  |   | |       | |   |   | |_|   |       |   _   |_____| | |   |    ",10,13
  		db "   	  |___| |_______| |___|   |_______|_______|__| |__|_______| |___|    ",10,13
 		db "																	     ",10,13
		db "																	     ",10,13
		db " 		1 - Jogar													     ",10,13
		db "		2 - Ver Pontuacoes											     ",10,13 
		db "		3 - Configuracao da Grelha									     ",10,13
		db "		4 - Sair													     ",10,13
		db "		Digite um numero... $											 ",10, 13
				
				
	MJogar db " ",10,13   
		db "																	     ",10,13
		db "  	 _______ _______ __   __   _______ ___     _______ _______ _______   ",10,13
		db "   	|       |       |  | |  | |  _    |   |   |   _   |       |       |  ",10,13
		db "   	|_     _|   _   |  |_|  | | |_|   |   |   |  |_|  |  _____|_     _|  ",10,13
  		db "   	  |   | |  | |  |       | |       |   |   |       | |_____  |   |    ",10,13
  		db "   	  |   | |  |_|  |_     _| |  _   ||   |___|       |_____  | |   |    ",10,13
  		db "   	  |   | |       | |   |   | |_|   |       |   _   |_____| | |   |    ",10,13
  		db "   	  |___| |_______| |___|   |_______|_______|__| |__|_______| |___|    ",10,13
 		db "																	     ",10,13
		db "																	     ",10,13
		db " 		1 - Geracao de Grelha de Forma Aleatori						     ",10,13
		db "		2 - Carregar Grelha											     ",10,13 
		db "																	     ",10,13
		db "		4 - Voltar													     ",10,13
		db "																	     ",10,13
		db "		Digite um numero... $											 ",10, 13
				
	MFim db " ",10,13
	db "																	     ",10,13
	db "																	     ",10,13
	db "																	     ",10,13
	db "								FIM			     					     ",10,13
	db "																	     ",10,13
	db "																	     ",10,13
	db "																	     ",10,13
	db "																	     ",10,13
	db "																	     ",10,13
	db "																	     ",10,13
	db "$",10,13
																		   

				db      " ",10, 13,10, 13,10, 13,10, 13			
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
	
	
		
	;~~~~~~~~FIcheiros~~~~~~~~~~~~~

	fname	db	'pergunta.txt',0
	fhandle dw	0

	msgErrorCreate	db	"Ocorreu um erro na criacao do ficheiro!$"
	msgErrorWrite	db	"Ocorreu um erro na escrita para ficheiro!$"
	msgErrorClose	db	"Ocorreu um erro no fecho do ficheiro!$"	
	
   

        Erro_Open       db      'Erro ao tentar abrir o ficheiro$'
        Erro_Ler_Msg    db      'Erro ao tentar ler do ficheiro$'
        Erro_Close      db      'Erro ao tentar fechar o ficheiro$'
        Fich         	db      'pergunta.TXT',0
        HandleFich      dw      0
        car_fich        db      ?

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
 
    ciclo:  
	    mov ah,2Ch
        int 21h
        mov al,100
        mul dh
        xor dh,dh
        add ax,dx
 
        cmp ax,si
        jnb naoajusta
        add ax, 6000 ; 60 segundos

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
	je 		MensagemFim

	CALL 	LER_TEMPO_JOGO				; Horas MINUTOS e segundos do Sistema
	
	MOV		AX, contaSeg
	cmp		AX, Old_seg			; VErifica se os segundos mudaram desde a ultima leitura
	je		FIM_HORAS			; Se a hora n�o mudou desde a �ltima leitura sai.
	mov		Old_seg, AX			; Se segundos s�o diferentes actualiza informa��o do tempo

	dec Segundos
	cmp Segundos, 0
	jne CONTINUA
Fim:

MensagemFim:
        lea     dx, MFim
		mov     ah, 09h
		int     21h
 		mov fimTempo,1
		jmp FIM_HORAS


	
CONTINUA:
	
	cmp Segundos,0
	je MensagemFim

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
	
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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
            
			cmp  al, 49 ; Se inserir 1
              je MENUJOGAR
			
			cmp al,51
				je CONF_GRELH
            
			cmp al,115
			je GRAVA_FICH


			cmp al,52
                je fim

			
			
			jmp CICLOMENU

		MENUJOGAR: ; sub menu do desenho

			mov fimTempo,0

			call APAGA_ECRAN
			lea     dx, MJogar
			mov     ah, 09h
			int     21h
				
			mov  ah, 07h ; Esperar que o utilizador insira um caracter
            int  21h
            	
			mov editor,0
			cmp  al, 49 ; Se inserir 1
                je Jogar

			cmp  al, 50 ; Se inserir 1
                je ABRE_BICH	
			

            cmp al,52
                je CICLOMENU
			
			jmp MENUJOGAR
			
			
		FORA: 
			CMP AL, 27 ; TECLA ESCAPE
			JE fim;
		
	JMP CICLOMENU

ABRE_BICH:
        mov     ah,3dh			; vamos abrir ficheiro para leitura 
        mov     al,0			; tipo de ficheiro	
        lea     dx,Fich			; nome do ficheiro
        int     21h			; abre para leitura 
        jc      erro_abrir		; pode aconter erro a abrir o ficheiro 
        mov     HandleFich,ax		; ax devolve o Handle para o ficheiro 
        jmp     ler_ciclo		; depois de abero vamos ler o ficheiro 
ler_ciclo:
        mov     ah,3fh			; indica que vai ser lido um ficheiro 
        mov     bx,HandleFich		; bx deve conter o Handle do ficheiro previamente aberto 
        mov     cx,108			; numero de bytes a ler 
        lea     dx,vetor		; vai ler para o local de memoria apontado por dx (car_fich)
        int     21h				; faz efectivamente a leitura
		jc	    erro_ler		; se carry � porque aconteceu um erro
		cmp	    ax,0			;EOF?	verifica se j� estamos no fim do ficheiro 
		je	    fecha_ficheiro	; se EOF fecha o ficheiro 
    
		mov     ah,02h			; coloca o caracter no ecran
	  ;mov	    dl,vetor	; este � o caracter a enviar para o ecran
	 
	  int	    21h				; imprime no ecran
	  jmp	    ler_ciclo		; continua a ler o ficheiro

erro_ler:
        mov     ah,09h
        lea     dx,Erro_Ler_Msg
        int     21h

JogaCarregado:

		mov  Segundos,60
		call APAGA_ECRAN
		call ImprimeVetor
		call CICLO_CURSOR



fecha_ficheiro:					; vamos fechar o ficheiro 
        mov     ah,3eh
        mov     bx,HandleFich
        int     21h
        jnc     JogaCarregado

        mov     ah,09h			; o ficheiro pode n�o fechar correctamente
        lea     dx,Erro_Close
        Int     21h
erro_abrir:
        mov     ah,09h
        lea     dx,Erro_Open
        int     21h
        jmp     CICLOMENU

GRAVA_FICH:
		
		
		mov		ah, 3ch				; Abrir o ficheiro para escrita
		mov		cx, 00H				; Define o tipo de ficheiro ??
		lea		dx, fname			; DX aponta para o nome do ficheiro 
		int		21h					; Abre efectivamente o ficheiro (AX fica com o Handle do ficheiro)
		jnc		escreve				; Se não existir erro escreve no ficheiro
	
		mov		ah, 09h
		lea		dx, msgErrorCreate
		int		21h
	
		jmp		fim	
	


escreve:

		mov		bx, ax				; Coloca em BX o Handle
    	mov		ah, 40h				; indica que é para escrever
    	
		lea		dx, vetor			; DX aponta para a infromação a escrever
    	mov		cx, 108					; CX fica com o numero de bytes a escrever
		int		21h					; Chama a rotina de escrita
		jnc		close				; Se não existir erro na escrita fecha o ficheiro
	
		mov		ah, 09h
		lea		dx, msgErrorWrite
		int		21h	

close:
		mov		ah,3eh				; fecha o ficheiro
		int		21h
		jnc		fim
	
		mov		ah, 09h
		lea		dx, msgErrorClose
		int		21h

CONF_GRELH:

		mov editor,1
		jmp jogar

		jmp CICLOMENU

jogar:
; ------LIMPAR ECRA ----
		MOV		AX,0B800H
		MOV		ES,AX
		call APAGA_ECRAN
; ------ !LIMPAR ECRA ----
 
		
		mov iniX, 60
		mov iniY,8
		mov tamX ,9
		mov tamY,6

		mov pontuacao,0
   		mov Segundos, 60 ; iniciou o jogo
		
		goto_xy  20,20
	

; --- TABULEIRO ---
    mov cx,10       ; Faz o ciclo 10 vezes
	xor si,si 


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
		
        mov di, 1      ;delay de 1 centesimo de segundo
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
		
		
		;mov Cor2, ah ; Guarda a cor que est� na posi��o do Cursor
		;--- Retifica cor de fundo
		dec     POSx
       
       
	;      goto_xy     0,0        ; Mostra o caractr que estava na posi��o do AVATAR
	;      mov     ah, 02h         ; IMPRIME caracter da posi��o no canto
 	;      mov     dl, Car
 	;      int     21H        
       
        goto_xy    01,0        ; Mostra o caractr2 que estava na posi��o do AVATAR
        mov     ah, 02h     	; IMPRIME caracter2 da posição no canto
        mov     dl, Cor2
        int     21H 
		
	
	mov 	ax,pontuacao
	MOV 	bl, 10     
	div 	bl
	add 	al, 30h				; Caracter Correspondente �s dezenas
	add		ah,	30h				; Caracter Correspondente �s unidades
	MOV 	STR12[0],al			; 
	MOV 	STR12[1],ah
	MOV 	STR12[2],'p'		
	MOV 	STR12[3],'$'
	GOTO_XY	0,4
	MOSTRA	STR12 			
		
		


		goto_xy     60,0        ; Mostra o caractr2 que estava na posição do AVATAR
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

		cmp al,113
		je FIM
		


        

IMPRIME:    
		
		mov     ah, 02h
        mov     dl, 178 ;Coloca AVATAR1  Gon�alo Muda para 176, 177, 178 e v� qual fica melhor
        int     21H
       
        inc     POSx
        goto_xy     POSx,POSy      
        mov     ah, 02h
        mov     dl, 178 ; Coloca AVATAR2 Gon�alo Muda para 176, 177, 178 e v� qual fica melhor
        int     21H
        dec     POSx
       
        goto_xy     POSx,POSy   ; Vai para posi��o do cursor
       
        mov     al, POSx    ; Guarda a posi��o do cursor
        mov     POSxa, al
        mov     al, POSy    ; Guarda a posi��o do cursor
        mov         POSya, al



   
LER_SETA:
	
		cmp fimTempo,1

		je MENUJOGAR
		
		call	ImprimeVetor
		call        LE_TECLA


		cmp     ah, 1
        je      ESTEND
     
        
       	cmp AL,52   
		je CICLOMENU
	
 
		cmp editor,1
		je MUDACOR

		cmp AL, 32
		je OLHAEXPLOSAO

		cmp AL, 13
		je OLHAEXPLOSAO
		
        
        jmp     LER_SETA

INCREMENTA_MEIO:

		inc pontuacao
		mov explodiuMeio,0
		jmp OLHAEXPLOSAO

OLHAEXPLOSAO:
	
		cmp explodiuMeio,1
		je INCREMENTA_MEIO

		mov ax, 18

		mov cl, POSy_in
		mul cl
	
		add bx,ax

		mov ax,2
		mov cl, POSx_in
		mul cl
		add bx, ax


		jmp EXPLODE_DIR_F

MUDACOR:

		cmp editor, 0
		je CICLOMENU
		
		cmp al,52
		je CICLOMENU
		cmp al, 32

		je METECOR
		
		jmp LER_SETA

METECOR:
		
		xor bx,bx 

		mov ax, 18

		mov cl, POSy_in
		mul cl
	
		add bx,ax

		mov ax,2
		mov cl, POSx_in
		mul cl
		add bx, ax

		call    CalcAleat   ; Calcula pr�ximo aleat�rio que � colocado na pinha
        pop ax ;        ; Vai buscar 'a pilha o n�mero aleat�rio
        and al,01110000b   ; posi��o do ecran com cor de fundo aleat�rio e caracter a preto		
        cmp al, 0       ; Se o fundo de ecran � preto
		je METECOR
		
		mov vetor[bx],al
		mov vetor[bx+1],al
	
		jmp LER_SETA

EXPLODE_DIR_F:

		goto_xy     50,0        ; Mostra o caractr2 que estava na posi��o do AVATAR
	
		mov al ,vetor[bx]

		cmp vetor[bx+2],al
		jne EXPLODE_DIR_T

		cmp POSx_in,8
		je EXPLODE_DIR_T

		mov vetor[bx],0
		
		mov vetor[bx+1],0

		mov vetor[bx+2],0
		
		mov vetor[bx+3],0
		

		inc pontuacao
		mov explodiuMeio,1
		
		jmp EXPLODE_DIR_T


EXPLODE_DIR_T:


		;mov al ,vetor[bx] 

		cmp vetor[bx-15],al
		
		jne EXPLODE_DIR_B
		
		cmp POSx_in,8
		
		je EXPLODE_DIR_B

		mov vetor[bx],0
		
		mov vetor[bx+1],0

		mov vetor[bx-15],0
	
		mov vetor[bx-16],0
	
		inc pontuacao
		mov explodiuMeio,1

		jmp EXPLODE_DIR_B
		 
EXPLODE_DIR_B:

	;	mov al,vetor[bx]
		
		cmp vetor[bx+20],al
		
		jne	EXPLODE_CIM
		
		cmp POSx_in,8
		je EXPLODE_CIM

		mov vetor[bx],0
		
		mov vetor[bx+1],0

		mov vetor[bx+20],0
		
		mov vetor[bx+21],0

		inc pontuacao
		mov explodiuMeio,1

		jmp EXPLODE_CIM

EXPLODE_CIM:
		
    ;	mov al,vetor[bx]
		
		cmp vetor[bx-18],al
		
		jne	EXPLODE_BAI
		
		

		mov vetor[bx],0
		mov vetor[bx+1],0

		
		mov vetor[bx-18],0
		
		mov vetor[bx-17],0
		inc pontuacao
		mov explodiuMeio,1

		jmp EXPLODE_BAI

EXPLODE_BAI:
	;	mov al,vetor[bx]
		
		cmp vetor[bx+18],al
		
		jne EXPLODE_ESQ_T

		mov vetor[bx],0
		mov vetor[bx+1],0

		
		mov vetor[bx+18],0
		
		mov vetor[bx+19],0
		inc pontuacao
		mov explodiuMeio,1

		jmp EXPLODE_ESQ_T

EXPLODE_ESQ_T:

		;mov al,vetor[bx]
		
		cmp vetor[bx-20],al
		
		jne EXPLODE_ESQ_F

		cmp POSx_in, 0
		je EXPLODE_ESQ_F

	    mov vetor[bx],0
		mov vetor[bx+1],0

		
		mov vetor[bx-20],0
		mov vetor[bx-19],0

		inc pontuacao
		mov explodiuMeio,1


		jmp EXPLODE_ESQ_F

EXPLODE_ESQ_F:

	;	mov al,vetor[bx]
		cmp vetor[bx-2],al
		jne EXPLODE_ESQ_B
		
		cmp POSx_in, 0
		je EXPLODE_ESQ_B

	    mov vetor[bx],0
		mov vetor[bx+1],0
		

		mov vetor[bx-2],0
		mov vetor[bx-1],0

		inc pontuacao
		mov explodiuMeio,1

		jmp EXPLODE_ESQ_B

EXPLODE_ESQ_B:
		mov indiceVetor, 108
	;	mov al,vetor[bx]
	    mov nlinha,5

		cmp vetor[bx+17],al
		jne CICLOLIMPATABUL
		cmp POSx_in, 0
		je CICLOLIMPATABUL
		
		mov vetor[bx+16],0

		mov vetor[bx+17],0
		
		mov vetor[bx],0
		mov vetor[bx+1],0

		
		inc pontuacao
		mov explodiuMeio,1
		

		jmp CICLOLIMPATABUL
		

ESTEND:     
		cmp  al,48h
        jne  BAIXO
        mov ah,iniTabY
        cmp ah,POSy
        je Teste
        dec     POSy        ;cima
		dec POSy_in
        jmp     CICLO_CURSOR ;repor as cenas
 
 
BAIXO:     
        cmp     al,50h
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
      
        mov ah,iniTabX
        add ah,16 ;; posiscao x[8] -> 16 cursor ocupa dois espacos
        cmp ah,POSx
        je Teste
        inc     POSx        ;Direita
        inc     POSx        ;Direita
		inc     POSx_in        ;Direita
        jmp     CICLO_CURSOR ;repor as cenas


CICLOLIMPATABUL:
    
	cmp indiceVetor,0
	je LER_SETA

	mov cl, POSy_in
	mov count,cl

	mov bx, indiceVetor

	cmp vetor[bx-1],0
	PUSH bx
	je PUXA_COL	
	
	dec indiceVetor
	dec indiceVetor
	
	jmp CICLOLIMPATABUL


PUXA_COL:
	xor dx,dx
	cmp count,0
	je COR_CIMA


	mov dl, vetor[bx-19]
	mov dh, vetor[bx-20]
	mov vetor[bx-2],dl
	mov vetor[bx-1],dh
	
	dec count
	
	sub bx,18
	jmp PUXA_COL


COR_CIMA:

        call    CalcAleat   ; Calcula pr�ximo aleat�rio que � colocado na pinha
        pop ax ;        ; Vai buscar 'a pilha o n�mero aleat�rio
        and al, 01110000b   ; posi��o do ecran com cor de fundo aleat�rio e caracter a preto		
        cmp al, 0       ; Se o fundo de ecran � preto
        je  COR_CIMA     ; vai buscar outra cor

    
	mov vetor[bx-1], al
	mov vetor[bx-2], al
	POP bx
	
	
	jmp CICLOLIMPATABUL
	

Teste:
 
    jmp CICLO_CURSOR
 
 
FIM:

    MOV AH,4Ch
    INT 21h
PRINC ENDP
 
 
 
CODIGO  ENDS
END PRINC