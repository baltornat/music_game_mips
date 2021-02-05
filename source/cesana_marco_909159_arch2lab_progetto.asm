######## GIOCO MUSICALE, CESANA MARCO, 909159 ######## 
.data
	str1: .asciiz "Ciao! Ora metterò alla prova la tua memoria con un po' di suoni, pronto?\n"
	str2: .asciiz "Dovrai ripetere esattamente la sequenza di note che produco, se ci riuscirai aggiungerò una nota!" 
	str3: .asciiz "Inserisci 1/2/3 per facile/medio/difficile"
	str4: .asciiz "Complimenti hai battuto il record con un punteggio di: "
	str5: .asciiz "La tua avventura finisce qui!"
	str6: .asciiz "Per vincere dovrai indovinare 20 note"
	str7: .asciiz "Per vincere dovrai indovinare 35 note"
	str8: .asciiz "Per vincere dovrai indovinare 50 note"
	str9: .asciiz "Se è la prima volta che giochi premi SI"
	clear: .asciiz "\n\n\n\n\n\n\n\n\n\n\n\n\n\n"
	record: .asciiz "record.txt"
	buffer: .space 4
	zero: .asciiz "0"
.text
	.globl main
	.globl leggoArray	#procedura per leggere le note dall'array, contiene una procedura annidata (che riproduce sul display bitmap le note musicali)
	.globl caricaArray	#procedura per caricare le note nell'array (random ad ogni avvio)
main:
	#MESSAGGI INTRODUTTIVI
	li $v0, 55
	la $a0, str1
	li $a1, 1
	syscall
	li $v0, 55
	la $a0, str2
	li $a1, 1
	syscall
File:
	#CREAZIONE FILE
	li $v0, 50
	la $a0, str9
	syscall
	beq $a0, 0, CreaFile
	beq $a0, 1, Difficolta
	beq $a0, 2, File
CreaFile:
	#CREO IL FILE (SE NON ESISTE) E SCRIVO AL SUO INTERNO 0
	li $v0, 13
	la $a0, record
	li $a1, 1		#1 = write mode
	li $a2, 0		#non specificato
	syscall
	move $s6, $v0		#file descriptor
	#SCRIVO 0 NEL FILE
	li $v0, 15     
	move $a0, $s6      	#file descriptor 
	la $a1, zero     	
	li $a2, 3          	#numero massimo di caratteri da scrivere
	syscall     
	#CHIUDO IL FILE
	li $v0, 16
	move $a0, $s6		#file descriptor
	syscall
	j Difficolta
	#CHIEDO IL LIVELLO DI DIFFICOLTA' (FACILE/MEDIO/DIFFICILE)
Difficolta:
	li $v0, 51
	la $a0, str3
	syscall
	beq $a1, -3, Difficolta
	beq $a1, -2, Termine	#se premo annulla termina il programma
	#SALTO ALLA DIFFICOLTA' SELEZIONATA
	beq $a0, 1, Facile
	beq $a0, 2, Medio
	beq $a0, 3, Difficile
	bne $a0, 3, Difficolta	#se inserisco un numero non previsto, torno alla selezione della difficoltà
Facile:				#se Facile
	li $v0, 55 		
	la $a0, str6
	li $a1, 1
	syscall
	addi $t0, $zero, 20 	#carico in $t0 il numero di note massimo (20)
	li $v0, 9 		#allocazione dinamica dell'array
	mul $a0, $t0, 4 	#carico in $a0 la dimensione in byte dell'array da allocare
	syscall 		#indirizzo base in $v0
	move $a0, $t0 		#dimensione in $a0
	move $a1, $v0 		#indirizzo base in $a1
	li $a2, 3 		#numero di note possibili [0-3) DO RE MI
	move $s0, $a0 		#salvo dimensione
	move $s1, $a1 		#salvo indirizzo base
	jal caricaArray		#chiamo la procedura caricaArray
	#LEGGO LE NOTE DALL'ARRAY
	move $a0, $s0 		#dimensione in $a0
	move $a1, $s1 		#indirizzo base in $a1
	jal leggoArray		#chiamo la procedura leggoArray
	move $s0, $v0		#la procedura ha ritornato al main il controllo e il punteggio dell'utente
	j Termine 		#salta alla fine
