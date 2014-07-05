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

senden:
ld temp2, X+

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

schreiben2:
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
befehl_auffuellen
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
befehl_auffuellen
//@0
.endm


;#############################################
;######## Aktion für L auslösen ##########
;#############################################
;############# Bedarf: 82+@0 Byte ############
;############## , 000+@0 Takte ###############
;#############################################
.macro L_BEFEHL ; Befehlsmakro=@0, Scheinwerfer=@1, Rot=@2, Gruen=@3, Blau=@4
befehl_schreiben_init
befehl_in_speicher_schieben L_TEXT
befehl_zeichen 48+@1
befehl_zeichen ' '
ldi temp, @2
rcall BinZuAscii
lds temp, SonstigesAusgabe
rcall befehl_zeichen_call
lds temp, SonstigesAusgabe+1
rcall befehl_zeichen_call
lds temp, SonstigesAusgabe+2
rcall befehl_zeichen_call

ldi temp, @3
rcall BinZuAscii
lds temp, SonstigesAusgabe
rcall befehl_zeichen_call
lds temp, SonstigesAusgabe+1
rcall befehl_zeichen_call
lds temp, SonstigesAusgabe+2
rcall befehl_zeichen_call

ldi temp, @4
rcall BinZuAscii
lds temp, SonstigesAusgabe
rcall befehl_zeichen_call
lds temp, SonstigesAusgabe+1
rcall befehl_zeichen_call
lds temp, SonstigesAusgabe+2
rcall befehl_zeichen_call
befehl_auffuellen
@0
.endm


.DSEG
BEFEHL_SPEICHER:        .BYTE 15
BEFEHL_SCHREIBPOSITION:        .BYTE 1

.CSEG
