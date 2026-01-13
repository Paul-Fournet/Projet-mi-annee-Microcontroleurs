

; TODO Step #2 - Configuration Word Setup

#include "p18f25k40.inc"



; CONFIG1L

  CONFIG  FEXTOSC = OFF         ; External Oscillator mode Selection bits (EC (external clock) above 8 MHz; PFM set to high power)

  CONFIG  RSTOSC = HFINTOSC_64MHZ       ; Power-up default value for COSC bits (EXTOSC operating per FEXTOSC bits (device manufacturing default))





; CONFIG1H

  CONFIG  CLKOUTEN = ON       ; Clock Out Enable bit (CLKOUT function is disabled)

  CONFIG  CSWEN = ON            ; Clock Switch Enable bit (Writing to NOSC and NDIV is allowed)

  CONFIG  FCMEN = ON            ; Fail-Safe Clock Monitor Enable bit (Fail-Safe Clock Monitor enabled)



; CONFIG2L

  CONFIG  MCLRE = EXTMCLR       ; Master Clear Enable bit (If LVP = 0, MCLR pin is MCLR; If LVP = 1, RE3 pin function is MCLR )

  CONFIG  PWRTE = OFF           ; Power-up Timer Enable bit (Power up timer disabled)

  CONFIG  LPBOREN = OFF         ; Low-power BOR enable bit (ULPBOR disabled)

  CONFIG  BOREN = SBORDIS       ; Brown-out Reset Enable bits (Brown-out Reset enabled , SBOREN bit is ignored)



; CONFIG2H

  CONFIG  BORV = VBOR_2P45      ; Brown Out Reset Voltage selection bits (Brown-out Reset Voltage (VBOR) set to 2.45V)

  CONFIG  ZCD = OFF             ; ZCD Disable bit (ZCD disabled. ZCD can be enabled by setting the ZCDSEN bit of ZCDCON)

  CONFIG  PPS1WAY = ON          ; PPSLOCK bit One-Way Set Enable bit (PPSLOCK bit can be cleared and set only once; PPS registers remain locked after one clear/set cycle)

  CONFIG  STVREN = ON           ; Stack Full/Underflow Reset Enable bit (Stack full/underflow will cause Reset)

  CONFIG  DEBUG = OFF           ; Debugger Enable bit (Background debugger disabled)

  CONFIG  XINST = OFF           ; Extended Instruction Set Enable bit (Extended Instruction Set and Indexed Addressing Mode disabled)



; CONFIG3L

  CONFIG  WDTCPS = WDTCPS_31    ; WDT Period Select bits (Divider ratio 1:65536; software control of WDTPS)

  CONFIG  WDTE = OFF             ; WDT operating mode (WDT enabled regardless of sleep)



; CONFIG3H

  CONFIG  WDTCWS = WDTCWS_7     ; WDT Window Select bits (window always open (100%); software control; keyed access not required)

  CONFIG  WDTCCS = SC           ; WDT input clock selector (Software Control)



; CONFIG4L

  CONFIG  WRT0 = OFF            ; Write Protection Block 0 (Block 0 (000800-001FFFh) not write-protected)

  CONFIG  WRT1 = OFF            ; Write Protection Block 1 (Block 1 (002000-003FFFh) not write-protected)

  CONFIG  WRT2 = OFF            ; Write Protection Block 2 (Block 2 (004000-005FFFh) not write-protected)

  CONFIG  WRT3 = OFF            ; Write Protection Block 3 (Block 3 (006000-007FFFh) not write-protected)



; CONFIG4H

  CONFIG  WRTC = OFF            ; Configuration Register Write Protection bit (Configuration registers (300000-30000Bh) not write-protected)

  CONFIG  WRTB = OFF            ; Boot Block Write Protection bit (Boot Block (000000-0007FFh) not write-protected)

  CONFIG  WRTD = OFF            ; Data EEPROM Write Protection bit (Data EEPROM not write-protected)

  CONFIG  SCANE = ON            ; Scanner Enable bit (Scanner module is available for use, SCANMD bit can control the module)

  CONFIG  LVP = OFF              ; Low Voltage Programming Enable bit (Low voltage programming enabled. MCLR/VPP pin function is MCLR. MCLRE configuration bit is ignored)



; CONFIG5L

  CONFIG  CP = OFF              ; UserNVM Program Memory Code Protection bit (UserNVM code protection disabled)

  CONFIG  CPD = OFF             ; DataNVM Memory Code Protection bit (DataNVM code protection disabled)



; CONFIG5H



; CONFIG6L

  CONFIG  EBTR0 = OFF           ; Table Read Protection Block 0 (Block 0 (000800-001FFFh) not protected from table reads executed in other blocks)

  CONFIG  EBTR1 = OFF           ; Table Read Protection Block 1 (Block 1 (002000-003FFFh) not protected from table reads executed in other blocks)

  CONFIG  EBTR2 = OFF           ; Table Read Protection Block 2 (Block 2 (004000-005FFFh) not protected from table reads executed in other blocks)

  CONFIG  EBTR3 = OFF           ; Table Read Protection Block 3 (Block 3 (006000-007FFFh) not protected from table reads executed in other blocks)



; CONFIG6H

  CONFIG  EBTRB = OFF           ; Boot Block Table Read Protection bit (Boot Block (000000-0007FFh) not protected from table reads executed in other blocks)

;*******************************************************************************



; TODO INSERT CONFIG HERE



