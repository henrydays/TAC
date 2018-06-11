.8086
.MODEL SMALL
.STACK 2048
 
DADOS   SEGMENT PARA 'DATA'

	fichTemp db '1',0
 	flagAtualizaTop db 0 ;variavel que diz se é preciso atualizar o top ou não

	tmpPontos db 0 ;guarda os pontos realizados na ultima jogada
	tmpTempos db 0 ;guarda os  
	tmpSI db 0		;usada para guardar o valor de SI depois do ciclo trocaCar

	;~~~~~~ variaveis usadas para saber a localização atual do cursor no top 10~~~~
	posXtop db 0
	posYtop db 0
	;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

	posTOP db 1	;usado para guardar os lugares no top (1º-10º)

	
	indicePontos dw  0 ;para fazer o ciclo 10 vezes de imprimir a informação 

	indiceVetor dw 0  ;usado para guardar a posição no vetor (quando descemos as peças no tabuleiro)

	count db 0 ;usado para guardar as linhas do tabuleiro quando descemos 

	fimTempo db 0 ;flag que guarda o fim do programa 
		

	vetorTEMPOS db      0,0,0,0,0,0,0,0,0,0,0
	vetorPONTOS db  	0,0,0,0,0,0,0,0,0,0,0
	vetorNOMES  db   '                                                                                                              '


;~~~~~~~Variavel tipo flag para dizer se está no modo de edição ou de jogo ~~~~~~~~~~~~~~
	
		editor db 0
		usarEditado db 0

;~~~~~~~Variavel tipo flag para dizer se está no modo de edição ou de jogo ~~~~~~~~~~~~~~


		explodiuMeio db 0 ;flag para informar se foi explodida a peça onde se encontra o cursor

		pontuacao db 0
		pontuacao_total db 0
	
    ; --- DADOS PRINCIPAIS ---
		POSx_in db 4 ;posicao X dentro do tabul
		POSy_in db 3 ;posicao Y dentro do tabul
		vetor db 108 dup(0) 
		vetor1 db 108 dup(0)
		nlinha db 5
		aux db 0
		aux2 db 0
		plus db '+'
		minus db '-'
		bonus db 0
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
        espaco  db  ' '    
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
		db "		Digite um numero... $											 ",10,13
				

TOP10 db" ",10,13  
		db "								    ",10,13 
		db "		         ______   ___  ____  	 _   ___   ",10,13  
		db " 			|_   _|  / _ \ | _ \   / (_ /   \ ",10,13  
		db "   			  | |   | (_) ||  _/   | | | () |   ",10,13  
		db "   			  |_|    \___/ |_|     |_|  \__/ ",10,13    
		db "													   ",10,13	
		db " 	POSICAO        PONTOS        TEMPO(seg)              NOME         ",10,13
		db "$",10,13			                                		


	Jogo db " ",10,13

 	db "  			",10,13
	db "     TEMPO RESTANTE:					         ",10,13
	db "  ",10,13
	db "     PONTUACAO:									      				 ",10,13
	db "			    		 												 ",10,13
	db "			   		  						   						  	 ",10,13
	
	db "																	     ",10,13
	db "																	     ",10,13
	db "		 													   			 ",10,13
	db "		 													   			 ",10,13
	db "																	     ",10,13
	db "________________________________________________________________________________ ",10,13
	db "		A explosao das pecas com simbolos duplica os pontos			     ",10,13

	db "$",10,13
	
	
	layoutEditor db " ",10,13

 
	db "  ",10,13
	db "    ESC para guardar e sair								      				 ",10,13
	db "    4 para sair sem guardar		    		 					 	 ",10,13
		db "  						",10,13
	db "   					         ",10,13
	db "			   		  						   						  	 ",10,13
	
	db "																	     ",10,13
	db "																	     ",10,13
	db "		 													   			 ",10,13
	db "		 													   			 ",10,13
	db "																	     ",10,13
	db "________________________________________________________________________________ ",10,13
	db "		        ENTER ou SPACE para alterar as cores      			   ",10,13

	db "$",10,13
	
	
	MFim db " ",10,13
	db "																	     ",10,13
	db "		______ ________  ___  _____ ________  ________ _____ ",10,13
	db "		|  ___|_   _|  \/  | |_   _|  ___|  \/  | ___ \  _  |",10,13
	db "		| |_    | | | .  . |   | | | |__ | .  . | |_/ / | | |",10,13
	db "		|  _|   | | | |\/| |   | | |  __|| |\/| |  __/| | | |",10,13
	db "		| |    _| |_| |  | |   | | | |___| |  | | |   \ \_/ /",10,13
	db "		\_|    \___/\_|  |_/   \_/ \____/\_|  |_|_|    \___/ ",10,13
 	db "																	     ",10,13                                                                                
	db "			PONTUACAO:													 ",10,13
	db "																		 ",10,13
	db "  			Introduza o seu nome:			     					     ",10,13
	db "																	     ",10,13
	db "																	     ",10,13
	db "$",10,13
																		   

				db      " ",10, 13,10, 13,10, 13,10, 13		


	pagOpenFile db " ",10,13

 	db "  																				 ",10,13
	db "     		          CARREGAR TABULEIRO EXISTENTE			  	    		 ",10,13
	db "  																	   			 ",10,13
	db "     			   Introduza o nome do ficheiro	 				   		 ",10,13
	db "			    		 												 		 ",10,13
	db "			   	formato: 'nome.txt'				   	    			 ",10,13
	
	db "________________________________________________________________________________ ",10,13
	db "			Input limitada a 15 caracteres						       			 ",10,13
	db "________________________________________________________________________________ ",10,13
	db "																	    		 ",10,13
	db "					                ENTER para continuar		    		  	 ",10,13
	db "							ESC   para sair								 	 ",10,13
	db "$",10,13	
  	; --- !VARIAVEIS DE MSG DO MENU ---	

	; ---- VARIAVEIS MOSTRA VETOR ---
		tamX_v db 9 ; Largura do tabuleiro
        tamY_v db 6 ; Altura do tabuleiro
		linhaVetor db 0
		colunaVetor db 0
	; --- !VARIAVEIS MOSTRA VETOR ---
	
	;------TRATA_HORAS_JOGO E DATA_JOGO ---
	STR12	 		DB 		"            "	; String para 12 digitos
	contaSeg 		dw 		0				;contador que regista a varia��o dos segundos/tempo
	Segundos		dw		?			; Vai guardar os segundos actuais
	Old_seg			dw		0				; Guarda os �ltimos segundos que foram lidos
	;------TRATA_HORAS_JOGO E DATA_JOGO ---
	
	
		
	;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~FICHEIROS~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

			fname	db	'pergunta.txt',0
			fhandle dw	0
			HandleFich      dw      0
        	car_fich        db      ?

			;~~~~~~~~~~~~~~~~~~~~ MENSAGENS DE ERRO FICHEIROS ~~~~~~~~~~~~~~~~~~~~~
			msgErrorCreate	db	    "Ocorreu um erro na criacao do ficheiro!$"
			msgErrorWrite	db	    "Ocorreu um erro na escrita para ficheiro!$"
			msgErrorClose	db	    "Ocorreu um erro no fecho do ficheiro!$"	
        	Erro_Open       db      'Erro ao tentar abrir o ficheiro$'
        	Erro_Ler_Msg    db      'Erro ao tentar ler do ficheiro$'
       	 	Erro_Close      db      'Erro ao tentar fechar o ficheiro$'
       		;~~~~~~~~~~~~~~~~~~~ FIM MENSAGENS DE ERRO FICHEIROS ~~~~~~~~~~~~~~~~~
		    
			;~~~~~~~~~~~~~~~~~~~ NOMES DOS FICHEIROS EM MEMÓRIA ~~~~~~~~~~~~~~~~~~
			
			Fich         	db      'pergunta.TXT'  ,0
			fPontos      	db 		'pontos.txt'    ,0
			fNomes			db      'nomes.txt'     ,0
			fTempo			db      'tempos.txt'    ,0
			fTabuleiro      db      'tabuleiro.txt' ,0
        	
			;~~~~~~~~~~~~~~~~~~~ NOMES DOS FICHEIROS EM MEMÓRIA ~~~~~~~~~~~~~~~~~~


	;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~FICHEIROS~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

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

