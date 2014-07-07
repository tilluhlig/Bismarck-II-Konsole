.include "Gamepad_Makros.asm"

.CSEG

// Definition der Turbo-LED
.equ LED_I_REG_OUT  = DDRD
.equ LED_I_PORT_OUT = PORTD
.equ LED_I_PIN_OUT  = 7
.equ LED_I_REG_IN  = DDRA
.equ LED_I_PORT_IN = PORTA
.equ LED_I_PIN_IN  = 0
.macro LED_I
@0 LED_I_REG_OUT,LED_I_PORT_OUT,LED_I_PIN_OUT,LED_I_REG_IN,LED_I_PORT_IN,LED_I_PIN_IN
.endm 

// Definition der Analog-LED
.equ LED_II_REG_OUT  = DDRD
.equ LED_II_PORT_OUT = PORTD
.equ LED_II_PIN_OUT  = 7
.equ LED_II_REG_IN  = DDRA
.equ LED_II_PORT_IN = PORTA
.equ LED_II_PIN_IN  = 1
.macro LED_II
@0 LED_II_REG_OUT,LED_II_PORT_OUT,LED_II_PIN_OUT,LED_II_REG_IN,LED_II_PORT_IN,LED_II_PIN_IN
.endm

// Definition der HOCH-Taste
.equ HOCH_REG_OUT  = DDRD
.equ HOCH_PORT_OUT = PORTD
.equ HOCH_PIN_OUT  = 7
.equ HOCH_PORT_IN  = PIND
.equ HOCH_REG_IN   = DDRD
.equ HOCH_PORT2_IN = PORTD
.equ HOCH_PIN_IN   = 4
.equ HOCH_ID       = 0
.macro HOCH_TASTE 
ausgaenge_reset2
@0 HOCH_PORT_OUT,HOCH_PIN_OUT,HOCH_REG_OUT,HOCH_PORT_IN,HOCH_PORT2_IN,HOCH_PIN_IN,HOCH_REG_IN,HOCH_ID, @1, @2
.endm 

// Definition der RUNTER-Taste
.equ RUNTER_REG_OUT  = DDRD
.equ RUNTER_PORT_OUT = PORTD
.equ RUNTER_PIN_OUT  = 6
.equ RUNTER_PORT_IN  = PIND
.equ RUNTER_REG_IN   = DDRD
.equ RUNTER_PORT2_IN = PORTD
.equ RUNTER_PIN_IN   = 4
.equ RUNTER_ID       = 1
.macro RUNTER_TASTE 
ausgaenge_reset2
@0 RUNTER_PORT_OUT,RUNTER_PIN_OUT,RUNTER_REG_OUT,RUNTER_PORT_IN,RUNTER_PORT2_IN,RUNTER_PIN_IN,RUNTER_REG_IN,RUNTER_ID, @1, @2
.endm 

// Definition der LINKS-Taste
.equ LINKS_REG_OUT  = DDRD
.equ LINKS_PORT_OUT = PORTD
.equ LINKS_PIN_OUT  = 6
.equ LINKS_PORT_IN  = PIND
.equ LINKS_REG_IN   = DDRD
.equ LINKS_PORT2_IN = PORTD
.equ LINKS_PIN_IN   = 5
.equ LINKS_ID       = 2
.macro LINKS_TASTE 
ausgaenge_reset2
@0 LINKS_PORT_OUT,LINKS_PIN_OUT,LINKS_REG_OUT,LINKS_PORT_IN,LINKS_PORT2_IN,LINKS_PIN_IN,LINKS_REG_IN,LINKS_ID, @1, @2
.endm 

