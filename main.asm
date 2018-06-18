.8086
.MODEL SMALL
.STACK 2048
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~TRABALHO REALIZADO POR: ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 
	
	;Henrique Manuel Figueiredo Dias nº 21260023
	;Eduardo Simões Barros           nº 21270614

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~DADOS~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

DADOS   SEGMENT PARA 'DATA'
	
	;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ BONUS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	cor_escolhida db 0	   ;cor que o user escolhe para o bonus
	count_escolhido db 0   ;guarda o numero de explosões necessárias
	caracter_bonus db 0	   ;guarda o caracter que vai ser usado no procedimento
	cor_bonus db 0         ;guarda a cor da posição do cursor
	offset_bonus dw 0 	   ;offset relativo à posição do cursor (tem que ser dw porque pode ser negativo)
	igualBonus db 0        ;guarda o valor da comparação (se caracter e cor são iguais)
	eyes db ':'			   
	plus db ')'	
	minus db '('
	bonus db 0			   ;acumula a pontuação ao longo das explosões para depois duplicar
	flagBonusDup db 0	   ;flag que indica se o bonos está ativo ou não
	;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ BONUS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

	
	;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ TOP 10 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	posXtop db 0		   ;usadas para saber a posição do cursor dentro do top 10
	posYtop db 0		   ;
	posTOP db 1	           ;usado para guardar os lugares no top (1º-10º)
	indicePontos dw  0     ;para fazer o ciclo 10 vezes de imprimir a informação 
	;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ TOP 10 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


	;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ TABULEIRO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	tamX_v db 9            ; Largura do tabuleiro
    tamY_v db 6            ; Altura do tabuleiro
	linhaVetor db 0    
	colunaVetor db 0
	indiceVetor dw 0       ;usado para guardar a posição no vetor (quando descemos as peças no tabuleiro)
	count db 0             ;usado para guardar as linhas do tabuleiro quando descemos 
	delayPuxaCol dw 10
	carregado db 0
	editarAberto  db 0
 	flagAtualizaTop db 0   ;variavel que diz se é preciso atualizar o top ou não
	tmpPontos db 0         ;guarda os pontos realizados na ultima jogada
	tmpTempos db 0         ;guarda os  
	tmpSI db 0	           ;usada para guardar o valor de SI depois do ciclo trocaCar
	fimTempo db 0          ;flag que guarda o fim do programa 
	editor db 0			   ;define se está em modo de edição ou não
	usarEditado db 0	   ;flag que é ativa quando se usa o tabuleiro editado
	explodiuMeio db 0      ;flag para informar se foi explodida a peça onde se encontra o cursor
	pontuacao db 0		   ;pontuação num determinado jogo
	ultimo_num_aleat dw 0
	str_num db 5 dup(?),'$'
    espaco  db  ' '
	tamX db 9 			   ; Largura do tabuleiro
    tamY db 6              ; Altura do tabuleiro
    iniX dw 60             ; Primeiro ponto do tabuleiro em X
    iniY db 8              ; Primeiro ponto do tabuleiro em Y    
	POSx_in db 4 		   ;posicao X dentro do tabul
	POSy_in db 3           ;posicao Y dentro do tabul
	vetor db 108 dup(0)    ;vetor que contem o tabuleiro
	nlinha db 5
	aux db 0
	aux2 db 0
	;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ TABULEIRO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	

	;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ TEMPO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	STR12	 		DB 		"            "; String para 12 digitos
	contaSeg 		dw 		0        ;contador que regista a varia��o dos segundos/tempo
	Segundos		dw		?        ; Vai guardar os segundos actuais
	Old_seg			dw		0        ; Guarda os �ltimos segundos que foram lidos
	;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ TEMPO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


    ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ CURSOR ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    Car     db  32  ; Guarda um caracter do Ecran
    Cor     db  7   ; Guarda os atributos de cor do caracter
    Car2        db  32  ; Guarda um caracter do Ecran
    Cor2        db  7   ; Guarda os atributos de cor do caracter
    POSy        db  11  ; A linha pode ir de [1 .. 25]
    POSx        db  38  ; POSx pode ir [1..80] 
    iniTabY     db  8  ; pos Y[0]
    iniTabX     db  30  ; Pos X[0]
    POSya       db  5   ; Posição anterior  y
    POSxa       db  10  ; Posãoo anterior  x
    ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ CURSOR ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		

 	;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ STRINGS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
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
		db "		2 - Jogar grelha aleatoria com bonus						     ",10,13
		db "		3 - Carregar Grelha											     ",10,13 
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
	db "     TEMPO RESTANTE:					              ",10,13
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
	db "		Carregue no enter ou espaco para explodir as pecas			     ",10,13
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


	pagOpenOrCreate db " ",10,13

 	db "  																				 ",10,13
	db "     		  	EDITAR TABULEIRO EXISTENTE OU CRIAR UM NOVO			  	    		 ",10,13
	db "  																	   			 ",10,13
	db "     		 Introduza o nome do ficheiro existente ou do novo 				   		 ",10,13
	db "			    		 												 		 ",10,13
	db "			   	formato: 'nome.txt'				   	    			 ",10,13
	
	db "________________________________________________________________________________ ",10,13
	db "			Input limitada a 15 caracteres						       			 ",10,13
	db "________________________________________________________________________________ ",10,13
	db "																	    		 ",10,13
	db "					                ENTER para continuar		    		  	 ",10,13
	db "							ESC   para sair								 	 ",10,13
	db "$",10,13

	PagJogarBonus db "  ",10,13

	db "     TEMPO RESTANTE:                                      Cor escolhida:",10,13
	db "                                                                         ",10,13
	db "     PONTUACAO:						Faltam explodir:                     ",10,13
	db "                                                                         ",10,13
	db "                                                                         ",10,13
	db "			   		  						   						  	 ",10,13
	db "																	     ",10,13
	db "																	     ",10,13
	db "		 													   			 ",10,13
	db "		 													   			 ",10,13
	db "																	     ",10,13
	db "________________________________________________________________________________ ",10,13
	db "          Cara feliz duplica a pontuacao, cara triste remove pontuacao   	     ",10,13

	db "$",10,13
	PagBonusCor db " ",10,13
	db "                                                                              ",10,13
	db "                                                                              ",10,13
	db "                                                                              ",10,13
	db "                     Qual a cor que deseja selecionar?                        ",10,13
	db "                                                                              ",10,13
	db "                                                                              ",10,13
	db "                                                                              ",10,13
	db "                      1 -  Azul  Escuro                                       ",10,13
	db "                      2 -  Verde                                              ",10,13
	db "                      3 -  Azul Claro                                         ",10,13
	db "                      4 -  Vermelho                                           ",10,13
	db "                      5 -  Roxo                                               ",10,13
	db "                      6 -  Laranja                                            ",10,13
	db "                      7 -  Branco                                             ",10,13
	db "                                                                              ",10,13
	db "                                                                              ",10,13
	db "                                                                              ",10,13
	db "                                                                              ",10,13
	db "                                                                              ",10,13
	db "________________________________________________________________________________ ",10,13
	db "                          Prima 'ESC' para sair para o menu!   	     ",10,13
	db "$",10,13

	PagBonusNumero db " ",10,13
	db "                                                                              ",10,13
	db "                     Esta foi a cor selecionada...                            ",10,13
	db "                                                                              ",10,13
	db "                                                                              ",10,13
	db "                                                                              ",10,13
	db "                    Qual o valor minimo de explosoes?                         ",10,13
	db "                                                                              ",10,13
	db "                     Introduza um digito entre 1 e 9                          ",10,13
	db "                                                                              ",10,13
	db "                                                                              ",10,13
	db "                                                                              ",10,13
	db "                                                                              ",10,13
	db "                                                                              ",10,13
	db "                                                                              ",10,13
	db "                                                                              ",10,13
	db "                                                                              ",10,13
	db "                                                                              ",10,13
	db "                                                                              ",10,13
	db "                                                                              ",10,13
	db "________________________________________________________________________________ ",10,13
	db "                          Prima 'ESC' para sair para o menu!   	     ",10,13
	db "$",10,13

	;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ STRINGS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		
	;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ FICHEIROS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

			vetorTEMPOS db      0,0,0,0,0,0,0,0,0,0,0 ;armazena os tempos do top10
			vetorPONTOS db  	0,0,0,0,0,0,0,0,0,0,0 ;armazena os pontos do top10
			vetorNOMES  db   '                                                                                                              '

			fichTemp db '1',0       ;guarda a input do utilizador
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
			
	
			fPontos      	db 		'pontos.txt'    ,0
			fNomes			db      'nomes.txt'     ,0
			fTempo			db      'tempos.txt'    ,0
			fTabuleiro      db      'tabuleiro.txt' ,0
        	
			;~~~~~~~~~~~~~~~~~~~ NOMES DOS FICHEIROS EM MEMÓRIA ~~~~~~~~~~~~~~~~~~


	;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ FICHEIROS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