mostra_pont MACRO  pont
	
	mov ax,0
	mov 	al,pontuacao
	MOV 	bl, 10     
	div 	bl
	add 	al, 30h				; Caracter Correspondente �s dezenas
	add		ah,	30h				; Caracter Correspondente �s unidades
	MOV 	STR12[0],al			; 
	MOV 	STR12[1],ah
	MOV 	STR12[2],0	
	MOV 	STR12[3],'$'
	
	GOTO_XY	22,4 ; posiçao ond evai ser imprimida a pontuação

	MOSTRA	STR12 			
		
ENDM	

PRINT_NUMERO MACRO Num
	
	xor ax,ax
	mov 	al,num
	MOV 	cl, 10     
	div 	cl
	add 	al, 30h				; Caracter Correspondente �s dezenas
	add		ah,	30h				; Caracter Correspondente �s unidades
	MOV 	STR12[0],al			; 
	MOV 	STR12[1],ah	
	MOV Str12[2],0
	MOV 	STR12[3],'$'
	MOSTRA	STR12 			
	
ENDM

PRINT_CAR MACRO car
	
	mov ah,02H
	mov dl,car
	int 21H

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


MensagemFim:

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
	GOTO_XY	22,2
	
	cmp editor,1

	je salto3
	
	MOSTRA	STR12 

	salto3:
	
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

READ_INPUT PROC

mov bx,-1
		LER_NOME_FILE:  ;este ciclo insere caracter a caracter no fim do vetorNomes
				
			xor ax, ax ;limpa ax apara evitar erros
				
			mov ah, 07h ; Ler input do utilizador
			int 21h		;

			cmp al, 27  ;se introduzir
			je sai1

			cmp al,13	;verifica se a tecla é enter 
			je sai1		;se for Enter , significa que o nome foi introduzido enter, logo acaba o ciclo
			
			cmp al, 8	 ;verifica se a tecla é backspace
			je backspace1 ;salta para bloco de código 'backspace'
				
			;caso nao seja introduzida nenhuma das anteriores, continua a execução do código
			
			mov fichTemp[bx+1], al ;mete o valor introduzido na posição atual do vetorNomes
			mov dl, fichTemp[bx+1] ;mete o valor no vetor em dl

			mov ah, 02h ;imprime o caracter em ah no ecra para o utilizador saber o que escreveu
			int 21h

			inc bx ;  incrementa o bx para passar à proxima posição do array
			dec cx ;  decrementa o cx por causa do ciclo

			jmp pula1	;pula, para evitar a execução do bloco de código 'backspace'

			backspace1:	;este código executa se o utilizador carregar em backspace
				
				 
				mov dl, 8	 ;imprime o backspace no ecra para voltar atrás no ecra(criar o efeito visual)
				mov ah, 02h
				
				int 21h

				mov fichTemp[bx],0 ; volta à posição anterior do array e apaga o código ascii do backspace que lá foi colocado
			
				dec bx ;decrementa o bx para voltar atrás (como se nao tivesse sido introduzido o 'backspace')
				
			pula1: ;vem para aqui caso nao tenha sido executado o bloco de código 'backspace'
				
			cmp cx, 0 ; compara se já foram lidos 10 caracteres do teclado
				
			jne LER_NOME_FILE ;caso nao tenham sido, volta ao ciclo 'LER_INPUT'
			
			sai1:
			ret
			

READ_INPUT ENDP
;~~~~~~~~~~~~~~~~~ Procedimento para atualizar a mem de video com o vetor das cores ~~~~~~~~~~~
atualizaTabuleiro proc
	
	;~~~~~  mete tudo a 0 para evitar erros~~~~~ 
	xor bx, bx
	xor ax,ax
	xor si,si
	xor di,di
	xor cx,cx
	;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

	mov linhaVetor , 0 ;mete as variaveis a 0
	mov colunaVetor,0 ;mete as variaveis a 0
	

	mov bx, 160*8 ;multiplica nr de caracteres por linha com o numero de linhas 
	add bx, 60	  ;adiciona o 30*2 (30 col * 2(cada col ocupa 2 bytes)) 

	jmp mostrar  ;
	
	linha:

		mov colunaVetor,0
		inc linhaVetor
		
		add bx, 160 ;adiciona 160bytes(andar uma linha na memória de video para baixo)
		sub bx, 36	;subtrai (18*2 da linha anterior)
		
	mostrar:
		
	
		cmp colunaVetor,18   ;verifica se cheguou ao fim da linha
		
		je linha		     ;cria nova linha
				
		mov cl, vetor[si]    ;mete a cor atual em cl

        mov dh, espaco       ;mete um espaço em dh
        
		mov es:[bx], dh      ;mete o espaço em dh, na memória de video
 
        mov es:[bx+1], cl    ;mete a cor, na posição da memória de video
       
	    inc bx     			 ;incrementa o valor de bx em 2 (bx usado como indice da memória de video)
        inc bx 
		
		inc si		;incrementa SI(usado para andar no vetor das cores em memória)

		inc colunaVetor  ;incrementa a variavel com a informação da col atual
		
		cmp si, 108 ;comparar para ver se chego ao fim do tabuleiro

		jne mostrar	;se nao for continua a fazer o ciclo
		


		mov colunaVetor,0 ;mete os valores a 0 para estar pronto para próxima execução do procedimento
		mov linhaVetor,0


		cmp editor,1; se o modo de edição estiver ativo
		je sai		;nao coloca o bonus

		;~~~~~~~~~~Bonus duplicação ~~~~~~~~~~
		mov al, plus
		mov ah, minus

	    mov bx, 1360
        mov es:[bx], al  ;primeiro mais
		mov es:[bx+172], al  ;segundo
		mov es:[bx+310], ah  
		mov es:[bx+642], al  
		mov es:[bx+790], ah

		;~~~~~~~~~~Bonus duplicação ~~~~~~~~~~
		
	SAI:  RET


atualizaTabuleiro endp  

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



