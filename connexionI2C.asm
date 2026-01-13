#include "p18f25k40.inc"
    
    
RES_VECT  CODE    0x0000            ; processor reset vector
    GOTO    START                   ; go to beginning of program

    
    
MAIN_PROG CODE                      ; let linker place main program


init_i2c:
    ;Association des broches au module I2C
    MOVLB 0x0E
    MOVLW 0xFA
    MOVWF RR3PPS,1
    
    MOVLW 0xFB
    MOVWF RR4PPS,1
    
    ;Configuration du registre de statut et effacement des flags
    MOVLW b'11000000'
    MOVWF SSP1STAT	
 
    
    ;Activation du module, réglage en mode Master 
    MOVLW b'00101000'
    MOVWF SSP1CON1  ; Registre de contrôle principal du module
     
    
    ;Réinitialisation du module
    MOVLW b'01000000'
    MOVWF SSP1CON2
    
    
    ;Désactivation des interruptions liées au module I2C
    MOVLW b'00000000' 
    MOVWF SSP1CON3
    
    
    ;Fixation de la fréquence de transmission des données à 400kHz
    
    ;(64*10^6)/(4*400*10^6)-1 = 39 = 100111 en binaire
    MOVLW b'00100111'
    MOVWF SSP1MSK
    
    RETURN 
 

START
    
    ;Tentative de communication avec le module I2C
    
    
    MOVLB 0x0F
    CLRF ANSELC	; Désactivation des entrées analogiques
    
    BSF TRISC,3	    ; SCL en entrée
    BSF TRISC,4	    ; SDA en entrée
    
    
    
    
    END