DADOS   ENDS

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~DADOS~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


CODIGO  SEGMENT PARA 'CODE'
    ASSUME CS:CODIGO, DS:DADOS
   
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
   
    goto_xy macro       POSx,POSy
        mov     ah,02h
        mov     bh,0        ; numero da página
        mov     dl,POSx
        mov     dh,POSy
        int     10h

    endm
	
;~~~~~~ MACRO QUE MOSTRA UMA STRING NO ECRA ~~~~~~	
MOSTRA MACRO STR 
	MOV AH,09H
	LEA DX,STR 
	INT 21H
ENDM
;~~~~~~ MACRO QUE MOSTRA UMA STRING NO ECRA ~~~~~~	


;~~~~~~~~~~~~~~~~~~~~~~ PROCEDIMENTO PARA DETERMINAR BONUS ~~~~~~~~~~~~~~~~~~~~~~
compara_bonus PROC

		xor ax,ax
		xor cx,cx

		mov cl,caracter_bonus   ;carrega em cl o caracter previamente guardado 
		mov ch, cor_bonus		;carrega em ch o caracter previamente guardado 
		mov al, 160				;mete 160 em al, para fazer a multiplicação
		mul POSy				;mutiplica POSy por 160
		mov si, ax				;mete o resultado em si
        mov ax,2				
		mul POSx				;multiplica POSx por 2
		add si, ax				;adiciona o si a ax de modo a obter a posiçao atual na memoria de video
	
        add si,offset_bonus		;adiciona o offset
		
		cmp es:[si+1],ch		;verifica se a cor na posiçao da memoria de video é igual à carregada em ch
		jne errado				;caso seja falso, salta

		cmp es:[si],cl			;caso a cor seja igual, testa o caracter
		jne errado				;caso esteja errado, salta
		
		mov igualBonus,1		;caso esteja correto, mete a flag a 1, para ser usada posteriormente
		jmp saiMacro

		errado:  
			mov igualBonus,0

		saiMacro:
			ret					;sai do procedimento

compara_bonus ENDP
;~~~~~~~~~~~~~~~~~~~~~~ PROCEDIMENTO PARA DETERMINAR BONUS ~~~~~~~~~~~~~~~~~~~~~~

;~~~~~~~~~~~~~~~~~~~~~ PROCEDIMENTO PARA MOSTRAR PONTUAÇÃO ~~~~~~~~~~~~~~~~~~~~~~
mostra_pont MACRO  pont
	
	xor dx,dx
	mov ax,0

	mov al,pont	   ;carrega em al, o valor que se pretende mostrar

	mov bl, 100    ;mete 100 em bl, uma vez que vamos dividir por 100

	div bl		   ;divide efectivamente	
  
    mov dl,al	   ;guarda os resultados da divisao para usar posteriormente
	mov dh,ah      ;
	
	add al, 30h	   ; caracter correspondente às centenas
	
	mov str12[0],al	 ;guarda o valor das centenas na string para ser imprimida mais tarde		 
	
	xor ax,ax		
	mov al,dh		;vai buscar os valores guardados para dividir mais uma vez, desta vez por 10

	mov bl,10       ;divide por 10
	div bl			;

	add al, 30h		; caracter correspondente às dezenas
	add	ah,	30h		; caracter correspondente às unidades

	mov  str12[1],al			
	mov  str12[2],ah
	mov  str12[3],'$'

	GOTO_XY	22,4 ; posiçao ond evai ser imprimida a pontuação

	MOSTRA	STR12  ;utiliza a macro para mostrar a string			
		
