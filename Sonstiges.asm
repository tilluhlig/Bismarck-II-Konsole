.CSEG

BinZuAscii:; Eingabe=temp
ldi zl, low(SonstigesAusgabe)
ldi zh, high(SonstigesAusgabe)

ldi temp2,48
hunderter:
cpi temp, 100
brlo hunderter_ende
inc temp2
subi temp, 100
rjmp hunderter
hunderter_ende:
st Z+, temp2

ldi temp2,48
zehner:
cpi temp, 10
brlo zehner_ende
inc temp2
subi temp, 10
rjmp zehner
zehner_ende:
st Z+, temp2

ldi temp2,48
einer:
cpi temp, 1
brlo einer_ende
inc temp2
dec temp
rjmp einer
einer_ende:
st Z+, temp2
ret

.DSEG
SonstigesAusgabe: .Byte 3
.CSEG
