;
; Programa Relogio Digital 20-04-202 by RJAJ
;	Milena Freitas e Vanessa Cunha
;	9841 - 2021
;

dseg at 8   ; Memória de dados
		
SEGS:	  ds		1; Ocupa 1 byte
MIN:	  ds		1
HORA:	  ds		1
DIA:	  ds		1
MES:      ds		1
ANO:	  ds		1
DIASEMANA:ds		1	
COD0:     ds        1 ;US     UA      
COD1:     ds        1 ;DS     DA  
COD2:     ds        1 ;-      - 
COD3:     ds        1 ;UM     UM  
COD4:     ds        1 ;DM     SM  
COD5:     ds        1 ;-      - 
COD6:     ds        1 ;UH     UD  
COD7:     ds        1 ;DH     DD  
CONTALOW: ds        1 ;parte baixa low  (480) = 0e0H = 224 
CONTAHIGH:ds        1 ;parte alta  high (480) = 001H = 1

	
DSP1      equ       P2.0
DSP2      equ       P2.1
DSP3      equ       P2.2
DSP4      equ       P2.3
DSP0      equ       P2.4
DSP5      equ       P2.5
DSP6      equ       P2.6
DSP7      equ       P2.7
chave 	  equ		P3.0
chave2	  equ		P3.1
chaveseg  equ       P3.2
chavemin  equ       P3.3
chavehor  equ       P3.4
chavedia  equ       P3.5
chavemes  equ       P3.6
chaveano  equ       P3.7
	
	cseg	;  Segmento de Programa

inicio:	mov		 SEGS,#0
		mov		 MIN,#0
		mov		 HORA,#12
		mov		 DIA,#1
		mov		 MES,#1
		mov		 ANO,#21
		mov		 DIASEMANA, #1
		
		clr       DSP0      ; desliga display
        setb      DSP1      ; desliga display
        setb      DSP2      ; desliga display
        setb      DSP3      ; desliga display
        setb      DSP4      ; desliga display
        setb      DSP5      ; desliga display
        setb      DSP6      ; desliga display
        setb      DSP7      ; desliga display
		
displaay: jnb       DSP0,rot1          
          jnb       DSP1,rot2
          jnb       DSP2,rot3
          jnb       DSP3,rot4
          jnb       DSP4,rot5
          jnb       DSP5,rot6
          jnb       DSP6,rot7
          jnb       DSP7,rot0
          
rot1:     setb      DSP0
          mov       P0,COD1
          clr       DSP1
          jmp       volta 

rot2:     setb      DSP1
          mov       P0,COD2
          clr       DSP2
          jmp       volta
          
rot3:     setb      DSP2
          mov       P0,COD3
          clr       DSP3
          jmp       volta
          
rot4:     setb      DSP3
          mov       P0,COD4
          clr       DSP4
          jmp       volta
          
rot5:     setb      DSP4
          mov       P0,COD5
          clr       DSP5
          jmp       volta
          
rot6:     setb      DSP5
          mov       P0,COD6
          clr       DSP6
          jmp       volta
          
rot7:     setb      DSP6
          mov       P0,COD7
          clr       DSP7
          jmp       volta
          
rot0:     setb      DSP7
          mov       P0,COD0
          clr       DSP0
          jmp       volta 
;-----------------------------------------------------------------------
;****************DELAY***********************
volta:     jnb 		chave2, jumpsemana ;se a chave2 estiver ativa, salta pra jumpsemana
		   mov     	r6,#6    ;1	ciclo de máquina
L1:        mov		r5,#172  ;1 ciclo de máquina
		   djnz		r5,$     ;2 ciclos de máquina
		   djnz		r6,L1    ;2 ciclos de máquina
		   jmp 		time
 jumpsemana:
	jmp dias
