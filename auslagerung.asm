.CSEG
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
LICHT_BEFEHL befehl_senden,2,0
LICHT_BEFEHL befehl_senden,3,0
LICHT_BEFEHL befehl_senden,4,0
LICHT_BEFEHL befehl_senden,5,0

rjmp scheinwerfer_schalten_ende
schweinwerfer_einschalten:
// alle Scheinwerfer einschalten
sts SCHEINWERFER, EINS
LICHT_BEFEHL befehl_senden, 1, 1
LICHT_BEFEHL befehl_senden, 2, 1
LICHT_BEFEHL befehl_senden, 3, 1
LICHT_BEFEHL befehl_senden, 4, 1
LICHT_BEFEHL befehl_senden, 5, 1
scheinwerfer_schalten_ende:
sts AKTIV2, ALL
rjmp ende_tasten
l_zwei_taste_nicht_unten:


// EINS_TASTE pruefen (L)
EINS_TASTE pruefe_taste_gedrueckt, eins_taste_gedrueckt, eins_taste_nicht_gedrueckt
eins_taste_gedrueckt:

L_BEFEHL befehl_senden, 1, 255, 255, 255
L_BEFEHL befehl_senden, 2, 255, 255, 255
L_BEFEHL befehl_senden, 3, 255, 255, 255
L_BEFEHL befehl_senden, 4, 255, 255, 255
L_BEFEHL befehl_senden, 5, 255, 255, 255

sts AKTIV2, ALL
rjmp ende_tasten
eins_taste_nicht_gedrueckt:


// ZWEI_TASTE pruefen (L)
ZWEI_TASTE pruefe_taste_gedrueckt, zwei_taste_gedrueckt, zwei_taste_nicht_gedrueckt
zwei_taste_gedrueckt:

L_BEFEHL befehl_senden, 1, 255, 0, 0
L_BEFEHL befehl_senden, 2, 255, 0, 0
L_BEFEHL befehl_senden, 3, 255, 0, 0
L_BEFEHL befehl_senden, 4, 255, 0, 0
L_BEFEHL befehl_senden, 5, 255, 0, 0

sts AKTIV2, ALL
rjmp ende_tasten
zwei_taste_nicht_gedrueckt:


// DREI_TASTE pruefen (L)
DREI_TASTE pruefe_taste_gedrueckt, drei_taste_gedrueckt, drei_taste_nicht_gedrueckt
drei_taste_gedrueckt:

L_BEFEHL befehl_senden, 1, 0, 255, 0
L_BEFEHL befehl_senden, 2, 0, 255, 0
L_BEFEHL befehl_senden, 3, 0, 255, 0
L_BEFEHL befehl_senden, 4, 0, 255, 0
L_BEFEHL befehl_senden, 5, 0, 255, 0

sts AKTIV2, ALL
rjmp ende_tasten
drei_taste_nicht_gedrueckt:


// VIER_TASTE pruefen (L)
VIER_TASTE pruefe_taste_gedrueckt, vier_taste_gedrueckt, vier_taste_nicht_gedrueckt
vier_taste_gedrueckt:

L_BEFEHL befehl_senden, 1, 0, 0, 255
L_BEFEHL befehl_senden, 2, 0, 0, 255
L_BEFEHL befehl_senden, 3, 0, 0, 255
L_BEFEHL befehl_senden, 4, 0, 0, 255
L_BEFEHL befehl_senden, 5, 0, 0, 255

sts AKTIV2, ALL
rjmp ende_tasten
vier_taste_nicht_gedrueckt:

.DSEG
SCHEINWERFER: .BYTE 1

.CSEG