ENDM	
;~~~~~~~~~~~~~~~~~~~~~ PROCEDIMENTO PARA MOSTRAR PONTUAÇÃO ~~~~~~~~~~~~~~~~~~~~~~



;~~~~~~~~~~~~~~~~~~~~~ PROCEDIMENTO PARA MOSTRAR UM NUMERO ~~~~~~~~~~~~~~~~~~~~~~
PRINT_NUMERO MACRO pont
	
	xor ax,ax
	xor dx,dx
	mov ax,0

	mov 	al,pont         ;carrega em al, o valor que se pretende mostrar

	MOV 	cl, 100         ;mete 100 em bl, uma vez que vamos dividir por 100
	div 	cl	            ;divide efectivamente
	
	mov dl,al               ;guarda os resultados da divisao para usar posteriormente
	mov dh,ah		        ;
  

	add 	al, 30h			 ;caracter correspondente às centenas
	MOV 	STR12[0],al		 ; 

	xor ax,ax
	mov al,dh

	mov cl,10				;divide por 10
	div cl

	add al, 30h				 ; caracter correspondente às dezenas
	add	ah,	30h		         ; caracter correspondente às unidades

	mov str12[1],al			; 
	mov str12[2],ah
	mov str12[3],'$'
	MOSTRA	str12	      ;mostra a string no era		
	
ENDM

;~~~~~~~~~~~~~~~~~~~~~ PROCEDIMENTO PARA MOSTRAR UM NUMERO ~~~~~~~~~~~~~~~~~~~~~~




;~~~~~~~~~~~~~~~~~~~~~ MACRO PARA MOSTRAR UM CARACTER ~~~~~~~~~~~~~~~~~~~~~~
PRINT_CAR MACRO car
	
	mov ah,02H
	mov dl,car
	int 21H

ENDM

;~~~~~~~~~~~~~~~~~~~~~ MACRO PARA MOSTRAR UM CARACTER ~~~~~~~~~~~~~~~~~~~~~~
   
   

;~~~~~~~~~~~~~~~~~~~~~~~~~ ROTINA PARA APAGAR O ECRA ~~~~~~~~~~~~~~~~~~~~~~~
  
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
;~~~~~~~~~~~~~~~~~~~~~~~~~ ROTINA PARA APAGAR O ECRA ~~~~~~~~~~~~~~~~~~~~~~~
   
   

;~~~~~~~~~~~~~~~~~~~~~ IMPRIMIR TEMPO E DATA NO ECRA ~~~~~~~~~~~~~~~~~~~~~~~

TRATA_HORAS_JOGO PROC

	PUSHF
	PUSH AX
	PUSH BX
	PUSH CX
	PUSH DX		

	cmp 	segundos, 0
	je 		MensagemFim

	CALL 	LER_TEMPO_JOGO		; Horas MINUTOS e segundos do Sistema
	
	MOV		AX, contaSeg
	cmp		AX, Old_seg			; Verifica se os segundos mudaram desde a ultima leitura
	je		FIM_HORAS			; Se a hora não mudou desde a última leitura sai.
	mov		Old_seg, AX			; Se segundos s�o diferentes actualiza informação do tempo

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

;~~~~~~~~~~~~~~~~~~~~~ IMPRIMIR TEMPO E DATA NO ECRA ~~~~~~~~~~~~~~~~~~~~~~~



;~~~~~~~~~~~~~~~~ PROCEDIMENTO PARA LER TEMPO DE JOGO ~~~~~~~~~~~~~~~~~~~~~~~
LER_TEMPO_JOGO PROC	
 
		PUSH AX
		PUSH BX
		PUSH CX
		PUSH DX
	
		PUSHF
		
		MOV AH, 2CH             ; Obter as horas
		INT 21H                 
		
		XOR AX,AX
		MOV AL, DH              ; meter os segundos em al
		mov contaSeg, AX		; guarda na variavel
 
		POPF
		POP DX
		POP CX
		POP BX
		POP AX
 		RET 
LER_TEMPO_JOGO   ENDP 

;~~~~~~~~~~~~~~~~ PROCEDIMENTO PARA LER TEMPO DE JOGO ~~~~~~~~~~~~~~~~~~~~~~~


;~~~~~~~~~~~~~~~~ PROCEDIMENTO PARA LER INPUT~~~~~~~~~~~~~~~~~~~~~~~
READ_INPUT PROC

		mov si,0
		mov cx,10

		LIMPAR_BUFFER:          ;limpar a string para minimizar erros

			mov fichTemp[si],0
			inc si
			loop LIMPAR_BUFFER

		mov bx,-1
		LER_NOME_FILE:         ;este ciclo insere caracter a caracter no fim do vetorNomes
				
			xor ax, ax         ;limpa ax apara evitar erros
				
			mov ah, 07h        ; Ler input do utilizador
			int 21h		       ;
 
			cmp al, 27         ;se introduzir
			je sai1

			cmp al,13	       ;verifica se a tecla é enter 
			je sai1		       ;se for Enter , significa que o nome foi introduzido enter, logo acaba o ciclo
			
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

		cmp flagBonusDup,0
		je sai
		;~~~~~~~~~~Bonus duplicação ~~~~~~~~~~
		
		mov dl,eyes
		mov al, '('
		mov ah, ')'

	    mov bx, 1356

        mov es:[bx-10],	 dl  	;primeiro mais
		mov es:[bx-12],ah
		
		mov es:[bx+174], dl  ;segundo
		mov es:[bx+172],al

		mov es:[bx+318], dl  
		mov es:[bx+316],al

		mov es:[bx+650],dl 
		mov es:[bx+648],ah 	

	
		mov es:[bx+790],dl
		mov es:[bx+788], al
		

		;~~~~~~~~~~Bonus duplicação ~~~~~~~~~~
		
	SAI:  RET


atualizaTabuleiro endp  

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


