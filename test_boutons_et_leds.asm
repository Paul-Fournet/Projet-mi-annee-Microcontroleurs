#include "p18f25k40.inc"


;RES_VECT CODE 0x0000
;    GOTO MAIN_CODE
    
MAIN_PROG CODE                      ; let linker place main program

START
    
       
    ;Programme permettant d'allumer les LEDs en fonction de l'appui sur les 4 boutons

    ;Configuration du registre TRISA (LEDs)
    CLRF TRISA
    
    ;Configuration du registre TRISB (boutons)
    MOVLW b'00011110'
    MOVWF TRISB
    
    ;Configuration du registre INTCON
    MOVLB 0xF
    MOVLW b'10000000'
    MOVWF INTCON
    
    ;Désactivation de l'entrée analogique sur le port B
    CLRF ANSELB
    
    ;Configuration du registre IOCBN (déclenchement sur front descendant du port B)
    MOVLW b'00011110'
    MOVWF IOCBN
    
    
    ;Configuration du registre PIE0
    MOVLB 0x0E
    MOVLW b'00010000'
    MOVWF PIE0
    MOVLB 0x00

    

    
    CLRF LATA
    
boucle:
    
    GOTO boucle
    
    

;Configuration des interruptions

ISR    CODE    0x0004
    RETFIE
    
ISRHV     CODE    0x0008
    GOTO    HIGH_ISR
    
HIGH_ISR
    MOVF PORTB, W   ; Lecture du port
    
    MOVLB 0x0E
    BTFSS PIR0, IOCIF
    RETFIE FAST
    
    MOVLB 0x0F
    
    BTFSC IOCBF,1
    GOTO down_minute

    BTFSC IOCBF,2
    GOTO down_heure

    BTFSC IOCBF,3
    GOTO up_heure

    BTFSC IOCBF,4
    GOTO up_minute

    GOTO fin_interrupt
    
down_minute:
    MOVLW b'00000001'
    MOVWF LATA
    BCF IOCBF,1
    GOTO fin_interrupt

down_heure:
    MOVLW b'00000011'
    MOVWF LATA
    BCF IOCBF,2
    GOTO fin_interrupt
    
up_heure:
    MOVLW b'00000111'
    MOVWF LATA
    BCF IOCBF,3
    GOTO fin_interrupt
    
up_minute:
    MOVLW b'00001111'
    MOVWF LATA
    BCF IOCBF,4
    GOTO fin_interrupt   
    
    
fin_interrupt:
    CLRF IOCBF ; Mise à 0 de tous les flags à la fin de l'interruption
    MOVLB 0x0E
    BCF PIR0, 4 ; Mise à 0 du flag indiquant une interruption "interrupt on change"
    MOVLB 0x00
    RETFIE FAST
  

    
        
    
    END
    
    