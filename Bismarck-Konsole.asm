.include "m8515def.inc"

.def temp  = r16
.def temp2 = r17
.def temp3 = r18


.def temp4 = r19
.def temp5 = r20

.def INPUT = r8
.def INPUT2 = r9
.def INPUT3 = r7

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
  .error "Systematischer Fehler der Baudrate gr�sser 1 Prozent und damit zu hoch!"
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
; STACK einstellen
ldi temp, LOW(RAMEND)
out SPL, temp
ldi temp, HIGH(RAMEND)
out SPH, temp

ldi temp, 0
mov NULL, temp
ldi temp, 1
mov EINS, temp
ldi temp, 255
mov ALL, temp

sts AKTIV, NULL
sts AKTIV2, NULL
sts SCHEINWERFER, NULL
sts SCHEINWERFER_R, NULL
sts SCHEINWERFER_R+1, NULL
sts SCHEINWERFER_R+2, NULL

ausgaenge_reset

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

ldi temp, 18
ldi zl, low(TASTEN_ZUSTAENDE)
ldi zh, high(TASTEN_ZUSTAENDE)
ldi xl, low(TASTEN_ZUSTAENDE_TEMP)
ldi xh, high(TASTEN_ZUSTAENDE_TEMP)
nochmal:
st Z+, NULL
st X+, NULL
dec temp
brne nochmal

ldi temp, 15
ldi zl, low(BEFEHL_SPEICHER)
ldi zh, high(BEFEHL_SPEICHER)
nochmal2:
st Z+, NULL
dec temp
brne nochmal2

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

// Tasten pr�fen
tasten_zustaende_init

//LED_I led_aus
//LED_II led_aus

// Starttaste
START_TASTE pruefe_taste_gedrueckt, start_taste_gedrueckt, start_taste_nicht_gedrueckt
start_taste_gedrueckt:
ANTWORT_BEFEHL befehl_senden, 0
sts AKTIV2, ALL
rjmp ende_tasten
start_taste_nicht_gedrueckt:

// Scheinwerfer einstellen
.include "Scheinwerfer_einstellen.asm"
.include "Schornstein_einstellen.asm"
.include "Haupttuerme_einstellen.asm"

ende_tasten:
tasten_zustaende_aktualisieren

// Pr�fen ob es in der letzten Zeit eine Aktivit�t gab
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

// Pr�fen ob es in der letzten Zeit eine Aktivit�t gab
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