PRINC PROC

    MOV AX, DADOS
    MOV DS, AX
	MOV		AX,0B800H
	MOV		ES,AX

	;call open_fich_nomes		;abre para memória o ficheiro dos nomes
	;call open_fich_pontos		;abre para memória o ficheiro dos pontos
	;call open_fich_tempos		;memória o ficheiro dos tempos

	;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Ciclo principal - Inicio do Jogo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	
	MENU_PRINCIPAL:
	
		mov carregado,0

		mov editor,0;mete o editor a 0
		mov flagBonusDup,0
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
			mov editarAberto,1

			cmp  al, 49   ; Se inserir 1
                je Jogar  ; salta para o jogo

			cmp al, 50	;se inserir 2
				je jogarBonus

			cmp  al, 51 ; Se inserir 2
                je SELECT_FILE  ;salta para a seleção do tabuleiro 	
			
            cmp al,52
                je MENU_PRINCIPAL
			
			jmp MENU_JOGAR ;repete o ciclo, caso não ocorra nenhuma das opções anteriores
			jogarBonus:
				
				mov ax, 0b800h  ; Segmento de memória de video onde vai ser desenhado o tabuleiro
          		mov es, ax

				call APAGA_ECRAN
				lea     dx, PagBonusCor	; apresenta no ecrã a string do menu jogar
				mov     ah, 09h		;
				int     21h			;
				
				mov ah,07H		    ;espera pela input do utilizador 
				int 21H
				cmp al, 27			;verifica se o utilizador introduziu EScC
				je MENU_PRINCIPAL	;salta para o menu principal caso tenha introduzido enter

				;~~~~~~~~valida a input do utilizador~~~~~~~
				cmp al,49 			
				jb jogarBonus
				cmp al,57
				ja jogarBonus
				;~~~~~~~~valida a input do utilizador~~~~~~~

				mov cor_escolhida,al  ;mete na variavel o resultado da input
				sub cor_escolhida,30H ;subtrai 48 para obter de ascii para o valor real
				mov ah,0	
				mov cl , 16			  ;multiplica por 16 pq as cores são multiplas de 16
				mul cl 
				
				mov cor_escolhida,al	;move a cor final para a variável
				

				call APAGA_ECRAN

				lea     dx, PagBonusNumero	
				mov     ah, 09h	
				int     21h			

				;~~~~~~~  Mostra a cor que foi selecionada ~~~~~~~~
				mov si, 583    
				mov ch,cor_escolhida
				mov es:[si-1],cx
				mov es:[si+1],cx
				;~~~~~~~  Mostra a cor que foi selecionada ~~~~~~~~
				

				mov ah,07H   ;obtem input do user
				int 21H

				cmp al, 27			;caso seja ESC, volta para o menu
				je MENU_PRINCIPAL

				;~~~~~~~~valida a input do utilizador~~~~~~~
				cmp al, 49
				jb jogarBonus
				cmp al ,57
				ja jogarBonus
				sub al,30h
				;~~~~~~~~valida a input do utilizador~~~~~~~

				mov count_escolhido,al	;guarda o numero escolhido
				mov flagBonusDup,1     ;ativa a flag que avisa o modo de bonus
				jmp jogar

		FORA: 
			CMP AL, 27 
			JE fim;
		
	JMP MENU_PRINCIPAL

;~~~~~~~~~~~~~~~~~~~~~~ECRA PARA SELECIONAR FICHEIRO PARA ABRIR~~~~~~~~~~~~~~

SELECT_FILE: 

		mov segundos,60		
		mov fimTempo,0

		call APAGA_ECRAN
		
			lea     dx, pagOpenFile	; apresenta no ecrã a string do menu jogar
			mov     ah, 09h		;
			int     21h			;
		
		mov cx,15

		goto_xy 26,21
		PRINT_CAR 175

		goto_xy 27,21	

		call READ_INPUT
		
		cmp al, 27
		je MENU_JOGAR
		

		jmp OPEN_FILE

jmp SELECT_FILE

carregaJogo:

	mov editor,0
	mov carregado,1
	jmp jogar

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
		je	    carregaJogo
    
		mov     ah,02h			; coloca o caracter no ecran
	  ;mov	    dl,vetor	; este � o caracter a enviar para o ecran
	 
	  int	    21h				; imprime no ecran
	  jmp	    ler_ciclo		; continua a ler o ficheiro

erro_ler:
        mov     ah,09h
		
        lea     dx,Erro_Ler_Msg
        int     21h

fecha_ficheiro:					; vamos fechar o ficheiro 
        mov     ah,3eh
        mov     bx,HandleFich
        int     21h

        jnc     IniciaEdicaoAberto

        mov     ah,09h			; o ficheiro pode n�o fechar correctamente
        lea     dx,Erro_Close
        Int     21h

IniciaEdicaoAberto:
		mov 	editarAberto,0
		mov  editor,1
		jmp jogar
erro_abrir:
		
		call APAGA_ECRAN
        mov     ah,09h
        lea     dx,Erro_Open
        int     21h
		mov ah, 07h
		int 21H
		jmp SELECT_FILE

;~~~~~~~~~~~~~~~~~~~~~~~ Abrir ficheiro do tabuleiro ~~~~~~~~~~~~~~~~~~~
OPEN_OR_CREATE:

		mov editor,1
		
		mov segundos,60
			
		mov fimTempo,0

		call APAGA_ECRAN
			lea     dx, pagOpenOrCreate	; apresenta no ecrã a string do menu jogar
			mov     ah, 09h		;
			int     21h			;
		
		mov cx,15

		goto_xy 26,21
		PRINT_CAR 175

		goto_xy 27,21	

		call READ_INPUT
		
		
		jmp OPEN_TABUL
        

jmp OPEN_OR_CREATE


OPEN_TABUL:
		
        mov     ah,3dh			; vamos abrir ficheiro para leitura 
        mov     al,0			; tipo de ficheiro	
        lea     dx,fichTemp			; nome do ficheiro
        int     21h			    ; abre para leitura 
        jc      erro_abrir_tabul		; pode aconter erro a abrir o ficheiro 
        mov     HandleFich,ax		; ax devolve o Handle para o ficheiro 
        jmp     ler_ciclo		; depois de abero vamos ler o ficheiro 

