.include "m8515def.inc"

.def temp  = r16
.def temp2 = r17
.def temp3 = r18

.def EINS = r10
.def NULL = r11
.def ALL = r12

.equ XTAL = 16000000
.equ F_CPU = 16000000                            ; Systemtakt in Hz
.equ BAUD  = 50000                               ; Baudrate

; Berechnungen
.equ UBRR_VAL   = ((F_CPU+BAUD*8)/(BAUD*16)-1)  ; clever runden
.equ BAUD_REAL  = (F_CPU/(16*(UBRR_VAL+1)))      ; Reale Baudrate
.equ BAUD_ERROR = ((BAUD_REAL*1000)/BAUD-1000)  ; Fehler in Promille
 
.if ((BAUD_ERROR>10) || (BAUD_ERROR<-10))       ; max. +/-10 Promille Fehler
  .error "Systematischer Fehler der Baudrate grösser 1 Prozent und damit zu hoch!"
.endif

.org 0x0000
rjmp reset
.org OC1Aaddr  
rjmp loop

.include "Sonstiges.asm"
.include "Warten.asm"
.include "Befehle.asm"
.include "Gamepad.asm"

reset:
ldi temp, 0
mov NULL, temp
ldi temp, 1
mov EINS, temp
ldi temp, 255
mov ALL, temp

sts AKTIV, NULL
sts AKTIV2, NULL
sts SCHEINWERFER, NULL

; Pins einstellen
ldi temp, LOW(RAMEND)
out SPL, temp
ldi temp, HIGH(RAMEND)
out SPH, temp

// Willkommen
LED_I led_an 
LED_II led_an
wait_ms 500
LED_I led_aus 
LED_II led_aus
wait_ms 500
LED_I led_an
LED_II led_an
wait_ms 500
LED_I led_aus 
LED_II led_aus
wait_ms 500

; Baudrate einstellen
 
    ldi     temp, HIGH(UBRR_VAL)
    out     UBRRH, temp
    ldi     temp, LOW(UBRR_VAL)
    out     UBRRL, temp

	  ;RS232 initialisieren
	ldi r16, LOW(UBRR_VAL)
	out UBRRL,r16
	ldi r16, HIGH(UBRR_VAL)
	out UBRRH,r16
	ldi r16, (1<<URSEL)|(3<<UCSZ0) ; Frame-Format: 8 Bit
	out UCSRC,r16
	sbi UCSRB, RXEN			; RX (Empfang) aktivieren
	sbi UCSRB, TXEN			; TX (Senden)  aktivieren

LED_I led_aus 
LED_II led_aus

//HALLO_BEFEHL befehl_senden
//SUPER_TASTE pruefe_taste, 0x00, 0x00
;Timer 1
 ldi     temp, high( 62745 - 1 )
        out     OCR1AH, temp
        ldi     temp, low( 62745 - 1 )
        out     OCR1AL, temp
		 ldi     temp, ( 1 << WGM12 ) | ( 1 << CS10 )
        out     TCCR1B, temp
 
        ldi     temp, 1 << OCIE1A  ; OCIE1A: Interrupt bei Timer Compare
        out     TIMSK, temp
sei
do: rjmp do

loop: 

// Tasten prüfen

// SUPER_TASTE pruefen (HALLO)
/*SUPER_TASTE pruefe_taste_gedrueckt, super_taste_gedrueckt, super_taste_nicht_gedrueckt
super_taste_gedrueckt:
HALLO_BEFEHL befehl_senden
sts AKTIV2, ALL
super_taste_nicht_gedrueckt:*/


// Scheinwerfer einstellen
L_ZWEI_TASTE pruefe_taste_unten, l_zwei_taste_unten, l_zwei_taste_nicht_unten
l_zwei_taste_unten:
SUPER_TASTE pruefe_taste_gedrueckt, super_taste_gedrueckt, l_zwei_taste_nicht_unten
super_taste_gedrueckt:
// Scheinwerfer toggle

lds temp, SCHEINWERFER
cpi temp,0
brne scheinwerfer_ausschalten
rjmp schweinwerfer_einschalten
scheinwerfer_ausschalten:
// alle Scheinwerfer ausschalten
sts SCHEINWERFER, NULL
LICHT_BEFEHL befehl_senden,1,0
wait_ms 100
LICHT_BEFEHL befehl_senden,2,0
wait_ms 100
LICHT_BEFEHL befehl_senden,3,0
wait_ms 100
LICHT_BEFEHL befehl_senden,4,0
wait_ms 100
LICHT_BEFEHL befehl_senden,5,0
wait_ms 100

rjmp scheinwerfer_schalten_ende
schweinwerfer_einschalten:
// alle Scheinwerfer einschalten
sts SCHEINWERFER, EINS
LICHT_BEFEHL befehl_senden, 1, 1
wait_ms 100
LICHT_BEFEHL befehl_senden, 2, 1
wait_ms 100
LICHT_BEFEHL befehl_senden, 3, 1
wait_ms 100
LICHT_BEFEHL befehl_senden, 4, 1
wait_ms 100
LICHT_BEFEHL befehl_senden, 5, 1
wait_ms 100
scheinwerfer_schalten_ende:
sts AKTIV2, ALL
rjmp ende_tasten
l_zwei_taste_nicht_unten:


// SUPER_TASTE pruefen (L)
SUPER_TASTE pruefe_taste_gedrueckt, super_taste_gedrueckt2, super_taste_nicht_gedrueckt2
super_taste_gedrueckt2:

L_BEFEHL befehl_senden, 1, 255, 255, 255
wait_ms 150
L_BEFEHL befehl_senden, 2, 255, 255, 255
wait_ms 150
L_BEFEHL befehl_senden, 3, 255, 255, 255
wait_ms 150
L_BEFEHL befehl_senden, 4, 255, 255, 255
wait_ms 150
L_BEFEHL befehl_senden, 5, 255, 255, 255
wait_ms 150

sts AKTIV2, ALL
rjmp ende_tasten
super_taste_nicht_gedrueckt2:


ende_tasten:
tasten_zustaende_aktualisieren

// Prüfen ob es in der letzten Zeit eine Aktivität gab
// Wurden Daten Empfangen, lassen wir die LED_I Leuchten
lds temp, AKTIV
cpi temp, 0
brne ist_aktiv
nicht_aktiv:
LED_I led_aus
rjmp over_aktiv
ist_aktiv:
dec temp
sts AKTIV, temp
LED_I led_an
over_aktiv:

// Prüfen ob es in der letzten Zeit eine Aktivität gab
// Wurden Daten Empfangen, lassen wir die LED_I Leuchten
lds temp, AKTIV2
cpi temp, 0
brne ist_aktiv2
nicht_aktiv2:
LED_II led_aus
rjmp over_aktiv2
ist_aktiv2:
dec temp
sts AKTIV2, temp
LED_II led_an
over_aktiv2:

; UART Empfangen
sbis     UCSRA, RXC                     
rjmp     no_char_receive
in       temp, UDR
sts AKTIV, ALL
no_char_receive:

reti 

.DSEG
AKTIV:        .BYTE 1
AKTIV2:        .BYTE 1

SCHEINWERFER: .BYTE 1