PRINC PROC

    MOV AX, DADOS
    MOV DS, AX
	MOV		AX,0B800H
	MOV		ES,AX

	call open_fich_nomes		;abre para memória o ficheiro dos nomes
	call open_fich_pontos		;abre para memória o ficheiro dos pontos
	call open_fich_tempos		;memória o ficheiro dos tempos

	;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Ciclo principal - Inicio do Jogo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	
	MENU_PRINCIPAL:
	
		mov editor,0;mete o editor a 0

		goto_xy 0,0 ;vai para o inicio do ecrã
			
		call APAGA_ECRAN ;limpa o ecrã

		lea     dx, Menu ;imprime a string no ecrã
		mov     ah, 09h
		int     21h
		

        mov  ah, 07h ; Espera que o utilizador introduza um caracter 
        int  21h
            
		cmp  al, 49  ; se introduzir o numero 1
        
			je MENU_JOGAR ;salta para o menu jogar
			
		
		cmp al ,50 ; se introduzir o numero 2
			
			je TOP_10 ;salta para o top 10

		
		cmp al,51 ;se introduzir o numero 3
			
			je CONF_GRELH ;salta para a configuração da grelha
            
		
		cmp al,52 ;se introduzir o numero 4
            
			je fim ;salta para o fim, terminando o programa

				
		jmp MENU_PRINCIPAL ;caso nenhuma das situações anteriores se verifique, volta a executar o ciclo


		
		MENU_JOGAR: ;responsável pela escolha do modo de jogo 

			mov fimTempo,0 ;mete a flag de fim de tempo a 0, porque vai iniciar um novo jogo
		
			call APAGA_ECRAN ;apaga o ecrã

			lea     dx, MJogar	; apresenta no ecrã a string do menu jogar
			mov     ah, 09h		;
			int     21h			;
				
			mov  ah, 07h ; Esperar que o utilizador digite um numero
            int  21h
            	
			mov editor,0	;mete a flag que indica se está no modo de edição do tabuleiro a 0

			cmp  al, 49   ; Se inserir 1
                je Jogar  ; salta para o jogo

			cmp  al, 50 ; Se inserir 2
                je SELECT_FILE  ;salta para a seleção do tabuleiro 	
			

            cmp al,52
                je MENU_PRINCIPAL
			
			jmp MENU_JOGAR ;repete o ciclo, caso não ocorra nenhuma das opções anteriores
			
		FORA: 
			CMP AL, 27 ; TECLA ESCAPE
			JE fim;
		
	JMP MENU_PRINCIPAL

SELECT_FILE: ;ecra para selecionar o ficheiro que queremos abrir 
		
		call APAGA_ECRAN
			lea     dx, pagOpenFile	; apresenta no ecrã a string do menu jogar
			mov     ah, 09h		;
			int     21h			;
		
		mov cx,15

		goto_xy 26,21
		PRINT_CAR 175
		goto_xy 27,21	

		call READ_INPUT
		
		mov editor,0
		
		mov segundos,50
			
		mov fimTempo,0

		jmp OPEN_FILE


jmp SELECT_FILE

OPEN_FILE:
        mov     ah,3dh			; vamos abrir ficheiro para leitura 
        mov     al,0			; tipo de ficheiro	
        lea     dx,fichTemp			; nome do ficheiro
        int     21h			    ; abre para leitura 
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
		call atualizaTabuleiro
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
		
		call APAGA_ECRAN
        mov     ah,09h
        lea     dx,Erro_Open
        int     21h
        
		mov ah, 07h
		int 21H
		jmp SELECT_FILE

EDITOR_TABUL:

		
		call APAGA_ECRAN
			lea     dx, pagOpenFile	; apresenta no ecrã a string do menu jogar
			mov     ah, 09h		;
			int     21h			;
		
		mov cx,15

		goto_xy 26,21
		PRINT_CAR 175
		goto_xy 27,21	

		call READ_INPUT
		
		mov editor,0
		
		mov segundos,50
			
		mov fimTempo,0

		jmp OPEN_EXIST_FILE


jmp EDITOR_TABUL

OPEN_EXIST_FILE:
        mov     ah,3dh			; vamos abrir ficheiro para leitura 
        mov     al,0			; tipo de ficheiro	
        lea     dx,fichTemp			; nome do ficheiro
        int     21h			    ; abre para leitura 
        jc      erro_abrir		; pode aconter erro a abrir o ficheiro 
        mov     HandleFich,ax		; ax devolve o Handle para o ficheiro 
        jmp     ler_ciclo_1		; depois de abero vamos ler o ficheiro 

ler_ciclo_1:
        mov     ah,3fh			; indica que vai ser lido um ficheiro 
        mov     bx,HandleFich		; bx deve conter o Handle do ficheiro previamente aberto 
        mov     cx,108			; numero de bytes a ler 
        lea     dx,vetor		; vai ler para o local de memoria apontado por dx (car_fich)
        int     21h				; faz efectivamente a leitura
		jc	    erro_ler_1		; se carry � porque aconteceu um erro
		cmp	    ax,0			;EOF?	verifica se j� estamos no fim do ficheiro 
		je	    fecha_ficheiro_1	; se EOF fecha o ficheiro 
    
		mov     ah,02h			; coloca o caracter no ecran
	  ;mov	    dl,vetor	; este � o caracter a enviar para o ecran
	 
	  int	    21h				; imprime no ecran
	  jmp	    CONF_GRELH		; continua a ler o ficheiro

erro_ler_1:
        mov     ah,09h
		
        lea     dx,Erro_Ler_Msg
        int     21h
		jmp CONF_GRELH


fecha_ficheiro_1:					; vamos fechar o ficheiro 
        mov     ah,3eh
        mov     bx,HandleFich
        int     21h
        jnc     Jogar

        mov     ah,09h			; o ficheiro pode n�o fechar correctamente
        lea     dx,Erro_Close
        Int     21h
	
erro_abrir_1:
		
		call APAGA_ECRAN
        mov     ah,09h
        lea     dx,Erro_Open
        int     21h
        
		mov ah, 07h
		int 21H
		jmp UPDATE_FILE

UPDATE_FILE:
		
		
		mov		ah, 3ch				; Abrir o ficheiro para escrita
		mov		cx, 00H				; Define o tipo de ficheiro ??
		lea		dx, fichTemp			; DX aponta para o nome do ficheiro 
		int		21h					; Abre efectivamente o ficheiro (AX fica com o Handle do ficheiro)
		jnc		escreve				; Se não existir erro escreve no ficheiro
		mov		ah, 09h
		lea		dx, msgErrorCreate
		int		21h
		jmp MENU_JOGAR
			
escreve:

		mov		bx, ax				; Coloca em BX o Handle
    	mov		ah, 40h				; indica que é para escrever
    	
		lea		dx, vetor			; DX aponta para a informação a escrever
    	mov		cx, 108					; CX fica com o numero de bytes a escrever
		int		21h					; Chama a rotina de escrita
		
		jnc		MENU_PRINCIPAL				; Se não existir erro na escrita fecha o ficheiro
	
		mov		ah, 09h
		lea		dx, msgErrorWrite
		int		21h	
		mov ah, 07h
		int 21H
		jmp SELECT_FILE