;-----------------------------------------------------------------------
;**************CONVERSAO***************************
time:
	jnb		chave, date
	mov		a,SEGS   
	mov		b,#10
	div		ab	        ;a quociente = dezena
				        ;b resto     = unidade
	mov		dptr,#tabela		
	movc	a,@a+DPTR   ;Pegar o código
	mov		COD1,a      ;Dezena segundos
	mov		a,b
	movc	a,@a+DPTR   ;Pegar o código
	mov		COD0,a      ;Unidade segundos 
	
	mov		COD2, #7FH
	
	mov		a,MIN
	mov		b,#10
	div		ab	        ;a quociente = dezena
				        ;b resto     = unidade
	mov		dptr,#tabela		
	movc	a,@a+DPTR   ;Pegar o código
	mov		COD4,a      ;Dezena minuto
	mov		a,b
	movc	a,@a+DPTR   ;Pegar o código
	mov		COD3,a      ;Unidade minuto
	
	mov		COD5, #7FH
	
	mov		a,HORA
	mov		b,#10
	div		ab	         ;a quociente = dezena
				         ;b resto     = unidade
	mov		dptr,#tabela		
	movc	a,@a+DPTR    ;Pegar o código
	mov		COD7,a       ;Dezena hora
	mov		a,b
	movc	a,@a+DPTR    ;Pegar o código
	mov		COD6,a       ;Unidade da hora
	jmp		contador
	
date:
	mov		a,ANO   
	mov		b,#10
	div		ab	         ;a quociente = dezena
				         ;b resto     = unidade
	mov		dptr,#tabela		
	movc	a,@a+DPTR    ;Pegar o código
	mov		COD1,a       ;Dezena segundos
	mov		a,b
	movc	a,@a+DPTR    ;Pegar o código
	mov		COD0,a       ;Unidade segundos 
	
	mov		COD2, #0bfh
		
	mov		a,MES
	mov		b,#10
	div		ab	        ;a quociente = dezena
				        ;b resto     = unidade
	mov		dptr,#tabela		
	movc	a,@a+DPTR   ;Pegar o código
	mov		COD4,a      ;Dezena minuto
	mov		a,b
	movc	a,@a+DPTR   ;Pegar o código
	mov		COD3,a      ;Unidade minuto
	
	mov		COD5, #0bfh
	
	mov		a,DIA
	mov		b,#10
	div		ab	        ;a quociente = dezena
				        ;b resto     = unidade
	mov		dptr,#tabela		
	movc	a,@a+DPTR   ;Pegar o código
	mov		COD7,a      ;Dezena hora
	mov		a,b
	movc	a,@a+DPTR   ;Pegar o código
	mov		COD6,a      ;Unidade da hora
;-----------------------------------------------------------------------
;***************CONTADOR*******************
contador:
       inc		CONTALOW       ;Ex: 08, o digito direito é o LOW, o esquerdo é HIGH (incrementa low)
	   mov		a,CONTALOW     ;Ex: 09, quando incrementa o 09, ele vai para 0
	   jnz		pular          ;Ex: 10, quando o LOW é zero, incrementa o HIGH (se não chegou no limite, pula)
	   inc		CONTAHIGH      ;Ex: 11, HIGH incrementado
	
pular: mov		a,CONTAHIGH        ;movimente para a o CONTAHIGH
       cjne		a,#high(480),difw  ;se high for igual, compara com low
	   mov		a,CONTALOW
	   cjne		a,#low(480),difw
	   jmp		zeracontador 	   ;se high e low são iguais a 480, vai para zeracontador  
difw:  jc		jmpencontro        ;se o high ou low forem menores que 480 
jmpencontro: 
	   jmp		encontro1x	
zeracontador: 
       mov  	CONTALOW,#0
	   mov  	CONTAHIGH,#0
;-----------------------------------------------------------------------
;**********AJUSTE********************
vol:          jnb chaveseg, ajuste  ;se chaveseg estiver ativa, salta pra ajuste
              jnb chavemin, ajuste  ;se chavemin estiver ativa, salta pra ajuste
			  jnb chavehor, ajuste  ;se chavehora estiver ativa, salta pra ajuste
              jnb chavedia, ajuste  ;se chavedia estiver ativa, salta pra ajuste
              jnb chavemes, ajuste  ;se chavemes estiver ativa, salta pra ajuste
              jnb chaveano, ajuste  ;se chaveano estiver ativa, salta pra ajuste
              jmp incc

