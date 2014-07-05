.CSEG

wait_ms2:
schleife:;400*x

NOP
ldi temp2, 130
schleife2:

dec temp2
brne schleife2
end_schleife2:

sbiw zl, 1
cpi zl,0
breq A

NOP
NOP
NOP
rjmp schleife
A:
cpi zh, 0
breq end_schleife

rjmp schleife

end_schleife:
NOP
ret

.macro wait_ms; ms=@0
.if ((XTAL/1000*@0/400 > 65535) || (XTAL/1000*@0/400 < 0))
  .error "Fehlerhafte Eingabe in wait_ms!!!"
.endif

ldi zl, low(XTAL/1000*@0/400)
ldi zh, high(XTAL/1000*@0/400)
rcall wait_ms2
.endm