close:
		mov		ah,3eh				; fecha o ficheiro
		int		21h
		jnc		fim
	
		mov		ah, 09h
		lea		dx, msgErrorClose
		int		21h

CONF_GRELH:

		
		mov editor,1

		jmp EDITOR_TABUL

		jmp jogar

		jmp MENU_PRINCIPAL

jogar:


		MOV		AX,0B800H
		MOV		ES,AX
		
		
		call APAGA_ECRAN
		
		
		cmp editor,1
		
		jne salto5

			lea     dx, layoutEditor
			mov     ah, 09h
			int     21h
			mov segundos,60
			jmp salto2

		salto5:
		;caso nao esteja ativo o modo de edição
 		lea     dx, jogo
		mov     ah, 09h
		int     21h
		mov pontuacao,0
   		mov Segundos, 60 ; iniciou o jogo
		
		salto2:

		mov iniX, 60
		mov iniY,8
		mov tamX ,9
		mov tamY,6

		goto_xy  20,20
	
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
        mov     dh, espaco  ; vai imprimir o caracter "SAPCE"
        mov es:[bx],dh  ;
   
novacor:   
       
        call    CalcAleat   ; Calcula pr�ximo aleat�rio que � colocado na pinha
        pop ax ;        ; Vai buscar 'a pilha o n�mero aleat�rio
        and al,01110000b   ; posi��o do ecran com cor de fundo aleat�rio e caracter a preto		
        cmp al, 0       ; Se o fundo de ecran � preto
        je  novacor     ; vai buscar outra cor
 
        mov     dh,    espaco   ; Repete mais uma vez porque cada pe�a do tabuleiro ocupa dois carecteres de ecran
        mov es:[bx],   dh      
        mov es:[bx+1], al   ; Coloca as caracter�sticas de cor da posi��o atual
        inc bx     
        inc bx      ; pr�xima posi��o e ecran dois bytes � frente
		
        mov     dh,    espaco   ; Repete mais uma vez porque cada pe�a do tabuleiro ocupa dois carecteres de ecran
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
		
		cmp editor ,1
		je salto4
		mostra_pont pontuacao
		salto4:

		;goto_xy     60,0        ; Mostra o caractr2 que estava na posição do AVATAR
		;mov al, 48
		;add al, POSx_in
        ;mov     ah, 02h     ; IMPRIME caracter2 da posi��o no canto
        ;mov     dl, al   
        ;int     21H 
		
		;goto_xy     61,0        ; Mostra o caractr2 que estava na posi��o do AVATAR
		;mov al, 48
		;add al, POSy_in
       ; mov     ah, 02h     ; IMPRIME caracter2 da posi��o no canto
       ; mov     dl, al   
       ; int     21H 
    
        goto_xy     POSx,POSy   ;Vai para posi��o do cursor

		cmp al,113
		je FIM
		        

IMPRIME:    
		
		mov     ah, 02h
        mov     dl, 178 
        int     21H
       
        inc     POSx
        goto_xy     POSx,POSy      
        mov     ah, 02h
        mov     dl, 178 
        int     21H
        dec     POSx
       
        goto_xy     POSx,POSy   ; Vai para posi��o do cursor
       
        mov     al, POSx    ; Guarda a posi��o do cursor
        mov     POSxa, al
        mov     al, POSy    ; Guarda a posição do cursor
        mov     POSya, al



   
LER_SETA: ;ciclo que está sempre a executar e le a input do utilizador

		cmp fimTempo,1 ;verifica se o tempo já chegou ao fim 
		
		je GAMEOVER    ;se o tempo acabou, salta para O GAMEOVER
		
		call  atualizaTabuleiro ; atualiza o ecrã com o vetor de cores em memória 

		call        LE_TECLA


		cmp     ah, 1
        je      ESTEND
     
        
       	cmp AL,52   
		je MENU_PRINCIPAL
	
 
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

		cmp editor, 0      ;verifica se a flag do editor está a 0
		je MENU_PRINCIPAL  ;caso seja verdade, o editor acabou e volta para o meno principal
		
		cmp al,52
		je MENU_PRINCIPAL	;volta para o menu principal
		
		cmp al, 32			;caso pressione espaço
		je METECOR

		cmp al,13			;caso pressione enter
		je METECOR

		cmp al,27			;caso pressione ESC
		je UPDATE_FILE

		
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
        mov bonus, 0
		mov al, vetor[bx]

		cmp vetor[bx+2],al
		jne EXPLODE_DIR_T

		cmp POSx_in,8
		je EXPLODE_DIR_T

		mov vetor[bx],0
		mov vetor[bx+1],0

		mov vetor[bx+2],0
		mov vetor[bx+3],0
		inc bonus
		inc pontuacao
		mov explodiuMeio,1

		;mov dl, vetor[bx]
		;cmp vetor[si+10], dl
		;mov dl, vetor[si+34]
		;mov dl, vetor[si+82]
		;mov dl, vetor[si+40]
		;mov dl, vetor[si+94]
		jmp EXPLODE_DIR_T


EXPLODE_DIR_T:

		cmp vetor[bx-15],al
		jne EXPLODE_DIR_B
		
		cmp POSx_in,8
		je EXPLODE_DIR_B

		mov vetor[bx],0
		mov vetor[bx+1],0

		mov vetor[bx-15],0
		mov vetor[bx-16],0
		inc bonus
		inc pontuacao
		mov explodiuMeio,1

		jmp EXPLODE_DIR_B
		 
EXPLODE_DIR_B:
    
		cmp vetor[bx+20],al
		jne	EXPLODE_CIM
		
		cmp POSx_in,8
		je EXPLODE_CIM

		mov vetor[bx],0
		mov vetor[bx+1],0

		mov vetor[bx+20],0
		mov vetor[bx+21],0
		inc bonus
		inc pontuacao
		mov explodiuMeio,1

		jmp EXPLODE_CIM

EXPLODE_CIM:
	
		cmp vetor[bx-18],al
		jne	EXPLODE_BAI

		mov vetor[bx],0
		mov vetor[bx+1],0

		mov vetor[bx-18],0
		mov vetor[bx-17],0
		inc bonus
		inc pontuacao
		mov explodiuMeio,1
        
	
		jmp EXPLODE_BAI

EXPLODE_BAI:

		cmp vetor[bx+18],al
		jne EXPLODE_ESQ_T

		mov vetor[bx],0
		mov vetor[bx+1],0
		
		mov vetor[bx+18],0
		mov vetor[bx+19],0
		inc bonus
		inc pontuacao
		mov explodiuMeio,1

      
		jmp EXPLODE_ESQ_T

EXPLODE_ESQ_T:
       
		cmp vetor[bx-20],al
		jne EXPLODE_ESQ_F

		cmp POSx_in, 0
		je EXPLODE_ESQ_F

	    mov vetor[bx],0
		mov vetor[bx+1],0
		mov vetor[bx-20],0
		mov vetor[bx-19],0
		inc bonus
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
		inc bonus
		inc pontuacao
		mov explodiuMeio,1

		
		jmp EXPLODE_ESQ_B

