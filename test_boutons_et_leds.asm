
; PIC18F25K40 Configuration Bit Settings

; Assembly source line config statements

#include "p18f25k40.inc"

; CONFIG1L
  CONFIG  FEXTOSC = OFF         ; External Oscillator mode Selection bits (EC (external clock) above 8 MHz; PFM set to high power)
  CONFIG  RSTOSC = EXTOSC       ; Power-up default value for COSC bits (EXTOSC operating per FEXTOSC bits (device manufacturing default))

; CONFIG1H
  CONFIG  CLKOUTEN = ON        ; Clock Out Enable bit (CLKOUT function is disabled)
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
  CONFIG  WDTE = OFF            ; WDT operating mode (WDT enabled regardless of sleep)

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


  

RES_VECT  CODE    0x0000            ; processor reset vector
    GOTO    START                   ; go to beginning of program



    
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
    GOTO appui_btn1

    BTFSC IOCBF,2
    GOTO appui_btn2

    BTFSC IOCBF,3
    GOTO appui_btn3

    BTFSC IOCBF,4
    GOTO appui_btn4

    GOTO fin_interrupt
    
appui_btn1:
    BCF IOCBF,1
    MOVLW b'00000001'
    MOVWF LATA
    GOTO fin_interrupt

appui_btn2:
    BCF IOCBF,2
    MOVLW b'00000011'
    MOVWF LATA
    GOTO fin_interrupt
    
appui_btn3:
    BCF IOCBF,3
    MOVLW b'00000111'
    MOVWF LATA
    GOTO fin_interrupt
    
appui_btn4:
    BCF IOCBF,4
    MOVLW b'00001111'
    MOVWF LATA
    GOTO fin_interrupt   
    
    
fin_interrupt:
    CLRF IOCBF ; Mise à 0 de tous les flags à la fin de l'interruption
    MOVLB 0x0E
    BCF PIR0, 4 ; Mise à 0 du flag indiquant une interruption "interrupt on change"
    MOVLB 0x00
    RETFIE FAST
  

    
        
    
    END
    
    