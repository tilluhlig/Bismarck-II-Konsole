.CSEG

;#############################################
;######## einen Befehl als aktuellen #########
;############## Befehl markieren #############
;#############################################
;############ Bedarf: 32 Byte,  ##############
;###### 10+(count(befehl)+1)*10 Takte #########
;#############################################
.macro befehl_in_speicher_schieben // befehl=@0
ldi zh, high(2*@0)
ldi zl, low(2*@0)
rcall befehl_in_speicher_schieben_call
.endm

befehl_in_speicher_schieben_call:
ldi xh, high(BEFEHL_SPEICHER)
ldi xl, low(BEFEHL_SPEICHER)
mov temp2, NULL

lesen:
lpm temp, Z+
cpi temp, 0
breq end_lesen
inc temp2
st X+, temp
rjmp lesen
end_lesen:
NOP
NOP
NOP
NOP

lds temp, BEFEHL_SCHREIBPOSITION
add temp, temp2
sts BEFEHL_SCHREIBPOSITION, temp
ret


;#############################################
;###### aktuellen Befehl initialisieren ######
;#############################################
;######## Bedarf: 04 Byte, 02 Takte ##########
;#############################################
.macro befehl_schreiben_init
sts BEFEHL_SCHREIBPOSITION, NULL
.endm


;#############################################
;##### aktuellen Befehl mit Leerzeichen ######
;################# auffuellen ################
;#############################################
;### Bedarf: 28 Byte, 08+(anz+1)*9 Takte #####
;#############################################
.macro befehl_auffuellen
rcall befehl_auffuellen2
.endm

befehl_auffuellen2:
lds temp, BEFEHL_SCHREIBPOSITION
ldi xh, high(BEFEHL_SPEICHER)
ldi xl, low(BEFEHL_SPEICHER)
add xl, temp
adc xh, NULL

schreiben:
cpi temp, 15
brsh end_schreiben
ldi temp2, ' '
st X+, temp2
inc temp
NOP
rjmp schreiben
end_schreiben:
NOP
NOP
NOP
NOP
NOP
NOP

sts BEFEHL_SCHREIBPOSITION, temp
ret


;#############################################
;######### aktuellen Befehl absenden #########
;#############################################
;###### Bedarf: 20 Byte, 137+INF Takte #######
;#############################################
.macro befehl_senden
rcall befehl_senden2
.endm

befehl_senden2:
ldi xh, high(BEFEHL_SPEICHER)
ldi xl, low(BEFEHL_SPEICHER)
ldi temp,0
lds temp3, BEFEHL_SCHREIBPOSITION

senden:
ld temp2, X+

cp temp, temp3
brlo ist_belegt
ldi temp2, ' '
ist_belegt:

; UART senden
warten:
sbis    UCSRA,UDRE
rjmp    warten
out     UDR, temp2

inc temp
cpi temp, 15
brne senden
over_senden:
wait_ms 3
ret

.macro uart_send; zeichen=@0
warten:
sbis    UCSRA,UDRE
rjmp    warten
ldi temp, @0
out     UDR, temp
.endm


;#############################################
;######### Leerzeichen an aktuellen ##########
;############## Befehl anhaengen #############
;#############################################
;############# Bedarf: 34 Byte, ##############
;########## 9+(anzahl+1)*11 Takte ############
;#############################################
.macro befehl_leerzeichen // anzahl=@0
ldi temp3, @0
rcall befehl_leerzeichen_call
.endm

befehl_leerzeichen_call:
lds temp, BEFEHL_SCHREIBPOSITION
ldi xh, high(BEFEHL_SPEICHER)
ldi xl, low(BEFEHL_SPEICHER)
add xl, temp
adc xh, NULL

schreiben4:
cpi temp, 15
brsh end_schreiben3
cpi temp3, 0
breq end_schreiben4
dec temp3

ldi temp2,' '
st X+, temp2
inc temp
rjmp schreiben4
end_schreiben3:
NOP
NOP

end_schreiben4:
NOP
NOP
NOP
NOP
NOP
NOP

sts BEFEHL_SCHREIBPOSITION, temp
ret


