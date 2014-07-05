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
;######## Bedarf: 30 Byte, 20 Takte ##########
;#############################################
.macro pruefe_taste_unten
// Aufruf: outPort=@0, outPin=@1, outReg=@2, inPort=@3, inPort2=@4, inPin=@5, inReg=@6, ID=@7, THEN=@8, ELSE=@9
// oder
// Aufruf: TASTE, THEN=@8, ELSE=@9

    ldi zh, high(TASTEN_ZUSTAENDE_TEMP)
    ldi zh, low(TASTEN_ZUSTAENDE_TEMP)
    ldi temp, @7
    add zl, temp
    adc zh, NULL

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
    st Z, EINS
    NOP
    rjmp @8
    
    ist_nicht_unten:
    st Z, NULL
    rjmp @9

.endm


;#############################################
;######### prueft, ob eine Taste #############
;################ oben ist ###################
;#############################################
;######## Bedarf: 30 Byte, 20 Takte ##########
;#############################################
.macro pruefe_taste_oben
// Aufruf: outPort=@0, outPin=@1, outReg=@2, inPort=@3, inPort2=@4, inPin=@5, inReg=@6, ID=@7, THEN=@8, ELSE=@9
// oder
// Aufruf: TASTE, THEN=@8, ELSE=@9

    ldi zh, high(TASTEN_ZUSTAENDE_TEMP)
    ldi zh, low(TASTEN_ZUSTAENDE_TEMP)
    ldi temp, @7
    add zl, temp
    adc zh, NULL

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
    st Z, EINS
    rjmp @9
    
    ist_nicht_unten:
    st Z, NULL
    rjmp @8
.endm