Medio:				#se Medio
	li $v0, 55 		
	la $a0, str7
	li $a1, 1
	syscall
	addi $t0, $zero, 35 	#carico in $t0 il numero di note massimo 
	li $v0, 9 		#allocazione dinamica dell'array
	mul $a0, $t0, 4 	#carico in $a0 la dimensione in byte dell'array da allocare
	syscall 		#indirizzo base in $v0
	move $a0, $t0 		#dimensione in $a0
	move $a1, $v0 		#indirizzo base in $a1
	li $a2, 5 		#numero di note possibili [0-5) DO RE MI FA SOL
	move $s0, $a0		#salvo dimensione
	move $s1, $a1		#salvo indirizzo base
	jal caricaArray		#chiamo la procedura caricaArray
	#LEGGO LE NOTE DALL'ARRAY
	move $a0, $s0 		#dimensione in $a0
	move $a1, $s1 		#indirizzo base in $a1
	jal leggoArray		#chiamo la procedura leggoArray
	move $s0, $v0		#la procedura ha ritornato al main il controllo e il punteggio dell'utente
	j Termine 		#salta alla fine
Difficile:			#se Difficile
	li $v0, 55 
	la $a0, str8
	li $a1, 1
	syscall
	addi $t0, $zero, 50 	#carico in $t0 il numero di note massimo 
	li $v0, 9 		#allocazione dinamica dell'array
	mul $a0, $t0, 4 	#carico in $a0 la dimensione in byte dell'array da allocare
	syscall 		#indirizzo base in $v0
	move $a0, $t0 		#dimensione in $a0
	move $a1, $v0 		#indirizzo base in $a1
	li $a2, 7 		#numero di note possibili [0-7) DO RE MI FA SOL LA SI
	move $s0, $a0		#salvo dimensione
	move $s1, $a1		#salvo indirizzo base
	jal caricaArray		#chiamo la procedura caricaArray
	#LEGGO LE NOTE DALL'ARRAY
	move $a0, $s0 		#dimensione in $a0
	move $a1, $s1 		#indirizzo base in $a1
	jal leggoArray		#chiamo la procedura leggoArray
	move $s0, $v0		#la procedura ha ritornato al main il controllo e il punteggio dell'utente
Termine:
	#APRO IL FILE IN READING PER LEGGERE IL RECORD PRECEDENTE
	li $v0, 13
	la $a0, record
	li $a1, 0		#0 = read mode
	li $a2, 0		#non specificato
	syscall
	move $s6, $v0		#file descriptor
	#LEGGO IL CONTENUTO DEL FILE
	li $v0, 14
	move $a0, $s6		#file descriptor
	la $a1, buffer		#scrivo nel buffer il record letto dal file
	li $a2, 4		#numero di byte da leggere
	syscall
	#CHIUDO IL FILE
	li $v0, 16
	move $a0, $s6		#file descriptor
	syscall
	#CONTROLLO SE IL RECORD E' > DEL PUNTEGGIO OTTENUTO, SE LO E' SALTA A Perso
	la $t0, buffer
	lbu $t1, 0($t0)			#carico la prima cifra del record
	la $t2, ($s0)			
	lbu $t3, 0($t2)			#carico la prima cifra del punteggio dell'utente
	bgt $t1, $t3, Perso		#se il record è > del punteggio salta a Perso
	bgt $t3, $t1, NuovoRecord	#se il record è < del punteggio salta a NuovoRecord
	lbu $t1, 4($t0)			#altrimenti se record = punteggio carica la seconda cifra del record
	lbu $t3, 4($t2)			#altrimenti se record = punteggio carica la seconda cifra del punteggio
	bgt $t1, $t3, Perso		#se il record è > del punteggio salta a Perso