ajuste:  jnb 	chaveseg, zeraseg   ;se chaveseg estiver ativa, salta pra zeraseg
         jnb 	chavemin, conMIN    ;se chavemin estiver ativa, salta pra conMIN
		 jnb	chavehor, conHORA   ;se chavehor estiver ativa, salta pra conHORA
		 jnb 	chavedia, conDIA    ;se chavedia estiver ativa, salta pra contDIA
         jnb 	chavemes, conMES    ;se chavemes estiver ativa, salta pra contMES
		 jnb	chaveano, conANO    ;se chaveano estiver ativa, salta pra contANO
		 jmp	incc
          
zeraseg: mov SEGS,#0      ; movimente para SEGS 0
         jmp volta

conMIN: 
		inc		MIN		  ; MIN = MIN + 1
		mov		a,MIN
		cjne	a,#60,sai ;se a!=60 salta pra sai, se a=60 segue pra MIN
		mov 	MIN, #0	  ;zera minuto
		jmp		volta
conHORA:
		inc		HORA     ; HORA = HORA + 1
		mov		a,HORA
		cjne	a,#24,sai ;se a!=24 salta pra sai, se a=24 segue pra HORA
		mov 	HORA, #0  ;zera hora
		jmp		volta
conDIA:
		inc		DIA		 	;DIA = DIA+1
		mov		a,DIA
		cjne	a,#32,sai	;se a!=32 salta pra sai, se a=32 segue pra DIA
		mov 	DIA, #1	  
		jmp		volta
conMES:
		inc		MES		 	;MES=MES+1
		mov		a,MES
		cjne	a,#13,sai 	;se a!=13 salta pra sai, se a=13 segue pra MES
		mov 	MES, #1		;volta para janeiro
		jmp		volta
conANO:
		inc		ANO		 	;ANO = ANO+1
		mov		a,ANO
		cjne	a,#50,sai 	;se a!=50 salta pra sai, se a=50 segue pra ANO
		mov 	ANO, #1		;volta para 2001
		jmp		volta
sai:
		jmp		volta
;-----------------------------------------------------------------------
;*************CONTAGEM DO RELOGIO*********************
incc:	inc		SEGS	   	; contador segundos = SEGS + 1
		mov		a,SEGS
		cjne	a,#60,dif	;salta se a!=60
		jmp		zeraSEGS 	; segundos = 60
		
dif:	jc	encontro1x  ; a < 60

zeraSEGS:	mov		SEGS,#0	 ; a > 60
			inc		MIN		 ; MIN = MIN + 1
			mov		a,MIN
			cjne	a,#60,dif2
			jmp		zeraMINUTO   ; minutos = 60
	
dif2:		jc		encontro1x  ; minutos < 60

zeraMINUTO:	mov		MIN,#0	 ; minuto > 60
			inc		HORA	 ; HORA = HORA + 1
			mov		a,HORA
			cjne	a,#24,dif3
			jmp		zeraHORA   ; A =  60
	
encontro1x:	jmp	encontro1	
	
dif3:	jc	encontro1x  ; A < 60

zeraHORA:	mov		HORA,#0	 ;a > 24
			inc		DIA
			mov		a,MES
			cjne	a,#1,difjan
			jmp		mes31
			
difjan:	cjne	a,#2,diffev
		jmp		fev
		
diffev:	cjne	a,#3,difmar
		jmp		mes31
		
difmar:	cjne	a,#4,difabr
		jmp		mes30
	
difabr:	cjne	a,#5,difmai
		jmp		mes31
	
difmai:	cjne	a,#6,difjun
		jmp		mes30
	
