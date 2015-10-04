.include "m8515def.inc"
.cseg
.org 0
  rjmp RESET ; Reset Handler
nop ;rjmp EXT_INT0 ; IRQ0 Handler
nop ;rjmp EXT_INT1 ; IRQ1 Handler
nop ;rjmp TIM1_CAPT ; Timer1 Capture Handler
nop ;rjmp TIM1_COMPA ; Timer1 Compare A Handler
nop ;rjmp TIM1_COMPB ; Timer1 Compare B Handler
nop ;rjmp TIM1_OVF ; Timer1 Overflow Handler
nop ;rjmp TIM0_OVF ; Timer0 Overflow Handler
nop ;rjmp SPI_STC ; SPI Transfer Complete Handler
nop ;rjmp USART_RXC ; USART RX Complete Handler
nop ;rjmp USART_UDRE ; UDR0 Empty Handler
  nop                  ; rjmp USART_TXC ; USART TX Complete Handler
nop ;rjmp ANA_COMP ; Analog Comparator Handler
nop ;rjmp EXT_INT2 ; IRQ2 Handler
nop ;rjmp TIM0_COMP ; Timer0 Compare Handler
nop ;rjmp EE_RDY ; EEPROM Ready Handler
nop ;rjmp SPM_RDY ; Store Program memory Ready

RESET:
ldi r16,high(RAMEND); Main program start
out SPH,r16 ; Set Stack Pointer to top of RAM
ldi r16,low(RAMEND)
out SPL,r16

sei

;eieoeaeece?oai ii?ou
clr r16 ;iaioeyai r16
out DDRA, r16 ;?A aoia
out DDRC, r16 ;?C aoia
out PORTB, r16 ;Aanei ii?o PB
out PORTD, r16 ;Aanei ii?o PD
ldi r16, 0x4 ;00000100
out PORTE, r16 ;Aanei 0,1 PE aee??aai ?acenoi? ia 2
ldi r16, 0x3 ; 00000011
out DDRE, r16 ;?A 0,1 auoiau 2 aoia
ldi r16, 0xFC ;11111100
out DDRD, r16 ;PD auoia 2,3,4,5,6,7
ser r16 ; Ana aaaieou
out DDRB, r16 ;PB auoia
out PORTA, r16 ;Aanei ii?o PA
out PORTC, r16 ;Aanei ii?o PC

//Eieoeaeecaoey USART
ldi r16, 25 ;nei?inou 2400bps i?e F=1MHz
out UBRRL, r16
ldi r16,(1<<TXEN) ;?ac?aoa? ia?aaa?o
out UCSRB,r16
ldi r16, (1<<URSEL)|(3<<UCSZ0); Onoaiaaeeaaai ia?aiao?u neiaa 8data, 1stop bit
out UCSRC,r16
//-----------------------
ldi R18, 15
ldi R19, 88

Button:
	sbic PINE,2 ;I?iaa?ea ia?aoey eiiiee, anee aa ia?anei?eou eiiaiao
	rjmp Button ;Aica?ao a ia?aei oeeea
	rcall Delay ;Caaa??ea

//---------------Ia?aaa?a aaiiuo ii USART
transmit:
	sbis UCSRA, UDRE ; Anee aeo UDRE onoaiiaeai 1 i?iionoeou neaa eiiaiao
	rjmp transmit
	out UDR, R18 ; ioi?aaeou n?ao?ee auo
m1:
	sbis UCSRA, UDRE 
	rjmp m1
	out UDR, R19 ; ioi?aaeou n?ao?ee ao
	
rjmp Button

//----------caaa??ea
Delay:
	push R16 ;Nio?aiyai R16
	push R18 ;Nio?aiyai R18
	push R19 ;Nio?aiyai R19
	ldi R16,0xFF ;caa?o?aai a R16 FF
	wt1:
		dec R16 ; ioieiaai 1 io R16
		brne wt1 ; ia?aoia anee ia 0 ia wt1
	pop R19 ; ainoaiiaeaiea cia?aiey R19
	pop R18 ; ainoaiiaeaiea cia?aiey R18
	pop R16 ; ainoaiiaeaiea cia?aiey R16
ret