EXPLODE_ESQ_B:
       
		mov indiceVetor, 108
	
	    mov nlinha,5
        
        

		cmp vetor[bx+17],al
		jne VERIFICABONUS
		cmp POSx_in, 0
		je VERIFICABONUS

		mov vetor[bx+16],0
		mov vetor[bx+17],0
		
		mov vetor[bx],0
		mov vetor[bx+1],0
		inc bonus
		inc pontuacao
		mov explodiuMeio,1 

		jmp VERIFICABONUS

VERIFICABONUS:
         
		  mov ax, 0b800h  ; Segmento de mem�ria de v�deo onde vai ser desenhado o tabuleiro
          mov es, ax

		  xor si,si
          xor dx,dx
		  xor cx,cx
		  xor ax,ax
          cmp bonus, 0
		  je CICLOLIMPATABUL

		  mov al, 160
		  mul POSy
		  mov si, ax
          mov ax,2
		  mul POSx

		  add si, ax
          
		  mov cl, 45
		  mov ch, 43
		  
		  cmp es:[si], cl
		  je explodeNeg
		  cmp es:[si], ch
          je explodePos
		  cmp es:[si+2], cl
		  je explodeNeg
		  cmp es:[si+2], ch
          je explodePos
		  cmp es:[si-2], cl
		  je explodeNeg
		  cmp es:[si-2], ch
          je explodePos
		  cmp es:[si-158], cl
		  je explodeNeg
		  cmp es:[si-158], ch
          je explodePos
		  cmp es:[si+158], cl
		  je explodeNeg
		  cmp es:[si+158], ch
          je explodePos
		  cmp es:[si-160], cl
		  je explodeNeg
		  cmp es:[si-160], ch
          je explodePos
		  cmp es:[si+160], cl
		  je explodeNeg
		  cmp es:[si+160], ch
          je explodePos
		  cmp es:[si+162], cl
		  je explodeNeg
		  cmp es:[si+162], ch
          je explodePos
		  cmp es:[si-162], cl
		  je explodeNeg
		  cmp es:[si-162], ch
          je explodePos
		  jmp CICLOLIMPATABUL
		  
explodeNeg:
		 dec pontuacao
		 dec pontuacao
		 dec pontuacao
		 dec pontuacao
		 jmp CICLOLIMPATABUL

explodePos:
         mov dh,0
         mov dl, bonus
		 add pontuacao,dl
		 add pontuacao,1
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