difjun:	cjne	a,#7,difjul
		jmp		mes31
	
difjul:	cjne	a,#8,difago
		jmp		mes31
		
difago:	cjne	a,#9,difset
		jmp		mes30
	
difset:	cjne	a,#10,difout
		jmp		mes31
	
difout:	cjne	a,#11,difnov
		jmp		mes30
	
difnov:	cjne	a,#12,encontro1
		mov		a,DIA
		cjne	a,#31,dif31
		jmp		encontro1
		
dif31:	jc		encontro1
		mov		DIA,#1
		mov		MES,#1
		inc		ANO
		mov		a,ANO
		cjne	a,#99,dif99
		jmp		encontro1
		
dif99:	jc		encontro1
		mov		ANO,#0
		jmp		encontro1
	
mes30:	mov		a,DIA
		cjne	a,#30,dif30
		jmp		encontro1
	
dif30:	jc		encontro1
		mov		DIA,#1
		INC		MES
		jmp		encontro1	

mes31:	mov		a,DIA
		cjne	a,#31,dif31x
		jmp		encontro1
		
dif31x:	jc		encontro1
		mov		DIA,#1
		INC		MES
		jmp		encontro1

fev:	mov		a,ANO
		mov		b,#4
		div		ab	; resto fica em b
		mov		a,b
		jz		anobissexto  ; salta se a == 0
		mov		a,DIA
		cjne	a,#28,dif28
		jmp		encontro1
		
dif28:	jc		encontro1
		mov		DIA,#1
		INC		MES
		jmp		encontro1		
		
anobissexto:
		mov		a,DIA
		cjne	a,#29,dif29
		jmp		encontro1
		
dif29:	jc		encontro1
		mov		DIA,#1
		INC		MES
		jmp		encontro1
;------------------------------------------------------------------
;**********CODIGO DIA DA SEMANA - ALGORITMO DE ZELLER**************
encontro1:
year:
	mov 	a, ANO
	mov 	b, #100
	div 	ab
	mov 	R0, #20	;seculo J
	mov 	R1, b 	;ano k
mes13:
	mov 	a, MES
	cjne 	a,#1, mes14	; a!=1 salta para fev
	mov		a, MES
	mov 	b, #11
	add 	a,b 
	mov 	R2, a	;mes novo 
	mov 	a, R1	;ano
	subb 	a,#1	;ano-1
	mov 	R1, a
	jmp 	day
	
mes14: 
	mov		a, MES
	cjne 	a, #2, mes9
	mov		a, MES
	mov 	b, #14
	add 	a,b 
	mov 	R2, a	;mes modificado
	mov 	a, R1	;ano
	subb 	a,#1	;ano-1
	mov 	R1, a 	;ano modificado
	jmp 	day

mes9:
	mov 	a, MES
	cjne 	a, #9,mes10
	mov 	a, #26 		; [(9+1)26]/10
	mov 	R5, a 
	jmp		calculo1
	
mes10:
	mov 	a, MES
	cjne 	a, #10,mes11
	mov		a, #6
	mov 	b, #10
	div 	ab
	mov		b, #28
	add		a,b
	mov 	R5, a
	jmp		calculo1
	
mes11:
	mov 	a, MES
	cjne 	a, #11,mes12
	mov		a, #2
	mov 	b, #10
	div 	ab
	mov		b, #31
	add		a,b
	mov 	R5, a
	jmp		calculo1
mes12:
	mov 	a, MES
	cjne 	a, #12,mees
	mov		a, #8
	mov 	b, #10
	div 	ab
	mov		b, #33
	add		a,b
	mov 	R5, a
	jmp		calculo1
mees:
	mov 	R2, MES
	mov 	R1, ANO

day: 
	mov 	a,R2	;mes
	inc 	a		;adiciona 1
	mov 	b,#26
	mul 	ab		;(m+1)*26
	mov 	b,#10
	div 	ab		;[(m+1)*26]/10
	mov 	R5, a