;#############################################
;########### Zeichen an aktuellen ############
;############## Befehl anhaengen #############
;#############################################
;############# Bedarf: 00 Byte, ##############
;################# 00 Takte ##################
;#############################################
.macro befehl_zeichen // zeichen=@0
ldi temp, @0
rcall befehl_zeichen_call
.endm


;#############################################
;########### Zeichen an aktuellen ############
;############## Befehl anhaengen #############
;#############################################
;############# Bedarf: 00 Byte, ##############
;################# 00 Takte ##################
;#############################################
befehl_zeichen_call: // temp=zeichen
mov temp2, temp

lds temp, BEFEHL_SCHREIBPOSITION
ldi xh, high(BEFEHL_SPEICHER)
ldi xl, low(BEFEHL_SPEICHER)
add xl, temp
adc xh, NULL

cpi temp, 15
brsh end_schreiben2

st X+, temp2
inc temp
end_schreiben2:
sts BEFEHL_SCHREIBPOSITION, temp
ret


;#############################################
;######## Aktion für HALLO auslösen ##########
;#############################################
;############# Bedarf: 64+@0 Byte ############
;############## , 155+@0 Takte ###############
;#############################################
.macro HALLO_BEFEHL ; Befehlsmakro=@0
befehl_schreiben_init
befehl_in_speicher_schieben HALLO_TEXT
///befehl_auffuellen
@0
.endm


;#############################################
;######## Aktion für LICHT auslösen ##########
;#############################################
;############# Bedarf: 20+@0 Byte ############
;############## , 000+@0 Takte ###############
;#############################################
.macro LICHT_BEFEHL ; Befehlsmakro=@0, Scheinwerfer=@1, Zustand=@2
befehl_schreiben_init
befehl_in_speicher_schieben LICHT_TEXT
befehl_zeichen 48+@1
befehl_zeichen ' '
befehl_zeichen 48+@2
///befehl_auffuellen
@0
.endm

LICHT_alle_scheinwerfer_aus:
LICHT_BEFEHL befehl_senden,1,0
LICHT_BEFEHL befehl_senden,2,0
LICHT_BEFEHL befehl_senden,3,0
LICHT_BEFEHL befehl_senden,4,0
LICHT_BEFEHL befehl_senden,5,0
ret

LICHT_alle_scheinwerfer_an:
LICHT_BEFEHL befehl_senden,1,1
LICHT_BEFEHL befehl_senden,2,1
LICHT_BEFEHL befehl_senden,3,1
LICHT_BEFEHL befehl_senden,4,1
LICHT_BEFEHL befehl_senden,5,1
ret

;#############################################
;######## Aktion für L auslösen ##########
;#############################################
;############# Bedarf: 82+@0 Byte ############
;############## , 000+@0 Takte ###############
;#############################################
.macro L_BEFEHL_REGISTER ; Befehlsmakro=@0, Scheinwerfer=@1, Rot=INPUT, Gruen=INPUT2, Blau=INPUT3
befehl_schreiben_init
befehl_in_speicher_schieben L_TEXT
befehl_zeichen 48+@1
befehl_zeichen ' '
push INPUT
rcall ZAHL_3BYTE_CALL
mov INPUT, INPUT2
rcall ZAHL_3BYTE_CALL
mov INPUT, INPUT3
rcall ZAHL_3BYTE_CALL
///befehl_auffuellen
pop INPUT
@0
.endm

.macro L_BEFEHL ; Befehlsmakro=@0, Scheinwerfer=@1, Rot=@2, Gruen=@3, Blau=@4
ldi temp, @2
mov INPUT, temp
ldi temp, @3
mov INPUT2, temp
ldi temp, @4
mov INPUT3, temp
L_BEFEHL_REGISTER @0,@1
.endm

L_alle_scheinwerfer:
L_BEFEHL_REGISTER befehl_senden, 1
L_BEFEHL_REGISTER befehl_senden, 2
L_BEFEHL_REGISTER befehl_senden, 3
L_BEFEHL_REGISTER befehl_senden, 4
L_BEFEHL_REGISTER befehl_senden, 5
ret