NuovoRecord:				#se il record è <= al punteggio NuovoRecord
	#STAMPO IL PUNTEGGIO DELL'UTENTE
	li $v0, 59
	la $a0, str4
	la $a1, ($s0)
	syscall
	#APRO IL FILE IN WRITING
	li $v0, 13
	la $a0, record
	li $a1, 1		#1 = write mode
	li $a2, 0		#non specificato
	syscall
	move $s6, $v0		#file descriptor
	#SCRIVO IL PUNTEGGIO DEL GIOCATORE
	li $v0, 15     
	move $a0, $s6      	#file descriptor 
	move $a1, $s0      	#indirizzo base dell'array del punteggio
	li $a2, 3          	#numero massimo di caratteri da scrivere
	syscall     
	#CHIUDO IL FILE
	li $v0, 16
	move $a0, $s6		#file descriptor
	syscall
Perso:
	li $v0, 55		#stampo messaggio per terminare
	la $a0, str5
	li $a1, 1
	syscall
	li $v0, 10		#syscall per terminare
	syscall
	###################################################
	# Input :					  #
	# a0 : numero di note che deve contenere l'array  #
	# a1 : indirizzo base dell'array                  #
	# a2 : numero di note possibili                   #
	# Output:					  #
	# ---------					  #
	###################################################
caricaArray:
	#CARICO L'ARRAY CON [$a0] NOTE RANDOM
	move $t0, $a0 		#dimensione
	move $t1, $a1 		#indirizzo base
	move $t2, $a2 		#numero di note possibili
	li $t4, 0 		# i = 0
	Carico:
	mul $t3, $t4, 4
	add $t3, $t3, $t1
	#GENERO UN NUMERO RANDOM COMPRESO TRA [0 e $t2)
	li $v0, 42
	move $a1, $t2 		#imposto come range [0-$t2)
	syscall
	#SOMMO 61 AL NUMERO GENERATO PER CREARE UNA NOTA NEL RANGE [61 - 6n]
	addi $a0, $a0, 61
	sw $a0, 0($t3) 		#carico il numero random alla posizione i dell'array
	addi $t4, $t4, 1 	# i = i + 1
	bne $t4, $t0, Carico	#se i è diverso dalla dimensione salto a Carico
	jr $ra			#restituisco il controllo al main
	###################################################
	# Input :                                         #
	# a0 : numero di note che contiene l'array        #
	# a1 : indirizzo base dell'array                  #
	# Output:                                         #
	# riproduce le note                               #
	# $v0 : l'indirizzo base dell'array del punteggio #
	###################################################
leggoArray:
	move $t0, $a0 		#dimensione
	move $t1, $a1 		#indirizzo base
	li $t2, 1 		# j = 1 perchè almeno una nota deve essere riprodotta
	Secondo:
	li $t3, 0 		# i = 0
	Primo:
	mul $t4, $t3, 4		#moltiplico i*4 e salvo in t4 per poter scorrere l'array
	add $t4, $t4, $t1 	#sommo a t4 l'indirizzo base dell'array
	#LEGGO LA NOTA ALLA POSIZIONE i DELL'ARRAY
	li $v0, 31		#carico l'indirizzo della syscall
	lw $a0, 0($t4) 		#leggo la nota alla posizione i dell'array
	move $t9, $a0		#salvo in $t9 la nota
	li $a1, 1500		#carico la durata in millisecondi come secondo argomento
	li $a2, 0		#carico lo strumento (0 = piano) come terzo argomento
	li $a3, 127		#carico il volumer (127 = alto) come quarto argomento
	syscall
	addi $sp, $sp, -4 	#salvo nello stack $ra siccome devo chiamare una procedura annidata
	sw $ra, 0($sp)
	move $a0, $t9		#passo alla procedura display la nota
	jal display		#stampo sul display bitmap la nota letta (la procedura si trova nel file "display.asm"
	lw $ra, 0($sp)		#ripristino il corretto valore di $ra dopo aver chiamato la procedura annidata
	addi $sp, $sp, 4
	li $v0, 32 		#aggiungo un delay di 2 secondi tra la riproduzione di una nota e la successiva
	li $a0, 2000		#2 secondi
	syscall
	addi $t3, $t3, 1 	# i = i + 1
	bne $t3, $t2, Primo 	#salto se i è diverso da j
	#LEGGO I CARATTERI DA TASTIERA
	li $t5, 0 		# k = 0 indice dei caratteri
	li $t3, 0 		# i = 0
	Caratteri:
	li $v0, 12       
  	syscall			#leggo il carattere
  	addi $v0, $v0, 12 	#aggiungo 12 al carattere letto per renderlo una nota (esempio 1: codice ascii = 49 -> +12 = 61 (prima nota)
	mul $t4, $t3, 4		#moltiplico i*4 e salvo in t4 per poter scorrere l'array
	add $t4, $t4, $t1 	#sommo a t4 l'indirizzo base dell'array
	lw $a0, 0($t4)  	#leggo la nota alla posizione i dell'array
  	bne $v0, $a0, Fine 	#se il carattere inserito è diverso dalla nota prodotta termino 
	addi $t5, $t5, 1 	# k = k + 1
	addi $t3, $t3, 1 	# i = i + 1
	bne $t5, $t2, Caratteri #salto se k è diverso da j (per leggere prima 1 carattere, poi 2, poi 3 etc etc)
	li $v0, 4
	la $a0, clear		#stampo degli spazi per nascondere gli input precedenti
	syscall
	li $v0, 32 		#aggiungo un delay per far ripartire le note dopo la pressione del tasto
	li $a0, 1500		#1.5 secondi
	syscall
	addi $t2, $t2, 1 	#j = j + 1
	bne $t2, $t0, Secondo 	#eseguo il ciclo più esterno fino a che j è uguale alla dimensione dell'array