;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ TOP 10 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

	;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	Página do top10 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	TOP_10:	
			
		call APAGA_ECRAN ;chama o procedimento para apagar o ecra
			
		goto_xy 0,0	;vai para o inicio do ecrã
		
		lea     dx, TOP10 ;load efective adress da string do top10
		mov     ah, 09h
		int     21h

		;~~~~Cordenadas iniciais onde vai começar a ser escrita e informação 	
		mov posXtop,10	
		mov posYtop,10
		;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		
		xor bx,bx ;mete o bx a 0 para reduzir os erros

		mov indicePontos,0  ;enquanto este indice for != 10 , o ciclo de imprimir linha continua

		jmp PrintJogadores	;imprime as informações dos 10 melhores jogadores 
	                                   
	;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~		
	

	;~~~~~~~~~~~~~~~~~~~~ Imprime as informações dos 10 melhores jogadores ~~~~~~~~~~~~~~~~~~
	PrintJogadores:
	
		mov cx,10;numero de vezes que o ciclo é executado

		xor bx,bx ;mete o bx a 0 para evitar erros
		xor dx,dx ;mete o dx a 0 para evitar erros 
		
		mov si,0 ;o si é usado para saber qual a posição dentro dos arrays com tamanho 10
	
	
		mov bx,10 ; bx colocado a 10 para aceder ao vetor[10], ou seja ao novo valor adicionado no fim
		xor ax,ax ;mete o ax a 0 para evitar erros

		mov dl ,vetorPONTOS[bx] ;coloca os pontos realizados na ultima jogada em dl
		mov tmpPontos,dl ;coloca os pontos da ultima jogada na variavel 'tmpPontos'

		mov al,vetorTEMPOS[bx] ;coloca o tempo da ultima jogada na variavel 'tmpTempos'
		mov tmpTempos,al ;coloca o tempo da ultima jogada na variável 'tmpTempos'
	
		cmp flagAtualizaTop,1 ;variavel que identica se é necessário atualizar o top

		jne salto ;se 'flagAtualizaTop' for igual a 1, continua a execução do código, senão salta 
		
	;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

	;~~~~~~~~~~~~~~~  Atualiza os vetores em memória, ordenando por pontuação ~~~~~~~~~~~~~~~~
	atualizaTOP: 
		
		inc si ;incrementa si, ou seja, aumenta a posição dentro dos arrays

		mov dl, tmpPontos ;copia para dl, a ultima pontuação feita pelo jogador
		mov al, tmpTempos ;copia para al, o ultimo tempo feito pelo jogador

		cmp vetorPONTOS[si-1],dl ;compara os pontos com os do ultimo jogador 
		
		ja atualizaTOP ;caso o vetorPONTOS[si-1] seja maior, ignora e volta a executar o ciclo 
	
		mov dh, vetorPONTOS[si-1] ;copia os pontos atuais para dh
		mov ah,vetorTEMPOS[si-1]  ;copia o tempo atual para ah	
		mov vetorPONTOS[si-1],dl  ;copia para a posição atual, os pontos na ultima posição do array
		mov vetorTEMPOS[si-1],al  ;copia para a posição atual, o tempo na ultima posição do arry	
		mov tmpPontos,dh		  ;copia para a variavel 'tmpPontos' os pontos anteriores existentes no array
		mov tmpTempos,ah		  ;copia para a variavel 'tmptempos' o tempo existente no vetor antes de ser alterado

		push cx   ; mete o cx na pilha, visto que vamos alterar o valor de cx com o uso do loop
		
		mov cx,10 ; mete o valor 10 no cx, para executar o loop 10 vezes
			
		mov ax,si ; copiar si para ax para copiar o valor de si para a variável tmpSI

		mov tmpSI,al ;copia efectivamente o valor de si para tmpSI
					 ;esta variavel vai ser usada para recuperar o valor de si no final do ciclo 'trocaCar'

		dec si	  ;decrementa Si uma vez que ele possui mais um do que a posição atual no vetor 
			   
		mov ax,10 ;mete 10 no ax para fazer a multiplicação
		
		mul si	  ;mutiplica o Si(posição no array) por 10(existente em ax)
		
		mov si,ax ;passa o resultado da multiplicação para SI
		
		mov bx,100;mete 100 em bx (para aceder ao ultimo nome no vetorNOMES), cada pessoa ocupa 10bytes 
		
		inc bx

		trocaCar: ;ciclo responsável por trocar o nome do indice atual com o nome na ultima posição do vetorNomes

			mov dl, vetorNOMES[bx]  ;mete em dl o caracter vetorNOMES[bx] (caracter bx-100 do nome)
				
			mov dh , vetorNOMES[si] ;mete em dh o caracter do nome atual 

			mov vetorNOMES[bx],dh   ;mete na ultima posição do vetorNOMES o caracter em dh(do nome a trocar)

			mov vetorNOMES[si],dl	;mete no nome atual o caracter existente no fim do vetorNOMES

			inc bx	;incrementa o bx ,para passar ao caracter seguinte (aceder ao ultimo nome)
				
			inc si	;incrementa o si, para passar ao caracter seguinte (no nome atual)
				
			loop trocaCar ; continua o loop enquanto o cx for maior que 0
				
		pop cx  ;recupera da pilha o valor de cx (foi alterado para fazer o ciclo 'trocaCar' )
		
		mov al,tmpSI ;copia para al o valor de SI guardado 
		
		mov si, ax   ;recupera o valor de SI que foi alterado dentro do ciclo trocaCar

		loop atualizaTOP  ;repete o cilco enquanto cx for maior que 0

	;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

	salto: ;a execução do programa vem para aqui, caso o top n seja atualizado
	
	mov cx,10  ;copia 10 para cx, para fazer o loop 10 vezes

	mov bx,100 ;copia 100 para o bx (para aceder ao ultimo nome no vetorNOMES)
	
	limpaSTRING: ; ciclo para limpar o ultimo nome no vetor(garantir que não aparecem caracteres estranhos)

		mov vetorNOMES[bx],0 ;mete a posição do vetor a 0

		inc bx	;incrementa o bx para andar para a frente no vetor 

		loop limpaSTRING ;executa o cilco enquanto cx > 0

	mov bx,10 ;copia 10 para bx (para aceder aos ultimos valores nos vetores de pontos e de tempo)

	mov vetorPONTOS[bx],0 ;coloca a 0 o ultimo valor no vetor dos pontos
	mov vetorTEMPOS[bx],0 ;coloca a 0 o ultimo valor no vetor dos tempos

	mov posTOP,1 ;variavel usada para imprimir a POsição que vai aparecer do lado esquerdo (1...10)

	xor bx,bx ;mete bx a 0 para evitar erros

	xor si,si ;mete si a 0 para evitar erros
	
	cmp indicePontos,10 ;verifica se já foram imprimidos 10 valores de resultados

	jne PRINT_LINHA	 ;caso o 'indicePontos' seja diferente de 10, vai para o ciclo 'Imprime_Linha'


	mov  ah, 07h ; Esperar que o utilizador insira um caracter
    
	int  21h
			
	cmp  al, 52 ; caso a input do utilizador seja 4 
        je MENU_PRINCIPAL ;salta para o menu principal

	
	;~~~~~~~~~~~~~~~~~~~~~~~~~~  Imprime Linha com os registos de cada jogador ~~~~~~~~~~~~~~~
	PRINT_LINHA:
	
		goto_xy posXtop,posYtop ;vai para a posição de inicio, definida anterior 

		cmp indicePontos, 10  ;verifica se o ciclo já ocorreu 10 vezes
	
		je PrintJogadores	  ;caso seja verdade, volta para o ciclo anterior 
	
		GOTO_XY	10,posYtop    ;vai para a coluna 10 para imprimir a posição no ranking

		mov cl ,posTOP 		  ;mete em cl a posição do ranking (vai de 1º a 10º)
		
		PRINT_NUMERO cl		  ;usa a macro 'PRINT_NUMERO' para imprimir na posição do cursor o valor em cl
	
		mov posXtop, 25       ;mete o valor 25 na posição xtop

		GOTO_XY	posXtop,posYtop ;vai para a posição de coluna 25 para imprimir os pontos
	
		PRINT_NUMERO vetorPONTOS[bx] ;imprime os pontos em vetorPONTOS[bx] na posição do cursor
	
		mov posXtop, 40	 ;mete o valor 40 na posição xtop

		GOTO_XY posXtop,posYtop  ;vai para a coluna 40 para imprimir o tempo
	
		PRINT_NUMERO vetorTEMPOS[bx] ;imprime o valor atual do tempo na posição do cursor
	
		mov posXtop, 58  ;mete o valor 58 na posição xtop

		GOTO_XY posXtop,posYtop ;vai para a coluna 58 para imprimir o nome atual
	
		mov cx,10 ;mete o valor 10 em cx para usar no ciclo
		
		mov si,0 ;mete o SI a 0 para apagar os valores usados anteriormente

		mov ax,indicePontos ;mete o valor de 'indicePontos' para fazer a multiplicação
	
		mul cx	;multiplica 'indicePontos' por 10 para obter o a posição onde começa o nome atual em 'vetorNomes'

		mov si, ax ;copia o resultado da multiplicação para si 
	
		PRINT_NOME: ;ciclo que imprime 10 caracteres do nome
		
			PRINT_CAR vetorNOMES[si]; imprime caracter na posição vetorNOMES[si]
		
			inc si; incrementar si para andar para a frente no array
		

		loop PRINT_NOME; ocorre enquanto cx >0


	inc posYtop ;incrementa posYtop , para passar para a linha seguinte
	inc posTOP ;incrementa posTOP para passar para o proximo lugar do top
	
	inc bx	;incrementa o bx para passar ao proximo jogador

	inc indicePontos ;incrementa o 'indicePontos' para informar que já imprimiu mais uma linha, ciclo para quando =10
	
	mov  flagAtualizaTop,0 ;mete a flag a 0 para dizer que não é preciso atualizar o top

	jmp PRINT_LINHA ;repete o ciclo 

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ TOP 10 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	
	Teste:
 
    jmp CICLO_CURSOR
 

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ GAME OVER ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	
	GAMEOVER: ;execução salta para aqui quando o tempo se esgota (segundos =0)

		call APAGA_ECRAN ;limpa o ecra

  		lea dx, MFim ;apresenta a mensagem de fim de jogo
	
		mov ah, 09h 

		int 21h


		;~~~~~~~~~~~~~~~~~~~~~~ Ciclo para limpar ultimo nome do vetorNomes ~~~~~~~~~~~~~~~~~~~~~~
		
		mov cx,11  ;mete 11 no cx para executar o ciclo 11 vezes
		mov bx,100 ; copia 100 para bx para aceder ao ultimo nome no vetorNomes

		limpaFIM: ;este ciclo limpa os ultimos 10 caracteres do vetorNomes para meter o novo nome
			
			mov vetorNOMES[bx],0 ;apaga efectivamente o caracter no vetor

			inc bx ;incrementa o bx para andar para a frente no vetor

			loop limpaFIM ;ocorre enqanto cx >0

		;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

		;~~~~~~~~~~ Ciclo para Ler input do utilizador e meter no ultimo nome do vetorNomes~~~~~~~
		
		mov bx,100  ; copia 100 para bx para aceder ao ultimo nome no vetorNomes
		mov cx ,10	; mete 10 no cx para executar o ciclo 10 vezes

		LER_INPUT:  ;este ciclo insere caracter a caracter no fim do vetorNomes
				
				xor ax, ax ;limpa ax apara evitar erros
				
				mov ah, 07h ; Ler input do utilizador
				int 21h		;

		
				cmp al,13	;verifica se a tecla é enter 
				je sai		;se for Enter , significa que o nome foi introduzido, logo acaba o ciclo
			
				cmp al, 8	 ;verifica se a tecla é backspace
				je backspace ;salta para bloco de código 'backspace'
				
				;caso nao seja introduzida nenhuma das anteriores, continua a execução do código
			
				mov vetorNOMES[bx+1], al ;mete o valor introduzido na posição atual do vetorNomes
				mov dl, vetorNOMES[bx+1] ;mete o valor no vetor em dl

				mov ah, 02h ;imprime o caracter em ah no ecra para o utilizador saber o que escreveu
				int 21h

				inc bx ;  incrementa o bx para passar à proxima posição do array
				dec cx ;  decrementa o cx por causa do ciclo

				jmp pula	;pula, para evitar a execução do bloco de código 'backspace'

				backspace:	;este código executa se o utilizador carregar em backspace
				
					mov dl, 8	 ;imprime o backspace no ecra para voltar atrás no ecra(criar o efeito visual)
					mov ah, 02h
				
					int 21h

					mov vetorNOMES[bx],0 ; volta à posição anterior do array e apaga o código ascii do backspace que lá foi colocado
			
					dec bx ;decrementa o bx para voltar atrás (como se nao tivesse sido introduzido o 'backspace')
				
				pula: ;vem para aqui caso nao tenha sido executado o bloco de código 'backspace'
				
				cmp cx, 0 ; compara se já foram lidos 10 caracteres do teclado
				
				jne LER_INPUT ;caso nao tenham sido, volta ao ciclo 'LER_INPUT'
		
		;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		
		sai:
		
		mov bx,10 ; mete o valor 10

		mov dl, pontuacao ;mete o valor da pontuação atual em dl

		mov vetorPONTOS[bx],dl ;copia para a última posição do vetor os novos pontos 

		mov dl, 60	;mete em dl 60 (tempo da jogada)

		mov vetorTEMPOS[bx],dl	;copia para a ultima posição do vetor de tempos, o novo tempo

		mov  flagAtualizaTop,1  ;mete a flag 'flagAtualizaTop' para os vetores serem atualizados na proxima execução do top 10

		jmp TOP_10  ;salta para o top 10