ler_ciclo_tabul:
       
	    mov     ah,3fh			; indica que vai ser lido um ficheiro 
        mov     bx,HandleFich		; bx deve conter o Handle do ficheiro previamente aberto 
        mov     cx,108			; numero de bytes a ler 
        lea     dx,vetor		; vai ler para o local de memoria apontado por dx (car_fich)
        int     21h				; faz efectivamente a leitura
		jc	    erro_ler_tabul		; se carry � porque aconteceu um erro
		cmp	    ax,0			;EOF?	verifica se j� estamos no fim do ficheiro 
		je	    fecha_ficheiro_tabul	; se EOF fecha o ficheiro 
    
		mov     ah,02h			; coloca o caracter no ecran
	  ;mov	    dl,vetor	; este � o caracter a enviar para o ecran
	 
	  int	    21h				; imprime no ecran
		
	  jmp	    ler_ciclo_tabul		; continua a ler o ficheiro

erro_ler_tabul:
        mov     ah,09h
        lea     dx,Erro_Ler_Msg
        int     21h
		

fecha_ficheiro_tabul:					; vamos fechar o ficheiro 
        mov     ah,3eh
        mov     bx,HandleFich
        int     21h
	
        jnc     EDITAR_ABERTO

        mov     ah,09h			; o ficheiro pode n�o fechar correctamente
        lea     dx,Erro_Close
        Int     21h

erro_abrir_tabul:
		
		call    APAGA_ECRAN  
		mov     editor,1
		jmp     CREAT_FILE


CREAT_FILE:

	   mov		ah, 3ch			; Abrir o ficheiro para escrita
		mov		cx, 00H				; Define o tipo de ficheiro ??
		lea		dx, fichTemp			; DX aponta para o nome do ficheiro 
		int		21h					; Abre efectivamente o ficheiro (AX fica com o Handle do ficheiro)
		jnc		cria			; Se não existir erro escreve no ficheiro
		mov		ah, 09h
		lea		dx, msgErrorCreate
		int		21h
	cria:

		mov		bx, ax				; Coloca em BX o Handle
    	mov		ah, 40h				; indica que é para escrever
    	
		lea		dx, vetor			; DX aponta para a infromação a escrever
    	mov		cx, 108					; CX fica com o numero de bytes a escrever
		int		21h					; Chama a rotina de escrita
		jnc		EDITAR_ABERTO				; Se não existir erro na escrita fecha o ficheiro
	
		mov		ah, 09h
		lea		dx, msgErrorWrite
		int		21h		

EDITAR_ABERTO:

	mov carregado,0
	mov editor,1
	mov editarAberto,1
	jmp jogar

SAVE:
			
		mov		ah, 3ch				; Abrir o ficheiro para escrita
		mov		cx, 00H				; Define o tipo de ficheiro ??
		lea		dx, fichTemp			; DX aponta para o nome do ficheiro 
		int		21h					; Abre efectivamente o ficheiro (AX fica com o Handle do ficheiro)
		jnc		escreve				; Se não existir erro escreve no ficheiro
		mov		ah, 09h
		lea		dx, msgErrorCreate
		int		21h
	
		

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
		
		jnc		MENU_PRINCIPAL
	
		mov		ah, 09h
		lea		dx, msgErrorClose
		int		21h
		mov ah,02H
		int 21h

		jmp CONF_GRELH


CONF_GRELH:


		mov editor,1          ;ativa a flag do editor

		mov editarAberto,0	  

		mov carregado,0

		jmp OPEN_OR_CREATE 

		jmp jogar

		jmp MENU_PRINCIPAL

jogar:

	call APAGA_ECRAN   ;apaga o ecra 

	MOV		AX,0B800H  ;incializa  a mem de video
	MOV		ES,AX

	cmp flagBonusDup,1 ;verifica se o bonus está ativo
	je jogar_Bonus
    
	cmp carregado , 1	;verifica se o jogo foi carregado
	je jogarCarregado	;salta para carregar jogo

	cmp editor,0		;verifica se estamos no modo de edição
	je salto5			;vai para o salto5
		
	cmp editarAberto,0  ;caso esteja no modo de editar o tabuleiro aberto
	je Edita_jogar  
		
	cmp editarAberto,0	;caso nao se verificam 
	jne salto5
	
	Edita_jogar:
		call apaga_ecran
		lea     dx, layoutEditor
		mov     ah, 09h
		int     21h
		mov segundos,60
		mov editor,1
		jmp salto5
	
	salto6:
		call APAGA_ECRAN
		mov editor,1
		lea     dx, layoutEditor
		mov     ah, 09h
		int     21h
		mov segundos,60
		jmp salto2

	salto5:  ;caso nao esteja ativo o modo de ediçãça0
		lea     dx, jogo
		mov     ah, 09h
		int     21h
		mov pontuacao,0
   		mov Segundos, 60 ; iniciou o jogo
		jmp salto2       ;inicio o jogo normamente

	jogar_Bonus:
		lea     dx, PagJogarBonus
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

;~~~~~~~~~~~COPIA PARA O VETOR ~~~~~~~~~	
        
		mov ah,cl 
        mov vetor[si], al 
		inc si

	    mov vetor[si], al 
		inc si

	    mov cl,ah

;~~~~~~~~~~~COPIA PARA O VETOR ~~~~~~~~~	
		
        mov di, 1      ;delay de 1 centesimo de segundo
        call    delay
        loop    ciclo       ; continua at� fazer as 9 colunas que correspondem a uma liha completa
       
        inc iniY        ; Vai desenhar a pr�xima linha
        dec tamY        ; contador de linhas
        mov al, tamY
        cmp al, 0       ; verifica se j� desenhou todas as linhas
        jne ciclo2      ; se ainda h� linhas a desenhar continua


    	goto_xy     iniY,POSy   ; Vai para nova possi��o
    	mov     ah, 08h ; Guarda o Caracter que est� na posi��o do Cursor
    	mov     bh,0        ; numero da p�gina
    	int     10h        
    	mov     Car, al ; Guarda o Caracter que est� na posi��o do Cursor
   		; mov     Cor, ah ; Guarda a cor que est� na posi��o do Cursor
   		
		;~~~~~~~~~ Retificar a cor de fundo~~~~~~~~~~
		mov cl, 4   ; ror tem que ser em cl
		ror ah, cl  ; desloca o bit menos significativo
		;~~~~~~~~~ Retificar a cor de fundo~~~~~~~~~~
		add ah, 48
		mov Cor, ah ; Guarda a cor que est� na posi��o do Cursor
		
   
   
   		inc     POSx
   	 	goto_xy     POSx,POSy   ; Vai para nova possi��o2
    	mov         ah, 08h     ; Guarda o Caracter que est� na posi��o do Cursor
    	mov     bh,0        ; numero da p�gina
    	int     10h        
    	mov     Car2, al    ; Guarda o Caracter que est� na posi��o do Cursor
    	;mov     Cor2, ah    ; Guarda a cor que est� na posi��o do Cursor
		
		;~~~~~~~~~ Retificar a cor de fundo~~~~~~~~~~
		mov cl, 4  ; ror tem que ser em cl
		ror ah, cl ; desloca o bit menos significativo
		;~~~~~~~~~ Retificar a cor de fundo~~~~~~~~~~
		add ah, 48
		mov Cor2, ah ; Guarda a cor que est� na posi��o do Cursor
   		dec     POSx