// Definition der RECHTS-Taste
.equ RECHTS_REG_OUT  = DDRD
.equ RECHTS_PORT_OUT = PORTD
.equ RECHTS_PIN_OUT  = 7
.equ RECHTS_PORT_IN  = PIND
.equ RECHTS_REG_IN   = DDRD
.equ RECHTS_PORT2_IN = PORTD
.equ RECHTS_PIN_IN   = 5
.equ RECHTS_ID       = 3
.macro RECHTS_TASTE 
ausgaenge_reset2
@0 RECHTS_PORT_OUT,RECHTS_PIN_OUT,RECHTS_REG_OUT,RECHTS_PORT_IN,RECHTS_PORT2_IN,RECHTS_PIN_IN,RECHTS_REG_IN,RECHTS_ID, @1, @2
.endm 

// Definition der 1-Taste
.equ EINS_REG_OUT  = DDRD
.equ EINS_PORT_OUT = PORTD
.equ EINS_PIN_OUT  = 7
.equ EINS_PORT_IN  = PINB
.equ EINS_REG_IN   = DDRB
.equ EINS_PORT2_IN = PORTB
.equ EINS_PIN_IN   = 3
.equ EINS_ID       = 4
.macro EINS_TASTE 
ausgaenge_reset
@0 EINS_PORT_OUT,EINS_PIN_OUT,EINS_REG_OUT,EINS_PORT_IN,EINS_PORT2_IN,EINS_PIN_IN,EINS_REG_IN,EINS_ID, @1, @2
.endm 

// Definition der 2-Taste
.equ ZWEI_REG_OUT  = DDRD
.equ ZWEI_PORT_OUT = PORTD
.equ ZWEI_PIN_OUT  = 7
.equ ZWEI_PORT_IN  = PINB
.equ ZWEI_REG_IN   = DDRB
.equ ZWEI_PORT2_IN = PORTB
.equ ZWEI_PIN_IN   = 1
.equ ZWEI_ID       = 5
.macro ZWEI_TASTE 
ausgaenge_reset
@0 ZWEI_PORT_OUT,ZWEI_PIN_OUT,ZWEI_REG_OUT,ZWEI_PORT_IN,ZWEI_PORT2_IN,ZWEI_PIN_IN,ZWEI_REG_IN,ZWEI_ID, @1, @2
.endm 

// Definition der 3-Taste
.equ DREI_REG_OUT  = DDRD
.equ DREI_PORT_OUT = PORTD
.equ DREI_PIN_OUT  = 7
.equ DREI_PORT_IN  = PIND
.equ DREI_REG_IN   = DDRD
.equ DREI_PORT2_IN = PORTD
.equ DREI_PIN_IN   = 2
.equ DREI_ID       = 6
.macro DREI_TASTE 
ausgaenge_reset
@0 DREI_PORT_OUT,DREI_PIN_OUT,DREI_REG_OUT,DREI_PORT_IN,DREI_PORT2_IN,DREI_PIN_IN,DREI_REG_IN,DREI_ID, @1, @2
.endm 

// Definition der 4-Taste
.equ VIER_REG_OUT  = DDRD
.equ VIER_PORT_OUT = PORTD
.equ VIER_PIN_OUT  = 7
.equ VIER_PORT_IN  = PINB
.equ VIER_REG_IN   = DDRB
.equ VIER_PORT2_IN = PORTB
.equ VIER_PIN_IN   = 2
.equ VIER_ID       = 7
.macro VIER_TASTE 
ausgaenge_reset
@0 VIER_PORT_OUT,VIER_PIN_OUT,VIER_REG_OUT,VIER_PORT_IN,VIER_PORT2_IN,VIER_PIN_IN,VIER_REG_IN,VIER_ID, @1, @2
.endm 

// Definition der SELECT-Taste
.equ SELECT_REG_OUT  = DDRD
.equ SELECT_PORT_OUT = PORTD
.equ SELECT_PIN_OUT  = 7
.equ SELECT_PORT_IN  = PINA
.equ SELECT_REG_IN   = DDRA
.equ SELECT_PORT2_IN = PORTA
.equ SELECT_PIN_IN   = 3
.equ SELECT_ID       = 8
.macro SELECT_TASTE 
ausgaenge_reset
@0 SELECT_PORT_OUT,SELECT_PIN_OUT,SELECT_REG_OUT,SELECT_PORT_IN,SELECT_PORT2_IN,SELECT_PIN_IN,SELECT_REG_IN,SELECT_ID, @1, @2
.endm 