;#############################################
;####### Aktion für LICHTR auslösen ##########
;#############################################
;############# Bedarf: 52+@0 Byte ############
;############## , 000+@0 Takte ###############
;#############################################
.macro LICHTR_BEFEHL_REGISTER; Befehlsmakro=@0, Scheinwerfer=@1, Rot=INPUT
befehl_schreiben_init
befehl_in_speicher_schieben LICHTR_TEXT
befehl_zeichen 48+@1
befehl_zeichen ' '
rcall ZAHL_3BYTE_CALL
///befehl_auffuellen
@0
.endm

.macro LICHTR_BEFEHL ; Befehlsmakro=@0, Scheinwerfer=@1, Rot=@2
ldi temp, @2
mov INPUT, temp
LICHTR_BEFEHL_REGISTER @0, @1
.endm

LICHTR_alle_scheinwerfer:
LICHTR_BEFEHL_REGISTER befehl_senden, 1
LICHTR_BEFEHL_REGISTER befehl_senden, 2
LICHTR_BEFEHL_REGISTER befehl_senden, 3
LICHTR_BEFEHL_REGISTER befehl_senden, 4
LICHTR_BEFEHL_REGISTER befehl_senden, 5
ret

;#############################################
;####### Aktion für LICHTG auslösen ##########
;#############################################
;############# Bedarf: 52+@0 Byte ############
;############## , 000+@0 Takte ###############
;#############################################
.macro LICHTG_BEFEHL_REGISTER; Befehlsmakro=@0, Scheinwerfer=@1, Gruen=INPUT
befehl_schreiben_init
befehl_in_speicher_schieben LICHTG_TEXT
befehl_zeichen 48+@1
befehl_zeichen ' '
rcall ZAHL_3BYTE_CALL
///befehl_auffuellen
@0
.endm

.macro LICHTG_BEFEHL ; Befehlsmakro=@0, Scheinwerfer=@1, Gruen=@2
ldi temp, @2
mov INPUT, temp
LICHTG_BEFEHL_REGISTER @0, @1
.endm

LICHTG_alle_scheinwerfer:
LICHTG_BEFEHL_REGISTER befehl_senden, 1
LICHTG_BEFEHL_REGISTER befehl_senden, 2
LICHTG_BEFEHL_REGISTER befehl_senden, 3
LICHTG_BEFEHL_REGISTER befehl_senden, 4
LICHTG_BEFEHL_REGISTER befehl_senden, 5
ret

;#############################################
;####### Aktion für LICHTB auslösen ##########
;#############################################
;############# Bedarf: 52+@0 Byte ############
;############## , 000+@0 Takte ###############
;#############################################
.macro LICHTB_BEFEHL_REGISTER; Befehlsmakro=@0, Scheinwerfer=@1, Blau=INPUT
befehl_schreiben_init
befehl_in_speicher_schieben LICHTB_TEXT
befehl_zeichen 48+@1
befehl_zeichen ' '
rcall ZAHL_3BYTE_CALL
befehl_auffuellen
@0
.endm

.macro LICHTB_BEFEHL ; Befehlsmakro=@0, Scheinwerfer=@1, Blau=@2
ldi temp, @2
mov INPUT, temp
LICHTB_BEFEHL_REGISTER @0, @1
.endm

LICHTB_alle_scheinwerfer:
LICHTB_BEFEHL_REGISTER befehl_senden, 1
LICHTB_BEFEHL_REGISTER befehl_senden, 2
LICHTB_BEFEHL_REGISTER befehl_senden, 3
LICHTB_BEFEHL_REGISTER befehl_senden, 4
LICHTB_BEFEHL_REGISTER befehl_senden, 5
ret


.macro ANTWORT_BEFEHL ; Befehlsmakro=@0, Zustand=@1
befehl_schreiben_init
befehl_in_speicher_schieben ANTWORT_TEXT
befehl_zeichen 48+@1
///befehl_auffuellen
@0
.endm

ZAHL_3BYTE_CALL:
mov temp, INPUT
rcall BinZuAscii
lds temp, SonstigesAusgabe
rcall befehl_zeichen_call
lds temp, SonstigesAusgabe+1
rcall befehl_zeichen_call
lds temp, SonstigesAusgabe+2
rcall befehl_zeichen_call
ret


.DSEG
BEFEHL_SPEICHER:        .BYTE 15
BEFEHL_SCHREIBPOSITION:        .BYTE 1

.CSEG