jmp CICLO_CURSOR


jogarCarregado:   ;inicia o jogo de um tabuleiro carregado

		call APAGA_ECRAN		;apaga o ecra
		cmp editarAberto,0      ;verifica se 
		je editarCarregado      
		mov editor,0            ;garante que nao está no modo de edição
 		lea dx, jogo            ;mostra a string do jogo
		mov ah, 09h
		int 21h
		mov pontuacao,0			;faz reset da pontuação
   		mov Segundos, 60 		;dá 60segundos de tempo
		jmp CICLO_CURSOR

editarCarregado:

		mov editor,1
		call APAGA_ECRAN
		mov editor,1
		lea     dx, layoutEditor
		mov     ah, 09h
		int     21h
		mov segundos,60
		jmp CICLO_CURSOR


CICLO_CURSOR:       
        
		call atualizaTabuleiro
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
		
		
			
		add ah, 48
		mov Cor, ah ; Guarda a cor que est� na posi��o do Cursor
	   
        inc     POSx
        goto_xy     POSx,POSy   ; Vai para nova possi��o
        mov         ah, 08h
        mov     bh,0        ; numero da p�gina
        int     10h    
        mov     Car2, al    ; Guarda o Caracter2 que est� na posi��o do Cursor2
        ;mov     Cor2, ah    ; Guarda a cor que est� na posi��o do Cursor2
        
	
		;~~~~~~~~~ Retificar a cor de fundo~~~~~~~~~~
		mov cl, 4  ; ror tem que ser em cl
		ror ah, cl ; desloca o bit menos significativo
		;~~~~~~~~~ Retificar a cor de fundo~~~~~~~~~~
			
		add ah, 48
		
		dec     POSx
       
		;      goto_xy     0,0        ; Mostra o caractr que estava na posi��o do AVATAR
		;      mov     ah, 02h         ; IMPRIME caracter da posi��o no canto
 		;      mov     dl, Car
 		;      int     21H        
		
		cmp flagBonusDup,1    ;verifica se o bonus está ativo, se estiver, imprime o numero
		jne salto9            ;salta se nao for verdade
		goto_xy 73,4
		PRINT_NUMERO count_escolhido

		salto9:
			cmp editor ,1     ;se o editor estiver aberto, n mostra a pontuação
			je salto4
			mostra_pont pontuacao
		
		salto4:
			goto_xy     POSx,POSy   ;Vai para posi��o do cursor
			cmp al,113
			je FIM
		        

IMPRIME:    
		
		mov     ah, 02h
        mov     dl, 177
        int     21H
       
        inc     POSx
        goto_xy     POSx,POSy      
        mov     ah, 02h
        mov     dl, 177 
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
		
		cmp editor,1
		jne salto8
		
		call  atualizaTabuleiro ; atualiza o ecrã com o vetor de cores em memória 
		
		salto8:
			call      LE_TECLA
			cmp     ah, 1
       		je      ESTEND
     		cmp AL,52   
			je MENU_PRINCIPAL

 			cmp editor,1	  ;se o modo de edicao estiver aberto
			je MUDACOR

			cmp AL, 32        ;se carregar no espaço 
			je OLHAEXPLOSAO

			cmp AL, 13        ;se carregar no enter
			je OLHAEXPLOSAO
		
        jmp     LER_SETA

INCREMENTA_MEIO:   ;incrementa se explodir a peça atual do cursor

		inc pontuacao
		mov explodiuMeio,0
		jmp OLHAEXPLOSAO


OLHAEXPLOSAO:	 ;a execução do programa vem para aqui, caso carregue no enter 
	
		cmp explodiuMeio,1
		je INCREMENTA_MEIO

		;calcula a posição dentro do tabuleiro
		mov ax, 18	
		mov cl, POSy_in
		mul cl
		add bx,ax
		mov ax,2
		mov cl, POSx_in
		mul cl
		add bx, ax
		;calcula a posição dentro do tabuleiro

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
		je termina
		
		jmp LER_SETA
		
		Termina: ;guarda o tabuleiro
			mov editor,0 
			je SAVE

		jmp LER_SETA


METECOR:    ;mete uma cor aleatória
		
		;calcula a posição dentro do tabuleiro
		xor bx,bx 
		mov ax, 18
		mov cl, POSy_in
		mul cl
		add bx,ax
		mov ax,2
		mov cl, POSx_in
		mul cl
		add bx, ax
		;calcula a posição dentro do tabuleiro

		;calcula cor aleatória
		call    CalcAleat   ; Calcula pr�ximo aleat�rio que � colocado na pinha
        pop ax ;        ; Vai buscar 'a pilha o n�mero aleat�rio
        and al,01110000b   ; posição do ecran com cor de fundo aleat�rio e caracter a preto		
        cmp al, 0       ; Se o fundo de ecran é preto
		je METECOR   ;volta a executar
		;calcula cor aleatória
		
		mov vetor[bx],al		;Mete a nova cor na posição do cursor
		mov vetor[bx+1],al		;
	
		jmp LER_SETA

EXPLODE_DIR_F:

		goto_xy     50,0       
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
       
       	call atualizaTabuleiro
		mov di, 75
		call delay
		call atualizaTabuleiro
		mov indiceVetor, 108
	
	    mov nlinha,5
        
		cmp vetor[bx+17],al
		jne VERIFICABONUS
		cmp POSx_in, 0
		je VERIFICABONUS
  		call atualizaTabuleiro
		  mov di, 75
		  call delay
		  call atualizaTabuleiro
		mov vetor[bx+16],0
		mov vetor[bx+17],0
		
		mov vetor[bx],0
		mov vetor[bx+1],0
		inc bonus
		inc pontuacao
		mov explodiuMeio,1 

		jmp VERIFICABONUS