;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


;~~~~~~~~~~~~~~~~~~~~~~~~~~ABRIR FICHEIROS DOS RESULTADOS~~~~~~~~~~~~~~~~~~~~~~~


;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~FICHEIRO PONTOS~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
open_fich_pontos proc

        mov     ah,3dh			; vamos abrir ficheiro para leitura 
        mov     al,0			; tipo de ficheiro	
        lea     dx,	fPontos	; nome do ficheiro
        int     21h			; abre para leitura 
        jc      erro_abrir_pontos		; pode aconter erro a abrir o ficheiro 
        mov     HandleFich,ax		; ax devolve o Handle para o ficheiro 
        jmp     ler_ciclo_pontos		; depois de abero vamos ler o ficheiro 

	erro_abrir_pontos:
        mov     ah,09h
        lea     dx,Erro_Open
        int     21h
    

	ler_ciclo_pontos:
       mov     ah,3fh			; indica que vai ser lido um ficheiro 
        mov     bx,HandleFich		; bx deve conter o Handle do ficheiro previamente aberto 
        mov     cx,111		; numero de bytes a ler 
        lea     dx,vetorPONTOS		; vai ler para o local de memoria apontado por dx (car_fich)
        int     21h				; faz efectivamente a leitura
		jc	    erro_ler_pontos		; se carry � porque aconteceu um erro
		cmp	    ax,0			;EOF?	verifica se j� estamos no fim do ficheiro 
		je	    fecha_ficheiro_pontos	; se EOF fecha o ficheiro 
    
		mov     ah,02h			; coloca o caracter no ecran
	    ;mov	    dl,vetor	; este � o caracter a enviar para o ecran
	 
	    int	    21h				; imprime no ecran
	    jmp	    ler_ciclo_pontos		; continua a ler o ficheiro
	
	erro_ler_pontos:
        mov     ah,09h
        lea     dx,Erro_Ler_Msg
        int     21h

	fecha_ficheiro_pontos:		; vamos fechar o ficheiro 
        mov     ah,3eh
        mov     bx,HandleFich
        int     21h

          jnc  sai

        mov     ah,09h			; o ficheiro pode no fechar correctamente
        lea     dx,Erro_Close
        Int     21h

sai: ret

open_fich_pontos ENDP
	;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ FIM  FICHEIRO PONTOS ~~~~~~~~~~~~~~~~~~~~~~~~~~~

	open_fich_tempos proc
	;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ FICHEIRO TEMPOS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

        mov     ah,3dh			; vamos abrir ficheiro para leitura 
        mov     al,0			; tipo de ficheiro	
        lea     dx,fTempo	; nome do ficheiro
        int     21h			; abre para leitura 
        jc      erro_abrir_tempos		; pode aconter erro a abrir o ficheiro 
        mov     HandleFich,ax		; ax devolve o Handle para o ficheiro 
        jmp     ler_ciclo_tempos		; depois de abero vamos ler o ficheiro 

	erro_abrir_tempos:
        mov     ah,09h
        lea     dx,Erro_Open
        int     21h
    

	ler_ciclo_tempos:
        mov     ah,3fh			; indica que vai ser lido um ficheiro 
        mov     bx,HandleFich		; bx deve conter o Handle do ficheiro previamente aberto 
        mov     cx,11		; numero de bytes a ler 
        lea     dx,vetorTEMPOS		; vai ler para o local de memoria apontado por dx (car_fich)
        int     21h				; faz efectivamente a leitura
		jc	    erro_ler_tempos		; se carry � porque aconteceu um erro
		cmp	    ax,0			;EOF?	verifica se j� estamos no fim do ficheiro 
		je	    fecha_ficheiro_tempos	; se EOF fecha o ficheiro 
    
		mov     ah,02h			; coloca o caracter no ecran
	  	;mov	    dl,vetor	; este � o caracter a enviar para o ecran
	 
	  	int	    21h				; imprime no ecran
	  	jmp	    ler_ciclo_tempos		; continua a ler o ficheiro
	
	erro_ler_tempos:
        mov     ah,09h
        lea     dx,Erro_Ler_Msg
        int     21h

	fecha_ficheiro_tempos:					; vamos fechar o ficheiro 
        mov     ah,3eh
        mov     bx,HandleFich
        int     21h
    	  jnc    sai

        mov     ah,09h			; o ficheiro pode n�o fechar correctamente
        lea     dx,Erro_Close
        Int     21h
	sai:

		RET

	open_fich_tempos ENDP

	;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~FIM FICHEIRO NOMES~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

	open_fich_nomes PROC
	;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ FICHEIRO NOMES ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

        mov     ah,3dh			; vamos abrir ficheiro para leitura 
        mov     al,0			; tipo de ficheiro	
        lea     dx,fNomes	; nome do ficheiro
        int     21h			; abre para leitura 
        jc      erro_abrir_nomes		; pode aconter erro a abrir o ficheiro 
        mov     HandleFich,ax		; ax devolve o Handle para o ficheiro 
        jmp     ler_ciclo_nomes		; depois de abero vamos ler o ficheiro 

	erro_abrir_nomes:
        mov     ah,09h
        lea     dx,Erro_Open
        int     21h
    

	ler_ciclo_nomes:
        mov     ah,3fh			; indica que vai ser lido um ficheiro 
        mov     bx,HandleFich		; bx deve conter o Handle do ficheiro previamente aberto 
        mov     cx,100		; numero de bytes a ler 
        lea     dx,vetorNOMES		; vai ler para o local de memoria apontado por dx (car_fich)
        int     21h				; faz efectivamente a leitura
		jc	    erro_ler_nomes		; se carry � porque aconteceu um erro
		cmp	    ax,0			;EOF?	verifica se j� estamos no fim do ficheiro 
		je	    fecha_ficheiro_nomes	; se EOF fecha o ficheiro 
    
		mov     ah,02h			; coloca o caracter no ecran
	  	;mov	    dl,vetor	; este � o caracter a enviar para o ecran
	 
	  	int	    21h				; imprime no ecran
	  	jmp	    ler_ciclo_nomes		; continua a ler o ficheiro
	
	erro_ler_nomes:
        mov     ah,09h
        lea     dx,Erro_Ler_Msg
        int     21h

	fecha_ficheiro_nomes:					; vamos fechar o ficheiro 
        mov     ah,3eh
        mov     bx,HandleFich
        int     21h
          jnc    sai

        mov     ah,09h			; o ficheiro pode n�o fechar correctamente
        lea     dx,Erro_Close
        Int     21h
	sai:
	ret
	;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~FIM FICHEIRO NOMES~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