// Definition der START-Taste
.equ START_REG_OUT  = DDRD
.equ START_PORT_OUT = PORTD
.equ START_PIN_OUT  = 7
.equ START_PORT_IN  = PINC
.equ START_REG_IN   = DDRC
.equ START_PORT2_IN = PORTC
.equ START_PIN_IN   = 0
.equ START_ID       = 9
.macro START_TASTE 
ausgaenge_reset
@0 START_PORT_OUT,START_PIN_OUT,START_REG_OUT,START_PORT_IN,START_PORT2_IN,START_PIN_IN,START_REG_IN,START_ID, @1, @2
.endm 

// Definition der ANALOG-Taste
.equ ANALOG_REG_OUT  = DDRD
.equ ANALOG_PORT_OUT = PORTD
.equ ANALOG_PIN_OUT  = 7
.equ ANALOG_PORT_IN  = PINA
.equ ANALOG_REG_IN   = DDRA
.equ ANALOG_PORT2_IN = PORTA
.equ ANALOG_PIN_IN   = 2
.equ ANALOG_ID       = 10
.macro ANALOG_TASTE 
ausgaenge_reset
@0 ANALOG_PORT_OUT,ANALOG_PIN_OUT,ANALOG_REG_OUT,ANALOG_PORT_IN,ANALOG_PORT2_IN,ANALOG_PIN_IN,ANALOG_REG_IN,ANALOG_ID, @1, @2
.endm 

// Definition der TURBO-Taste
.equ TURBO_REG_OUT  = DDRD
.equ TURBO_PORT_OUT = PORTD
.equ TURBO_PIN_OUT  = 7
.equ TURBO_PORT_IN  = PINA
.equ TURBO_REG_IN   = DDRA
.equ TURBO_PORT2_IN = PORTA
.equ TURBO_PIN_IN   = 4
.equ TURBO_ID       = 11
.macro TURBO_TASTE 
ausgaenge_reset
@0 TURBO_PORT_OUT,TURBO_PIN_OUT,TURBO_REG_OUT,TURBO_PORT_IN,TURBO_PORT2_IN,TURBO_PIN_IN,TURBO_REG_IN,TURBO_ID, @1, @2
.endm

// Definition der SUPER-Taste
.equ SUPER_REG_OUT  = DDRE
.equ SUPER_PORT_OUT = PORTE
.equ SUPER_PIN_OUT  = 1
.equ SUPER_PORT_IN  = PINC
.equ SUPER_REG_IN   = DDRC
.equ SUPER_PORT2_IN = PORTC
.equ SUPER_PIN_IN   = 3
.equ SUPER_ID       = 12
.macro SUPER_TASTE 
ausgaenge_reset
@0 SUPER_PORT_OUT,SUPER_PIN_OUT,SUPER_REG_OUT,SUPER_PORT_IN,SUPER_PORT2_IN,SUPER_PIN_IN,SUPER_REG_IN,SUPER_ID, @1, @2
.endm 

// Definition der R1-Taste
.equ R_EINS_REG_OUT  = DDRE
.equ R_EINS_PORT_OUT = PORTE
.equ R_EINS_PIN_OUT  = 1
.equ R_EINS_PORT_IN  = PINC
.equ R_EINS_REG_IN   = DDRC
.equ R_EINS_PORT2_IN = PORTC
.equ R_EINS_PIN_IN   = 2
.equ R_EINS_ID       = 13
.macro R_EINS_TASTE 
ausgaenge_reset
@0 R_EINS_PORT_OUT,R_EINS_PIN_OUT,R_EINS_REG_OUT,R_EINS_PORT_IN,R_EINS_PORT2_IN,R_EINS_PIN_IN,R_EINS_REG_IN,R_EINS_ID, @1, @2
.endm 