Fine:
	#CARICO IL PUNTEGGIO IN UN ARRAY
	ble $t2, 9, UnaCifra 	#salta se j <= 9
	#ALLOCA MEMORIA PER 2 CHAR + \n
	li $v0, 9
	li $a0, 3   		#alloca 3 byte per 3 char
	syscall
	move $t4, $v0 		#carico in $t4 l'indirizzo base dell'array del punteggio
	addi $t4, $t4, 2    	#faccio puntare alla fine dell'array del punteggio
	li $t3, 10      	#carico il \n (10 ascii)
	sb $t3, 0($t4)
	addi $t4, $t4, -1
	#CARICO NELL'ARRAY IL NUMERO j AL CONTRARIO (CIFRA PER CIFRA)
	li $t5, 10 		#per fare la divisione per 10
	div $t2, $t5 		#divido j per 10 (per prendere l'ultima cifra)
	mfhi $t3 		#sposto il resto della divisione in $t3 (il resto è la cifra di valore minimo)
	addi $t3, $t3, 48 	#sommo 48 per assegnare un numero in ascii se resto = 1, 1 + 48 = 49 49, 49 in ascii è "1"
	sb $t3, 0($t4)		#salvo in $t3 il byte dell'ultima cifra
	addi $t4, $t4, -1  
	mflo $t3 		#metto il quoziente in $t3
	addi $t3, $t3, 48	#sommo 48 per assegnare un numero in ascii se resto = 1, 1 + 48 = 49 49, 49 in ascii è "1"
	sb $t3, 0($t4)		#salvo in $t3 il byte della prima cifra
	j Return		#salta a Return
UnaCifra:			#se il punteggio è compreso tra 0 e 9
	#ALLOCA MEMORIA PER 1 CHAR + \n
	li $v0, 9
	li $a0, 2   		#alloca 2 byte per 2 char
	syscall
	move $t4, $v0 		#carico in $t4 l'indirizzo base dell'array del punteggio
	addi $t4, $t4, 1 	#faccio puntare alla fine dell'array del punteggio
	li $t3, 10     		#carico il \n (10 ascii)
	sb $t3, 0($t4)		#salvo in $t3 il byte della cifra
	addi $t4, $t4, -1
	#CARICO NELL'ARRAY IL NUMERO j
	move $t3, $t2 		#copio j in $t3
	addi $t3, $t3, 48 	#carico nell'array il numero j al contrario (cifra per cifra)
	sb $t3, 0($t4)
Return:
	move $v0, $t4		#cairco in $v0 il parametro di ritorno della funzione (l'indirizzo base dell'array del punteggio)
	jr $ra			#restituisco il controllo al main
	
