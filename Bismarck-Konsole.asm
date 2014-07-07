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

// Tasten prüfen
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

/*L_ZWEI_TASTE pruefe_taste_gedrueckt, l_zwei_taste_gedrueckt, rechts_taste_nicht_gedrueckt
l_zwei_taste_gedrueckt:
EINS_TASTE pruefe_taste_gedrueckt, eins_taste_gedrueckt, rechts_taste_nicht_gedrueckt
eins_taste_gedrueckt:
RECHTS_TASTE pruefe_taste_gedrueckt, rechts_taste_gedrueckt,rechts_taste_nicht_gedrueckt 
rechts_taste_gedrueckt:
befehl_schreiben_init
befehl_in_speicher_schieben RECHTS_TASTE_TEXT
befehl_senden
rechts_taste_nicht_gedrueckt:*/

// Scheinwerfer einstellen
.include "Scheinwerfer_einstellen.asm"

/*EINS_TASTE pruefe_taste_gedrueckt, eins_taste_gedrueckt, eins_taste_nicht_gedrueckt
eins_taste_gedrueckt:
befehl_schreiben_init
befehl_in_speicher_schieben EINS_TASTE_TEXT
befehl_senden
eins_taste_nicht_gedrueckt:

ZWEI_TASTE pruefe_taste_gedrueckt, zwei_taste_gedrueckt, zwei_taste_nicht_gedrueckt
zwei_taste_gedrueckt:
befehl_schreiben_init
befehl_in_speicher_schieben ZWEI_TASTE_TEXT
befehl_senden
zwei_taste_nicht_gedrueckt:

DREI_TASTE pruefe_taste_gedrueckt, drei_taste_gedrueckt, drei_taste_nicht_gedrueckt
drei_taste_gedrueckt:
befehl_schreiben_init
befehl_in_speicher_schieben DREI_TASTE_TEXT
befehl_senden
drei_taste_nicht_gedrueckt:

VIER_TASTE pruefe_taste_gedrueckt, vier_taste_gedrueckt, vier_taste_nicht_gedrueckt
vier_taste_gedrueckt:
befehl_schreiben_init
befehl_in_speicher_schieben VIER_TASTE_TEXT
befehl_senden
vier_taste_nicht_gedrueckt:

L_EINS_TASTE pruefe_taste_gedrueckt, l_eins_taste_gedrueckt, l_eins_taste_nicht_gedrueckt
l_eins_taste_gedrueckt:
befehl_schreiben_init
befehl_in_speicher_schieben L_EINS_TASTE_TEXT
befehl_senden
l_eins_taste_nicht_gedrueckt:

L_ZWEI_TASTE pruefe_taste_gedrueckt, l_zwei_taste_gedrueckt, l_zwei_taste_nicht_gedrueckt
l_zwei_taste_gedrueckt:
befehl_schreiben_init
befehl_in_speicher_schieben L_ZWEI_TASTE_TEXT
befehl_senden
l_zwei_taste_nicht_gedrueckt:

R_EINS_TASTE pruefe_taste_gedrueckt, r_eins_taste_gedrueckt, r_eins_taste_nicht_gedrueckt
r_eins_taste_gedrueckt:
befehl_schreiben_init
befehl_in_speicher_schieben R_EINS_TASTE_TEXT
befehl_senden
r_eins_taste_nicht_gedrueckt:

R_ZWEI_TASTE pruefe_taste_gedrueckt, r_zwei_taste_gedrueckt, r_zwei_taste_nicht_gedrueckt
r_zwei_taste_gedrueckt:
befehl_schreiben_init
befehl_in_speicher_schieben R_ZWEI_TASTE_TEXT
befehl_senden
r_zwei_taste_nicht_gedrueckt:

HOCH_TASTE pruefe_taste_gedrueckt, hoch_taste_gedrueckt, hoch_taste_nicht_gedrueckt
hoch_taste_gedrueckt:
befehl_schreiben_init
befehl_in_speicher_schieben HOCH_TASTE_TEXT
befehl_senden
hoch_taste_nicht_gedrueckt:

RUNTER_TASTE pruefe_taste_gedrueckt, runter_taste_gedrueckt, runter_taste_nicht_gedrueckt
runter_taste_gedrueckt:
befehl_schreiben_init
befehl_in_speicher_schieben RUNTER_TASTE_TEXT
befehl_senden
runter_taste_nicht_gedrueckt:

LINKS_TASTE pruefe_taste_gedrueckt, links_taste_gedrueckt, links_taste_nicht_gedrueckt
links_taste_gedrueckt:
befehl_schreiben_init
befehl_in_speicher_schieben LINKS_TASTE_TEXT
befehl_senden
links_taste_nicht_gedrueckt:

RECHTS_TASTE pruefe_taste_gedrueckt, rechts_taste_gedrueckt, rechts_taste_nicht_gedrueckt
rechts_taste_gedrueckt:
befehl_schreiben_init
befehl_in_speicher_schieben RECHTS_TASTE_TEXT
befehl_senden
rechts_taste_nicht_gedrueckt:*/

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