open_fich_nomes ENDP
;~~~~~~~~~~~~~~~~~ FIM DE ABRIR FICHEIROS PONTOS~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



	
;~~~~~~~~~~~~~~~~~~~~~~~~~~ PROCEDIMENTO PARA GUARDAR FICHEIRO PONTOS ~~~~~~~~~~~~~~~~~~~~~~~~~~
save_fich_pontos proc
	
		mov		ah, 3ch				; Abrir o ficheiro para escrita
		mov		cx, 00H				; Define o tipo de ficheiro ??
		lea		dx, fPontos		; DX aponta para o nome do ficheiro 
		int		21h					; Abre efectivamente o ficheiro (AX fica com o Handle do ficheiro)
		jnc		escreve_pontos				; Se não existir erro escreve no ficheiro
	
		mov		ah, 09h
		lea		dx, msgErrorCreate
		int		21h
	
	
escreve_pontos:

		mov		bx, ax				; Coloca em BX o Handle
    	mov		ah, 40h				; indica que é para escrever
    	
		lea		dx, vetorPONTOS			; DX aponta para a infromação a escrever
    	mov		cx, 11				; CX fica com o numero de bytes a escrever
		int		21h					; Chama a rotina de escrita
		jnc		close				; Se não existir erro na escrita fecha o ficheiro
	
		mov		ah, 09h
		lea		dx, msgErrorWrite
		int		21h
close:
		mov		ah,3eh				; fecha o ficheiro
		int		21h
		jnc sai
	
		mov		ah, 09h
		lea		dx, msgErrorClose
		int		21h
sai:
	ret

save_fich_pontos ENDP

;~~~~~~~~~~~~~~~~~~~~~~~~ FIM PROCEDIMENTO PARA GUARDAR FICHEIRO PONTOS ~~~~~~~~~~~~~~~~~~~~~~~~~~

;~~~~~~~~~~~~~~~~~~~~~~~~~~ PROCEDIMENTO PARA GUARDAR FICHEIRO PONTOS ~~~~~~~~~~~~~~~~~~~~~~~~~~
save_fich_tempos proc

	mov		ah, 3ch				; Abrir o ficheiro para escrita
		mov		cx, 00H				; Define o tipo de ficheiro ??
		lea		dx, fTempo	     	; DX aponta para o nome do ficheiro 
		int		21h					; Abre efectivamente o ficheiro (AX fica com o Handle do ficheiro)
		jnc		escreve_tempos				; Se não existir erro escreve no ficheiro
	
		mov		ah, 09h
		lea		dx, msgErrorCreate
		int		21h
	
	
escreve_tempos:

		mov		bx, ax				; Coloca em BX o Handle
    	mov		ah, 40h				; indica que é para escrever
    	
		lea		dx, vetorTEMPOS		; DX aponta para a infromação a escrever
    	mov		cx, 11				; CX fica com o numero de bytes a escrever
		int		21h					; Chama a rotina de escrita
		jnc		close				; Se não existir erro na escrita fecha o ficheiro
	
		mov		ah, 09h
		lea		dx, msgErrorWrite
		int		21h
close:
		mov		ah,3eh				; fecha o ficheiro
		int		21h
		
		jnc sai

		mov		ah, 09h
		lea		dx, msgErrorClose
		int		21h
sai:
	ret

save_fich_tempos ENDP

;~~~~~~~~~~~~~~~~~~~~~~~~ FIM PROCEDIMENTO PARA GUARDAR FICHEIRO PONTOS ~~~~~~~~~~~~~~~~~~~~~~~~

;~~~~~~~~~~~~~~~~~~~~~~~~~~ PROCEDIMENTO PARA GUARDAR FICHEIRO PONTOS ~~~~~~~~~~~~~~~~~~~~~~~~~~
save_fich_nomes proc
	
		mov		ah, 3ch				; Abrir o ficheiro para escrita
		mov		cx, 00H				; Define o tipo de ficheiro ??
		lea		dx, fNomes	     	; DX aponta para o nome do ficheiro 
		int		21h					; Abre efectivamente o ficheiro (AX fica com o Handle do ficheiro)
		jnc		escreve_nomes				; Se não existir erro escreve no ficheiro
	
		mov		ah, 09h
		lea		dx, msgErrorCreate
		int		21h
	
	
escreve_nomes:

		mov		bx, ax				; Coloca em BX o Handle
    	mov		ah, 40h				; indica que é para escrever
    	
		lea		dx, vetorNOMES			; DX aponta para a infromação a escrever
    	mov		cx, 100				; CX fica com o numero de bytes a escrever
		int		21h					; Chama a rotina de escrita
		jnc		close				; Se não existir erro na escrita fecha o ficheiro
	
		mov		ah, 09h
		lea		dx, msgErrorWrite
		int		21h
close:
		mov		ah,3eh				; fecha o ficheiro
		int		21h
		
		jnc sai

		mov		ah, 09h
		lea		dx, msgErrorClose
		int		21h
sai:
	ret
save_fich_nomes ENDP

;~~~~~~~~~~~~~~~~~~~~~~~~ FIM PROCEDIMENTO PARA GUARDAR FICHEIRO PONTOS ~~~~~~~~~~~~~~~~~~~~~~~~~~


FIM:
	
	call save_fich_nomes
	call save_fich_pontos
	
	call save_fich_tempos
	
    MOV AH,4Ch
    INT 21h
PRINC ENDP
 
   
 
CODIGO  ENDS
END PRINC