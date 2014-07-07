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

//	cbi @3,@5
//	cbi @4,@5

.endm

;#############################################
;######### prueft, ob eine Taste #############
;################ unten ist ##################
;#############################################
;######## Bedarf: 10 Byte, 00 Takte ##########
;#############################################
.macro pruefe_taste_unten
// Aufruf: reset=@0, outPort=@1, outPin=@2, outReg=@3, inPort=@4, inPort2=@5, inPin=@6, inReg=@7, ID=@8, THEN=@9, ELSE=@10
// oder
// Aufruf: TASTE, THEN=@9, ELSE=@10

    lds temp, TASTEN_ZUSTAENDE_TEMP+@8
    sbrs temp, 0
    rjmp @10
    rjmp @9

.endm


;#############################################
;######### prueft, ob eine Taste #############
;################ oben ist ###################
;#############################################
;######## Bedarf: 10 Byte, 00 Takte ##########
;#############################################
.macro pruefe_taste_oben
// Aufruf: reset=@0, outPort=@1, outPin=@2, outReg=@3, inPort=@4, inPort2=@5, inPin=@6, inReg=@7, ID=@8, THEN=@9, ELSE=@10
// oder
// Aufruf: TASTE, THEN=@9, ELSE=@10

    lds temp, TASTEN_ZUSTAENDE_TEMP+@8
    sbrs temp, 0
    rjmp @9
    rjmp @10

.endm


;#############################################
;######### prueft, ob eine Taste #############
;############ gedrueckt wurde ################
;#############################################
;######## Bedarf: 16 Byte, 00 Takte ##########
;#############################################
.macro pruefe_taste_gedrueckt
// Aufruf: reset=@0, outPort=@1, outPin=@2, outReg=@3, inPort=@4, inPort2=@5, inPin=@6, inReg=@7, ID=@8, THEN=@9, ELSE=@10
// oder
// Aufruf: TASTE, THEN=@9, ELSE=@10

    lds temp, TASTEN_ZUSTAENDE_TEMP+@8
    lds temp2, TASTEN_ZUSTAENDE+@8
    
    cp temp2, temp
    brsh nicht_druecken
    rjmp @9
    nicht_druecken:
    rjmp @10

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

.macro tasten_zustaende_init
LINKS_TASTE pruefe_taste
RECHTS_TASTE pruefe_taste
HOCH_TASTE pruefe_taste
RUNTER_TASTE pruefe_taste
EINS_TASTE pruefe_taste
ZWEI_TASTE pruefe_taste
DREI_TASTE pruefe_taste
VIER_TASTE pruefe_taste
START_TASTE pruefe_taste
SUPER_TASTE pruefe_taste
L_EINS_TASTE pruefe_taste
L_ZWEI_TASTE pruefe_taste
R_EINS_TASTE pruefe_taste
R_ZWEI_TASTE pruefe_taste
.endm


.macro pruefe_taste
// Aufruf: reset=@0, outPort=@1, outPin=@2, outReg=@3, inPort=@4, inPort2=@5, inPin=@6, inReg=@7, ID=@8
// oder
// Aufruf: TASTE

    @0

    // in als Eingang einstellen
    cbi @7,@6
    // Pull-Up Widerstand einschalten
    sbi @5,@6

    // out als Ausgang einstellen
    sbi @3, @2
    // Ausgang auf 0
    cbi @1, @2

	NOP
	NOP

    mov temp, EINS
    sbic @4, @6
    mov temp, NULL
    sts TASTEN_ZUSTAENDE_TEMP+@8, temp
.endm


.DSEG
TASTEN_ZUSTAENDE:        .BYTE 18
TASTEN_ZUSTAENDE_TEMP:   .BYTE 18

.CSEG
