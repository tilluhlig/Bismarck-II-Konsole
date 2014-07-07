.include "Befehle_Makros.asm"

.CSEG

// Hier stehen Definitionen zu uebertragbaren Befehlen
HALLO_TEXT:       .db "hallo",0 // Abfrage ob Anwesend
LICHT_TEXT:       .db "licht ",0 // licht 1 1       ---Licht Ein/Aus
LICHTR_TEXT:      .db "lichtr ",0 // lichtr 1 255    ---Licht Rot einstellen
LICHTG_TEXT:      .db "lichtg ",0 // lichtg 1 255    ---Licht Gr?n einstellen
LICHTB_TEXT:      .db "lichtb ",0 // lichtb 1 255    ---Licht Blau einstellen
MOTOR_TEXT:       .db "motor ",0 // motor 1 1       ---Motor Ein/Aus
MOTORG_TEXT:      .db "motorg ",0 // motorg 1 255    ---Motor Geschwindigkeit
SCHORNSTEIN_TEXT: .db "schornstein ",0 // schornstein 1   ---Schornstein Ein/Aus
L_TEXT:           .db "l ",0 // l 1 255255255   ---Licht RGB einstellen
SERVOC_TEXT:      .db "servoc ",0 // 
SERVO_TEXT:       .db "servo ",0 // servo 1 090 160 ---Geschuetz einstellen
MOTORR_TEXT:      .db "motorr ",0 // motorr 1 1      ---Motorrichtung
TEMPERATUR_TEXT:  .db "temperatur ",0 // temperatur 7    ---Temperatur messen
KONF_TEMP_TEXT:   .db "konf_temp ",0 // konf_temp 1     ---Temperaturmessung aktivieren/deaktivieren, nach start 200ms pause machen
DREHZAHL_TEXT:    .db "drehzahl ",0 // drehzahl 1      ---Drehzahl abfragen
INTERVAL_TEXT:    .db "interval ",0 // interval 99 255 ---Interval einstellen f?r Messwert?bertragung - 0 = Aus, Einstellen in 16 = 1s (max. 15s)
NEU_MESS_TEXT:    .db "neu_mess ",0 // neu_mess 99 1   ---Einstellen, ob Messwerte im Interval nur, wenn wert ver?ndert
ANTWORT_TEXT:     .db "antwort ",0 // antwort 1       ---Einstellen, ob nur Antworten mit Messwerten ?bertragen werden

HOCH_TASTE_TEXT:   .db "HOCH_TASTE     ",0
RUNTER_TASTE_TEXT: .db "RUNTER_TASTE   ",0
LINKS_TASTE_TEXT:  .db "LINKS_TASTE    ",0
RECHTS_TASTE_TEXT: .db "RECHTS_TASTE   ",0
EINS_TASTE_TEXT:   .db "EINS_TASTE     ",0
ZWEI_TASTE_TEXT:   .db "ZWEI_TASTE     ",0
DREI_TASTE_TEXT:   .db "DREI_TASTE     ",0
VIER_TASTE_TEXT:   .db "VIER_TASTE     ",0
L_EINS_TASTE_TEXT: .db "L_EINS_TASTE   ",0
L_ZWEI_TASTE_TEXT: .db "L_ZWEI_TASTE   ",0
R_EINS_TASTE_TEXT: .db "R_EINS_TASTE   ",0
R_ZWEI_TASTE_TEXT: .db "R_ZWEI_TASTE   ",0