// Definition der R2-Taste
.equ R_ZWEI_REG_OUT  = DDRE
.equ R_ZWEI_PORT_OUT = PORTE
.equ R_ZWEI_PIN_OUT  = 1
.equ R_ZWEI_PORT_IN  = PINC
.equ R_ZWEI_REG_IN   = DDRC
.equ R_ZWEI_PORT2_IN = PORTC
.equ R_ZWEI_PIN_IN   = 1
.equ R_ZWEI_ID       = 14
.macro R_ZWEI_TASTE 
ausgaenge_reset
@0 R_ZWEI_PORT_OUT,R_ZWEI_PIN_OUT,R_ZWEI_REG_OUT,R_ZWEI_PORT_IN,R_ZWEI_PORT2_IN,R_ZWEI_PIN_IN,R_ZWEI_REG_IN,R_ZWEI_ID, @1, @2
.endm 

// Definition der L1-Taste
.equ L_EINS_REG_OUT  = DDRE
.equ L_EINS_PORT_OUT = PORTE
.equ L_EINS_PIN_OUT  = 1
.equ L_EINS_PORT_IN  = PINA
.equ L_EINS_REG_IN   = DDRA
.equ L_EINS_PORT2_IN = PORTA
.equ L_EINS_PIN_IN   = 5
.equ L_EINS_ID       = 15
.macro L_EINS_TASTE 
ausgaenge_reset
@0 L_EINS_PORT_OUT,L_EINS_PIN_OUT,L_EINS_REG_OUT,L_EINS_PORT_IN,L_EINS_PORT2_IN,L_EINS_PIN_IN,L_EINS_REG_IN,L_EINS_ID, @1, @2
.endm 

// Definition der L2-Taste
.equ L_ZWEI_REG_OUT  = DDRE
.equ L_ZWEI_PORT_OUT = PORTE
.equ L_ZWEI_PIN_OUT  = 1
.equ L_ZWEI_PORT_IN  = PINA
.equ L_ZWEI_REG_IN   = DDRA
.equ L_ZWEI_PORT2_IN = PORTA
.equ L_ZWEI_PIN_IN   = 6
.equ L_ZWEI_ID       = 16
.macro L_ZWEI_TASTE 
ausgaenge_reset
@0 L_ZWEI_PORT_OUT,L_ZWEI_PIN_OUT,L_ZWEI_REG_OUT,L_ZWEI_PORT_IN,L_ZWEI_PORT2_IN,L_ZWEI_PIN_IN,L_ZWEI_REG_IN,L_ZWEI_ID, @1, @2
.endm

.macro ausgaenge_reset
rcall ausgaenge_reset_call
.endm

ausgaenge_reset_call:
ldi temp, 0b00000000
out DDRB, temp
ldi temp, 0b00000000
out PORTB, temp

ldi temp, 0b00000000
out DDRA, temp
ldi temp, 0b00000000
out PORTA, temp

ldi temp, 0b00000000
out DDRC, temp
ldi temp, 0b00000000
out PORTC, temp

ldi temp, 0b00000000
out DDRD, temp
ldi temp, 0b00000000
out PORTD, temp

ldi temp, 0b00000000
out DDRE, temp
ldi temp, 0b00000000
out PORTE, temp
ret

.macro ausgaenge_reset2
rcall ausgaenge_reset_call2
.endm

ausgaenge_reset_call2:
ldi temp, 0b00001111
out DDRB, temp
ldi temp, 0b00001111
out PORTB, temp

ldi temp, 0b11111111
out DDRA, temp
ldi temp, 0b11111111
out PORTA, temp

ldi temp, 0b11111111
out DDRC, temp
ldi temp, 0b11111111
out PORTC, temp

ldi temp, 0b11111111
out DDRD, temp
ldi temp, 0b11111111
out PORTD, temp

ldi temp, 0b11111111
out DDRE, temp
ldi temp, 0b11111111
out PORTE, temp
ret

.DSEG
TASTEN_ZUSTAENDE:        .BYTE 18
TASTEN_ZUSTAENDE_TEMP:   .BYTE 18

.CSEG
