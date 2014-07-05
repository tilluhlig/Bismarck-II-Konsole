.CSEG

;#############################################
;############ schaltet LED ein ###############
;#############################################
;######## Bedarf: 08 Byte, 08 Takte ##########
;#############################################
.macro led_an
// Aufruf: outReg=@0, outPort=@1, outPin=@2, inReg=@3, inPort=@4, inPin=@5
// oder
// Aufruf: LED

    sbi @0,@2
    sbi @3,@5

    sbi @1,@2
    cbi @4,@5

.endm


;#############################################
;############ schaltet LED aus ###############
;#############################################
;######## Bedarf: 04 Byte, 04 Takte ##########
;#############################################
.macro led_aus
// Aufruf: outReg=@0, outPort=@1, outPin=@2, inReg=@3, inPort=@4, inPin=@5
// oder
// Aufruf: LED

    sbi @3,@5
    sbi @4,@5

.endm

;#############################################
;######### prueft, ob eine Taste #############
;################ unten ist ##################
;#############################################
;######## Bedarf: 24 Byte, 15 Takte ##########
;#############################################
.macro pruefe_taste_unten
// Aufruf: outPort=@0, outPin=@1, outReg=@2, inPort=@3, inPort2=@4, inPin=@5, inReg=@6, ID=@7, THEN=@8, ELSE=@9
// oder
// Aufruf: TASTE, THEN=@8, ELSE=@9

    // in als Eingang einstellen
    cbi @6,@5
    // Pull-Up Widerstand einschalten
    sbi @4,@5

    // out als Ausgang einstellen
    sbi @2, @1
    // Ausgang auf 0
    cbi @0, @1

    sbic @3, @5
    rjmp ist_nicht_unten
    ist_unten:
    sts TASTEN_ZUSTAENDE_TEMP+@7, EINS
    NOP
    rjmp @8
    
    ist_nicht_unten:
    sts TASTEN_ZUSTAENDE_TEMP+@7, NULL
    rjmp @9

.endm


;#############################################
;######### prueft, ob eine Taste #############
;################ oben ist ###################
;#############################################
;######## Bedarf: 24 Byte, 15 Takte ##########
;#############################################
.macro pruefe_taste_oben
// Aufruf: outPort=@0, outPin=@1, outReg=@2, inPort=@3, inPort2=@4, inPin=@5, inReg=@6, ID=@7, THEN=@8, ELSE=@9
// oder
// Aufruf: TASTE, THEN=@8, ELSE=@9

    // in als Eingang einstellen
    cbi @6,@5
    // Pull-Up Widerstand einschalten
    sbi @4,@5

    // out als Ausgang einstellen
    sbi @2, @1
    // Ausgang auf 0
    cbi @0, @1

    sbic @3, @5
    rjmp ist_nicht_unten
    ist_unten:
    sts TASTEN_ZUSTAENDE_TEMP+@7, EINS
    rjmp @9
    
    ist_nicht_unten:
    sts TASTEN_ZUSTAENDE_TEMP+@7, NULL
    rjmp @8
.endm


;#############################################
;######### prueft, ob eine Taste #############
;############ gedrueckt wurde ################
;#############################################
;######## Bedarf: 34 Byte, 21 Takte ##########
;#############################################
.macro pruefe_taste_gedrueckt
// Aufruf: outPort=@0, outPin=@1, outReg=@2, inPort=@3, inPort2=@4, inPin=@5, inReg=@6, ID=@7, THEN=@8, ELSE=@9
// oder
// Aufruf: TASTE, THEN=@8, ELSE=@9

    // in als Eingang einstellen
    cbi @6,@5
    // Pull-Up Widerstand einschalten
    sbi @4,@5

    // out als Ausgang einstellen
    sbi @2, @1
    // Ausgang auf 0
    cbi @0, @1  

    sbic @3, @5
    rjmp ist_nicht_unten
    ist_unten:
    sts TASTEN_ZUSTAENDE+@7, EINS
    lds temp, TASTEN_ZUSTAENDE_TEMP+@7
    cpi temp, 0
    brne ist_nicht_unten2

    NOP
    NOP
    NOP
    rjmp @8
    
    ist_nicht_unten:
    NOP
    NOP
    NOP

    ist_nicht_unten2:
    sts TASTEN_ZUSTAENDE_TEMP+@7, NULL
    rjmp @9

.endm

;#############################################
;########### aktualisierte die ###############
;############ Tastenzustaende ################
;#############################################
;######## Bedarf: 20 Byte, 130 Takte ##########
;#############################################
.macro tasten_zustaende_aktualisieren
ldi zl, low(TASTEN_ZUSTAENDE_TEMP)
ldi zh, high(TASTEN_ZUSTAENDE_TEMP)

ldi xl, low(TASTEN_ZUSTAENDE)
ldi xh, high(TASTEN_ZUSTAENDE)

ldi temp, 18
nochmal:
ld temp2, Z+
st X+, temp2

dec temp
brne nochmal

.endm
