.CSEG
R_ZWEI_TASTE pruefe_taste_unten, r_zwei_taste_unten, r_zwei_taste_nicht_unten
r_zwei_taste_unten:

EINS_TASTE pruefe_taste_unten, eins_taste_unten, eins_taste_nicht_unten
eins_taste_unten:
ldi temp,0
rjmp zahl_unten
eins_taste_nicht_unten:

ZWEI_TASTE pruefe_taste_unten, zwei_taste_unten, zwei_taste_nicht_unten
zwei_taste_unten:
ldi temp,1
rjmp zahl_unten
zwei_taste_nicht_unten:

DREI_TASTE pruefe_taste_unten, drei_taste_unten, drei_taste_nicht_unten
drei_taste_unten:
ldi temp,2
rjmp zahl_unten
drei_taste_nicht_unten:

VIER_TASTE pruefe_taste_unten, vier_taste_unten, vier_taste_nicht_unten
vier_taste_unten:
ldi temp,3
rjmp zahl_unten
vier_taste_nicht_unten:

zahl_unten:
// hier ist 1-4 unten
mov temp4, temp

HOCH_TASTE pruefe_taste_gedrueckt, hoch_taste_gedrueckt, hoch_taste_nicht_gedrueckt
hoch_taste_gedrueckt:
// hoch taste gedrueckt
cpi temp4,3
brlo alle_farben_einzeln_einstellen 
rjmp alle_farben_einstellen
alle_farben_einzeln_einstellen:

// Rot, Gruen oder Blau einstellen
ldi zl, low(SCHEINWERFER_R)
ldi zh, high(SCHEINWERFER_R)
add zl, EINS
adc zh, NULL
ld temp, Z
ldi temp2, 15
add temp, temp2
brcc kein_ueberlauf
ldi temp, 255
kein_ueberlauf:
st Z, temp

cpi temp4,0
breq rot_einstellen
rjmp nicht_rot_einstellen
rot_einstellen:
mov INPUT, temp
LICHTR_BEFEHL_REGISTER befehl_senden, 1
LICHTR_BEFEHL_REGISTER befehl_senden, 2
LICHTR_BEFEHL_REGISTER befehl_senden, 3
LICHTR_BEFEHL_REGISTER befehl_senden, 4
LICHTR_BEFEHL_REGISTER befehl_senden, 5
rjmp ende_farbe_einstellen
nicht_rot_einstellen:

cpi temp4,1
breq gruen_einstellen
rjmp nicht_gruen_einstellen
gruen_einstellen:
mov INPUT, temp
LICHTG_BEFEHL_REGISTER befehl_senden, 1
LICHTG_BEFEHL_REGISTER befehl_senden, 2
LICHTG_BEFEHL_REGISTER befehl_senden, 3
LICHTG_BEFEHL_REGISTER befehl_senden, 4
LICHTG_BEFEHL_REGISTER befehl_senden, 5
rjmp ende_farbe_einstellen
nicht_gruen_einstellen:

cpi temp4,2
breq blau_einstellen
rjmp nicht_blau_einstellen
blau_einstellen:
mov INPUT, temp
LICHTB_BEFEHL_REGISTER befehl_senden, 1
LICHTB_BEFEHL_REGISTER befehl_senden, 2
LICHTB_BEFEHL_REGISTER befehl_senden, 3
LICHTB_BEFEHL_REGISTER befehl_senden, 4
LICHTB_BEFEHL_REGISTER befehl_senden, 5
rjmp ende_farbe_einstellen
nicht_blau_einstellen:

rjmp ende_farbe_einstellen
alle_farben_einstellen:
// alle farben einstellen

rjmp ende_farbe_einstellen

ende_farbe_einstellen:

sts AKTIV2, ALL
rjmp ende_tasten
hoch_taste_nicht_gedrueckt:


RUNTER_TASTE pruefe_taste_gedrueckt, runter_taste_gedrueckt, runter_taste_nicht_gedrueckt
runter_taste_gedrueckt:
// hoch taste gedrueckt
cpi temp4,3
brlo alle_farben_einzeln_einstellen2
rjmp alle_farben_einstellen2
alle_farben_einzeln_einstellen2:

// Rot, Gruen oder Blau einstellen
ldi zl, low(SCHEINWERFER_R)
ldi zh, high(SCHEINWERFER_R)
add zl, EINS
adc zh, NULL
ld temp, Z
ldi temp2, 15
add temp, temp2
brcc kein_ueberlauf2
ldi temp, 255
kein_ueberlauf2:
st Z, temp

cpi temp4,0
breq rot_einstellen2
rjmp nicht_rot_einstellen2
rot_einstellen2:
mov INPUT, temp
LICHTR_BEFEHL_REGISTER befehl_senden, 1
LICHTR_BEFEHL_REGISTER befehl_senden, 2
LICHTR_BEFEHL_REGISTER befehl_senden, 3
LICHTR_BEFEHL_REGISTER befehl_senden, 4
LICHTR_BEFEHL_REGISTER befehl_senden, 5
rjmp ende_farbe_einstellen2
nicht_rot_einstellen2:

cpi temp4,1
breq gruen_einstellen2
rjmp nicht_gruen_einstellen2
gruen_einstellen2:
mov INPUT, temp
LICHTG_BEFEHL_REGISTER befehl_senden, 1
LICHTG_BEFEHL_REGISTER befehl_senden, 2
LICHTG_BEFEHL_REGISTER befehl_senden, 3
LICHTG_BEFEHL_REGISTER befehl_senden, 4
LICHTG_BEFEHL_REGISTER befehl_senden, 5
rjmp ende_farbe_einstellen2
nicht_gruen_einstellen2:

cpi temp4,2
breq blau_einstellen2
rjmp nicht_blau_einstellen2
blau_einstellen2:
mov INPUT, temp
LICHTB_BEFEHL_REGISTER befehl_senden, 1
LICHTB_BEFEHL_REGISTER befehl_senden, 2
LICHTB_BEFEHL_REGISTER befehl_senden, 3
LICHTB_BEFEHL_REGISTER befehl_senden, 4
LICHTB_BEFEHL_REGISTER befehl_senden, 5
rjmp ende_farbe_einstellen2
nicht_blau_einstellen2:

rjmp ende_farbe_einstellen2
alle_farben_einstellen2:
// alle farben einstellen

rjmp ende_farbe_einstellen2

ende_farbe_einstellen2:

sts AKTIV2, ALL
rjmp ende_tasten
runter_taste_nicht_gedrueckt:


keine_zahl_unten:

SUPER_TASTE pruefe_taste_gedrueckt, super_taste_gedrueckt, r_zwei_taste_nicht_unten
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
LICHT_BEFEHL befehl_senden,2,0
LICHT_BEFEHL befehl_senden,3,0
LICHT_BEFEHL befehl_senden,4,0
LICHT_BEFEHL befehl_senden,5,0
sts AKTIV2, ALL
rjmp ende_tasten
rjmp scheinwerfer_schalten_ende
schweinwerfer_einschalten:
// alle Scheinwerfer einschalten
sts SCHEINWERFER, EINS
LICHT_BEFEHL befehl_senden, 1, 1
LICHT_BEFEHL befehl_senden, 2, 1
LICHT_BEFEHL befehl_senden, 3, 1
LICHT_BEFEHL befehl_senden, 4, 1
LICHT_BEFEHL befehl_senden, 5, 1
sts AKTIV2, ALL
rjmp ende_tasten
scheinwerfer_schalten_ende:
r_zwei_taste_nicht_unten:

.DSEG

SCHEINWERFER: .BYTE 1
SCHEINWERFER_R: .BYTE 1
SCHEINWERFER_G: .BYTE 1
SCHEINWERFER_B: .BYTE 1

.CSEG