;*******************************************************************************
; --- VARIABLES (Access Bank) ---
    UDATA_ACS
V_VAL    RES 1   ; Valeur Vert (0-255)
R_VAL    RES 1   ; Valeur Rouge (0-255)
B_VAL    RES 1   ; Valeur Bleu (0-255)
TEMP_VAL RES 1   ; Octet en cours d'envoi
BIT_CTR  RES 1   ; Compteur de bits
  
TABLEAU_LEDS    RES d'36'   ; 12 LEDs * 3 octets = 36 octets
INDEX           RES 1       ; Variable pour compter les 36 octets

;RES_VECT CODE 0x0000
;    GOTO MAIN_CODE

MAIN_PROG CODE

; ==============================================================================
; ROUTINES WS2812B (Broche RC1)
; ==============================================================================

; Envoie l'octet dans WREG bit par bit sur RC1
SEND_BYTE:
    MOVWF   TEMP_VAL
    MOVLW   d'8'
    MOVWF   BIT_CTR
    
   
   
BIT_LOOP:
    RLCF    TEMP_VAL, f     ; Pousse le bit le plus haut dans le Carry
    BTFSC   STATUS, C       ; Si le bit est 1, on saute à SEND_1
    BRA     SEND_1	    ; sinon on saute à SEND_0
    
SEND_0:                     ; --- Signal BIT 0 ---
    BSF     LATC, 1         ; [1 cyc] RC1 = 1 (Début)
    NOP                     ; [1 cyc] Total haut : 5 cycles (312.5ns)
    NOP                     ; [1 cyc]
    NOP                     ; [1 cyc]
    BCF     LATC, 1         ; [1 cyc] RC1 = 0
    BRA     NEXT_BIT        ; [2 cyc] On attend le reste du temps au niveau bas

SEND_1:                     ; --- Signal BIT 1 ---
    BSF     LATC, 1         ; [1 cyc] RC1 = 1 (Début)
    NOP                     ; [1 cyc] Total haut : 10 cycles (625ns)
    NOP                     ; [1 cyc]
    NOP                     ; [1 cyc]
    NOP                     ; [1 cyc]
    NOP                     ; [1 cyc]
    NOP                     ; [1 cyc]
    NOP                     ; [1 cyc]
    NOP                     ; [1 cyc]
    BCF     LATC, 1         ; [1 cyc] RC1 = 0
    NOP                     ; [1 cyc] On attend un peu au niveau bas

NEXT_BIT:
    DECFSZ  BIT_CTR, f      ; Reste-t-il des bits ?
    BRA     BIT_LOOP	    ; Si oui alors on saute à BIT_LOOP, sinon on RETURN
    RETURN

; Envoie une couleur complète (Ordre : Vert, Rouge, Bleu)
SEND_RGB:
    MOVF    V_VAL, W
    CALL    SEND_BYTE
    MOVF    R_VAL, W
    CALL    SEND_BYTE
    MOVF    B_VAL, W
    CALL    SEND_BYTE 
    RETURN
; ==============================================================================
; ROUTINE DE FIN (RESET DES LEDS)
; ==============================================================================
ENVOI_FINAL:
    BCF     LATC, 1         ; On force la ligne à 0
    MOVLW   d'255'          ; On charge le compteur au max
    MOVWF   BIT_CTR         ; On réutilise BIT_CTR pour économiser de la RAM
    
BOUCLE_RESET:
    DECFSZ  BIT_CTR, f      ; Décrémente et saute si zéro (1 cycle)
    BRA     BOUCLE_RESET    ; Boucle (2 cycles)
    RETURN                  ; Fin de la validation
; ==============================================================================
; INITIALISATION
; ==============================================================================
MAIN_CODE:
    ; 1. Configuration des Ports
    MOVLB   0x0F            ; Banque 15 pour ANSEL/TRIS/LAT
    CLRF    ANSELC          ; PORTC en numérique
    BCF     TRISC, 1        ; RC1 en sortie
    BCF     LATC, 1         ; RC1 à 0 au repos
    
    
; ==============================================================================
; PROGRAMME Afficehr led 
    
AFFICHER_TOUT:
    ; Initialisation du pointeur du tableau
    LFSR    FSR0, TABLEAU_LEDS
    ; Initialisation du compteur 
    MOVLW d'36'	    ; 3 octets * 12 LEDs = 36
    MOVWF INDEX
    
    BOUCLE_LEDS:
    
    MOVF POSTINC0,W ; Charge l'octet pointé par FSR0 dans W, puis passe à l'adresse suivante (POSTINC)
    
    CALL SEND_BYTE   ; Envoie l'octet sur RC1
    
    DECFSZ  INDEX, f        ; Décrémente et saute si zéro
    BRA     BOUCLE_LEDS     ; Sinon, continue la boucle
    CALL    ENVOI_FINAL     ; Valide l'affichage sur le ruban
    RETURN
    
; ==============================================================================

; ==============================================================================
; PROGRAMME PRINCIPAL
; ==============================================================================
START_DISPLAY:
    ; LED 1 (Adresse TABLEAU_LEDS + 0, 1, 2)
    
    
    CALL AFFICHER_TOUT
    
    
   
    
    
    
   

    ; Signal RESET (> 50µs pour valider l'affichage)
    BCF     LATC, 1
    ; Attente avant la prochaine boucle
    
LOOP_FINAL:
    BRA     LOOP_FINAL
    END