calculo1:	
	mov		a, R5
	mov 	b, DIA
	add 	a,b 	;([(mes+1)*26]/10)+ dia
	mov 	b, 	R1	; ano
	add		a,b		;([(mes+1)*26]/10)+ dia + ano 
	mov 	R4, a	;

	mov 	a, R1	;ano
	mov 	b, #4	
	div		ab		;k/4
	mov 	b, R4
	add 	a,b 	;([(mes+1)*26]/10)+ dia + ano + (k/4)
	mov 	R3, a 

	mov 	a, R0	;seculo
	mov 	b, #4
	div 	ab		;J/4
	mov 	b, R3
	add		a,b		;([(mes+1)*26]/10)+ dia + ano + (k/4)+(j/4)
	mov 	R3, a 

	mov 	a, R0	;seculo
	mov 	b, #5
	mul 	ab		;j*5
	mov 	b, R3
	add 	a,b 	;([(mes+1)*26]/10)+ dia + ano + (k/4)+(j/4)+(5*j)
	mov 	b, #7 	;modulo 7
	div 	ab
	mov 	R7, b	; dia da semana de 0-6
	
	jmp		 displaay

dias:
cjne 		R7,#0,difsab
	mov 	COD7,#092h  
	mov 	COD6,#088h  
	mov 	COD5,#083h  
	mov		COD4,#0FFh
	mov		COD3,#0FFh
	mov		COD2,#0FFh
	mov		COD1,#0FFh
	mov		COD0,#0FFh
difsab:
cjne 		R7, #1,difdom
	mov		COD7,#0A1h
	mov 	COD6,#0C0h
	mov 	COD5,#0C8h
	mov		COD4,#0FFh
	mov		COD3,#0FFh
	mov		COD2,#0FFh
	mov		COD1,#0FFh
	mov		COD0,#0FFh
difdom:
cjne		R7,#2,difseg
	mov		COD7,#092h
	mov		COD6,#086h
	mov 	COD5,#0C2h
	mov		COD4,#0FFh
	mov		COD3,#0FFh
	mov		COD2,#0FFh
	mov		COD1,#0FFh
	mov		COD0,#0FFh
difseg:
cjne 		R7,#3,difter
	mov 	COD7,#087h
	mov 	COD6,#086h
	mov 	COD5,#0CCh
	mov		COD4,#0FFh
	mov		COD3,#0FFh
	mov		COD2,#0FFh
	mov		COD1,#0FFh
	mov		COD0,#0FFh

difter:
cjne 		R7,#4,difqua
	mov 	COD7,#098h
	mov 	COD6,#0C1h
	mov 	COD5,#088h
	mov		COD4,#0FFh
	mov		COD3,#0FFh
	mov		COD2,#0FFh
	mov		COD1,#0FFh
	mov		COD0,#0FFh  	
difqua:
cjne 		R7,#5,difqui
	mov 	COD7,#098h	
	mov 	COD6,#0C1h
	mov 	COD5,#0CFh
	mov		COD4,#0FFh
	mov		COD3,#0FFh
	mov		COD2,#0FFh
	mov		COD1,#0FFh
	mov		COD0,#0FFh
difqui:
cjne 		R7,#6, saidaa
	mov 	COD7,#092h
	mov 	COD6,#086h
	mov 	COD5,#089h
	mov		COD4,#0FFh
	mov		COD3,#0FFh
	mov		COD2,#0FFh
	mov		COD1,#0FFh
	mov		COD0,#0FFh
saidaa: 
jmp 	displaay
; *****************************************************
; ***********CODIGOS PARA DISPLAY*********************
tabela:	db	0c0h	  ; 0 
		db	0f9h      ; 1 
		db	0a4h      ; 2 
		db	0b0h      ; 3 
		db	099h      ; 4 
		db	092h      ; 5 
		db	082h      ; 6 
		db	0f8h      ; 7 
		db	080h      ; 8 
		db	090h      ; 9 
		end
			
		