;~~~~~~~~~~~~~~~~~~~~~~~~~~PROCEDIMENTO DECREMNTAR AS NECESSARIAS~~~~~~~~~~~~~~~~~~
decAExplodir PROC
 	
	mov cl, cor_escolhida

	cmp cl,cor_bonus
	jne fim

	dec count_escolhido
		
 fim:
ret

decAExplodir ENDP
;~~~~~~~~~~~~~~~~~~~~~~~~~~PROCEDIMENTO DECREMNTAR AS NECESSARIAS~~~~~~~~~~~~~~~~~~


;~~~~~~~~~~~~~~~~~~~~~~~~~~PROCEDIMENTO PARA VERIFICAR O BONUS~~~~~~~~~~~~~~~~~~~
VERIFICABONUS:
        
		mov ax, 0b800h  ; Segmento de memória de video onde vai ser desenhado o tabuleiro
        mov es, ax

		xor si,si
        xor dx,dx
		xor cx,cx
		xor ax,ax

		
        cmp bonus, 0  			;caso o modo de bonus esteja desativado, ignora a verificação de bonus
		je CICLOLIMPATABUL		;salta para o menu


		;;determinar a cor atual do cursor no vetor
		mov si,470
		mov ch,cor_escolhida
			
		mov es:[si],cx
		mov es:[si-2],cx

		mov al, 18
		mul POSy_in
		mov bx, ax
        mov ax,2
		mul POSx_in
		add bx, ax
          
		mov cl, 40
		mov ch, 41
		  
		xor cx,cx 
		mov cl, vetor[bx]
		mov cor_bonus,cl

     	call decAExplodir
		 
	;~~~~~~~~ LADO ESQUERO

		;~~~~ HAPPY FACE~~~~~
		  mov caracter_bonus,40 ;mete o caracater '('
		  mov offset_bonus, -4
		  call compara_bonus 
		  cmp igualBonus,1
		  je explodePos
		;~~~~ SAD FACE~~~~~
		  mov caracter_bonus,41 ;mete o caracater ')'
		  mov offset_bonus, -4	;
		  call compara_bonus 
		  cmp igualBonus,1
		  je explodeNeg	
	;~~~~~~~~~~~~~~~~~~~~~

	;~~~~~~~~ LADO DIREITO

		;~~~~ HAPPY FACE~~~~~
		  mov caracter_bonus,40 ;mete o caracater '('
		  mov offset_bonus, 4
		  call compara_bonus 
		  cmp igualBonus,1
		  je explodePos
		;~~~~ SAD FACE~~~~~
		  mov caracter_bonus,41 ;mete o caracater ')'
		  mov offset_bonus, 4	;
		  call compara_bonus 
		  cmp igualBonus,1
		  je explodeNeg	
	;~~~~~~~~~~~~~~~~~~~~~

	;~~~~~~~~	CIMA

		;~~~~ HAPPY FACE~~~~~
		  mov caracter_bonus,40 ;mete o caracater '('
		  mov offset_bonus, -160
		  call compara_bonus 
		  cmp igualBonus,1
		  je explodePos
		;~~~~ SAD FACE~~~~~
		  mov caracter_bonus,41 ;mete o caracater ')'
		  mov offset_bonus, -160	;
		  call compara_bonus 
		  cmp igualBonus,1
		  je explodeNeg	
	;~~~~~~~~~~~~~~~~~~~~~
	
	;~~~~~~~~ BAIXO

		;~~~~ HAPPY FACE~~~~~
		  mov caracter_bonus,40 ;mete o caracater '('
		  mov offset_bonus, 160
		  call compara_bonus 
		  cmp igualBonus,1
		  je explodePos
		;~~~~ SAD FACE~~~~~
		  mov caracter_bonus,41 ;mete o caracater ')'
		  mov offset_bonus, 160	;
		  call compara_bonus 
		  cmp igualBonus,1
		  je explodeNeg	
	;~~~~~~~~~~~~~~~~~~~~~

	;~~~~~~~~ ESQUERDA TOPO

		;~~~~ HAPPY FACE~~~~~
		  mov caracter_bonus,40 ;mete o caracater '('
		  mov offset_bonus, -164
		  call compara_bonus 
		  cmp igualBonus,1
		  je explodePos
		;~~~~ SAD FACE~~~~~
		  mov caracter_bonus,41 ;mete o caracater ')'
		  mov offset_bonus, -164	;
		  call compara_bonus 
		  cmp igualBonus,1
		  je explodeNeg	
	;~~~~~~~~~~~~~~~~~~~~~
	;~~~~~~~~ DIREITA TOPO

		;~~~~ HAPPY FACE~~~~~
		  mov caracter_bonus,40 ;mete o caracater '('
		  mov offset_bonus, -156
		  call compara_bonus 
		  cmp igualBonus,1
		  je explodePos
		;~~~~ SAD FACE~~~~~
		  mov caracter_bonus,41 ;mete o caracater ')'
		  mov offset_bonus, -156	;
		  call compara_bonus 
		  cmp igualBonus,1
		  je explodeNeg	
	;~~~~~~~~~~~~~~~~~~~~~
	
	;~~~~~~~~ ESQUERDA BAIXO

		;~~~~ HAPPY FACE~~~~~
		  mov caracter_bonus,40 ;mete o caracater '('
		  mov offset_bonus, 156
		  call compara_bonus 
		  cmp igualBonus,1
		  je explodePos
		;~~~~ SAD FACE~~~~~
		  mov caracter_bonus,41 ;mete o caracater ')'
		  mov offset_bonus, 156	;
		  call compara_bonus 
		  cmp igualBonus,1
		  je explodeNeg	
	;~~~~~~~~~~~~~~~~~~~~~
    ;~~~~~~~~ ESQUERDA TOPO

		;~~~~ HAPPY FACE~~~~~
		  mov caracter_bonus,40 ;mete o caracater '('
		  mov offset_bonus, 164
		  call compara_bonus 
		  cmp igualBonus,1
		  je explodePos
		;~~~~ SAD FACE~~~~~
		  mov caracter_bonus,41 ;mete o caracater ')'
		  mov offset_bonus, 164	;
		  call compara_bonus 
		  cmp igualBonus,1
		  je explodeNeg	
	    ;~~~~~~~~~~~~~~~~~~~~~
		
		  jmp CICLOLIMPATABUL


;~~~~~~~~~~~~~REDUZ A PONTUAÇAO CASO SEJA SADFACE~~~~~~~~~~~~~~~		  
explodeNeg:

		

		 dec pontuacao
		 dec pontuacao
		 dec pontuacao
		 dec pontuacao
		 jmp CICLOLIMPATABUL
;~~~~~~~~~~~~~REDUZ A PONTUAÇAO CASO SEJA SADFACE~~~~~~~~~~~~~~~


;~~~~~~~~~~~~~~~~~~~~~~~~DUPLICA PONTUAÇÃO~~~~~~~~~~~~~~~~~~~
explodePos:
		
		call decAExplodir
         mov dh,0
         mov dl, bonus
		 add pontuacao,dl
		 add pontuacao,1
		 jmp CICLOLIMPATABUL
		
;~~~~~~~~~~~~~~~~~~~~~~~~DUPLICA PONTUAÇÃO~~~~~~~~~~~~~~~~~~~
ESTEND:     
		cmp  al,48h
        jne  BAIXO
        
		mov ah,iniTabY    ;verifica se chegou ao inicio do top do tabuleiro
        cmp ah,POSy		  ;
       
	    je CICLO_CURSOR	  ;caso tenha chegado ao inicio do tabuleiro, volta a fazer o ciclo

        dec     POSy      ;decrementa as posições do cursor no tabuleiro 
		dec POSy_in		  ;
       
	    jmp     CICLO_CURSOR ;repor as cenas
 
 
BAIXO:     
        cmp     al,50h
        jne     ESQUERDA
                		
        mov ah,iniTabY  
        add ah,5 	    ;calcula o fim do tabuleiro
      
	    cmp ah,POSy     ;verifica se chegou ao inicio do top do tabuleiro
        je CICLO_CURSOR
      
	    inc POSy        ;incrementa POSy para andar para baixo
		inc POSy_in     ;

        jmp CICLO_CURSOR
 

ESQUERDA:

        cmp     al,4Bh
        jne     DIREITA

        mov ah,iniTabX 
        cmp ah,POSx       ;compara a posicao com o inicio do tabuleiro
	    je CICLO_CURSOR   ;caso seja igual, volta a executar ciclo

        dec     POSx        ;decrementa 2 vezes (1 quadrado = 2 )
        dec     POSx        
		dec     POSx_in       
        
		jmp     CICLO_CURSOR 
 
 
DIREITA:
      
        mov ah,iniTabX
        add ah,16  			;8*2
        cmp ah,POSx
		je CICLO_CURSOR

        inc     POSx        ;incrementa 2 vezes (1 quadrado = 2 )
        inc     POSx       
		inc     POSx_in      

        jmp     CICLO_CURSOR 


;~~~~~~~~~~~~~~~~~~~~~~~~~~CICLO PARA DESCER PEÇAS~~~~~~~~~~~~~~~~~~
CICLOLIMPATABUL:
    
	cmp indiceVetor,0      ;ve se já chegou ao fim
	je LER_SETA

	mov cl, POSy_in		   
	mov count,cl		   ;copia para o count o numeor de vezes que o cilco vao acontecer 

	mov bx, indiceVetor	   ;mete em bx a posição atual no tabuleiro	 

	cmp vetor[bx-1],0	   ;verifica se a posição atual é preto
	PUSH bx				   ;guarda o valor e bx na pilha
	je PUXA_COL			   ;puxa a coluna 
	
	dec indiceVetor		   ;dec o indice do vetor, para andar para o quadrado anterior
 	dec indiceVetor
	
	jmp CICLOLIMPATABUL
;~~~~~~~~~~~~~~~~~~~~~~~~~~CICLO PARA DESCER PEÇAS~~~~~~~~~~~~~~~~~~

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~PUXA COLUNA~~~~~~~~~~~~~~~~~~~~~~~~
PUXA_COL:

	push bx                  ;guarda o valor de BX
	call atualizaTabuleiro   ;atualiza o tabuleiro
	
	mov di,delayPuxaCol		 ;mete o valor do delay em di para usar no procedimento
	call delay

	call atualizaTabuleiro	;atualiza o tabuleiro para ser visivel o delay

	pop bx					;recupera o valor de BX
	xor dx,dx
	xor ax,ax
	
	cmp count,0				;verifica se chegou à primeira coluna
	je COR_CIMA

	mov al, vetor[bx-19]	;guarda o valor do quadrado em cima
	mov ah, vetor[bx-20]	;
	
	mov vetor[bx-2],al		;mete o quadrado atual com a cor do de cima
	mov vetor[bx-1],ah		;
	
	dec count				;reduz o numero de vezes que vai ocorrer o ciclo
	
	sub bx,18				;reduz o valor de bx em 18 para andar para a linha de cima
	jmp PUXA_COL

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~PUXA COLUNA~~~~~~~~~~~~~~~~~~~~~~~~


;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~METER NOVA COR NO CIMO~~~~~~~~~~~~~~~~~~~~~~~~
COR_CIMA:

        call    CalcAleat   ; Calcula pr�ximo aleat�rio que � colocado na pinha
        pop ax ;        ; Vai buscar 'a pilha o n�mero aleat�rio
        and al, 01110000b   ; posi��o do ecran com cor de fundo aleat�rio e caracter a preto		
        cmp al, 0       ; Se o fundo de ecran é preto
        je  COR_CIMA     ; vai buscar outra cor

    
		mov vetor[bx-1], al  	;mete a nova cor na primeira linha  do tabuleiro
		mov vetor[bx-2], al		;

		POP bx ;restaura o valor de bx
	
	
	jmp CICLOLIMPATABUL

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~METER NOVA COR NO CIMO~~~~~~~~~~~~~~~~~~~~~~~~

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

	 	goto_xy 20,20
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