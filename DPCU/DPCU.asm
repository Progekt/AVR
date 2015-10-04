;***************************************************************
;*
;* Project DPCU #1 ATmega128
;*
;***************************************************************
;*
;* Author: Yaroslav
;* Date: 02/01/2013
;*
;***************************************************************
.include "m128def.inc" ; Definition file for ATmega128
;***************************************************************
;* Program Constants
;***************************************************************
;.equ const =$00 ; Generic Constant Structure
;***************************************************************
;* Program Variables Definitions
;***************************************************************
.def temp =r16 ; Multipurpose Register

;***************************************************************
;* Interrupt Vectors
;***************************************************************
.cseg
.org $0000 ; Define start of Code segment
nop ;jmp RESET ; Reset Handler
nop ;jmp EXT_INT0 ; IRQ0 Handler
nop ;jmp EXT_INT1 ; IRQ1 Handler
nop ;jmp EXT_INT2 ; IRQ2 Handler
nop ;jmp EXT_INT3 ; IRQ3 Handler
nop ;jmp EXT_INT4 ; IRQ4 Handler
nop ;jmp EXT_INT5 ; IRQ5 Handler
nop ;jmp EXT_INT6 ; IRQ6 Handler
nop ;jmp EXT_INT7 ; IRQ7 Handler
nop ;jmp TIM2_COMP ; Timer2 Compare Handler
nop ;jmp TIM2_OVF ; Timer2 Overflow Handler
nop ;jmp TIM1_CAPT ; Timer1 Capture Handler
nop ;jmp TIM1_COMPA; Timer1 CompareA Handler
nop ;jmp TIM1_COMPB; Timer1 CompareB Handler
nop ;jmp TIM1_OVF ; Timer1 Overflow Handler
nop ;jmp TIM0_COMP ; Timer0 Compare Handle
nop ;jmp TIM0_OVF ; Timer0 Overflow Handler
nop ;jmp SPI_STC ; SPI Transfer Complete Handler
nop ;jmp USART0_RXC; USART0 RX Complete Handler
nop ;jmp USART0_DRE; USART0,UDR Empty Handler
nop ;jmp USART0_TXC; USART0 TX Complete Handler
nop ;jmp ADC_1 ; ADC Conversion Complete Handler
nop ;jmp EE_RDY ; EEPROM Ready Handler
nop ;jmp ANA_COMP ; Analog Comparator Handler
nop ;jmp TIM1_COMPC; Timer1 CompareC Handler
nop ;jmp TIM3_CAPT ; Timer3 Capture Handler
nop ;jmp TIM3_COMPA; Timer3 CompareA Handler
nop ;jmp TIM3_COMPB; Timer3 CompareB Handler
nop ;jmp TIM3_COMPC; Timer3 CompareC Handler
nop ;jmp TIM3_OVF ; Timer3 Overflow Handler
nop ;jmp USART1_RXC; USART1 RX Complete Handler
nop ;jmp USART1_DRE; USART1,UDR Empty Handler
nop ;jmp USART1_TXC; USART1 TX Complete Handler
nop ;jmp TWI ; Two-wire Serial Interface Interrupt Handler
nop ;jmp SPM_RDY ; SPM Ready Handler

;***************************************************************
;* RESET
;***************************************************************
RESET:
; ***** Stack Pointer Init *****
ldi temp, LOW(RAMEND)
out SPL, temp
ldi temp, HIGH(RAMEND)
out SPH, temp

;****Init LCD*****
clr temp
out PORTC, temp ;настройка порта LCD на выход
ser temp
out DDRC, temp ;настройка порта LCD на выход

ldi R17, 0x00 ;delay 40ms
ldi R18, 0xf4 ;delay 40ms
ldi R19, 0x01 ;delay 40ms
rcall Delay

;Function set
clr temp   
sbi PORTB, 0 ; подаем импульс RS
ldi temp, (1<<PORTC4)|(1<<PORTC5)
out PORTC,temp ; загрузить в порт
rcall IMP_E
;cbi PORTB, 0 ; отключаем импульс RS

ldi R17, 0x7D ;delay 39us
ldi R18, 0x0 ;delay 39us
ldi R19, 0x0 ;delay 39us
rcall Delay

;Function set
clr temp
;sbi PORTB, 0 ; подаем импульс RS
ldi temp, (1<<PORTC5)
out PORTC,temp ; загрузить в порт
rcall IMP_E
ldi temp, (0<<PORTC5)|(1<<PORTC6)|(1<<PORTC7)
out PORTC,temp ; загрузить в порт
rcall IMP_E

ldi R17, 0x7D ;delay 39us
ldi R18, 0x0 ;delay 39us
ldi R19, 0x0 ;delay 39us
rcall Delay

;Function set
clr temp
;sbi PORTB, 0 ; подаем импульс RS
ldi temp, (1<<PORTC5)
out PORTC,temp ; загрузить в порт
rcall IMP_E
ldi temp, (0<<PORTC5)|(1<<PORTC6)|(1<<PORTC7)
out PORTC,temp ; загрузить в порт
rcall IMP_E

ldi R17, 0x7D ;delay 39us
ldi R18, 0x0 ;delay 39us
ldi R19, 0x0 ;delay 39us
rcall Delay

;Displey off/On control
clr temp
;sbi PORTB, 0 ; подаем импульс RS
out PORTC,temp ; загрузить в порт
rcall IMP_E
ldi temp, (1<<PORTC7)
out PORTC,temp ; загрузить в порт
rcall IMP_E

ldi R17, 0x7D ;delay 39us
ldi R18, 0x0 ;delay 39us
ldi R19, 0x0 ;delay 39us
rcall Delay

;Display Clear
clr temp
;sbi PORTB, 0 ; подаем импульс RS
out PORTC,temp ; загрузить в порт
rcall IMP_E
ldi temp, (1<<PORTC4)
out PORTC,temp ; загрузить в порт
rcall IMP_E

ldi R17, 0x7D ;delay 39us
ldi R18, 0x0 ;delay 39us
ldi R19, 0x0 ;delay 39us
rcall Delay

;Entry Mode Set
clr temp
;sbi PORTB, 0 ; подаем импульс RS
out PORTC,temp ; загрузить в порт
rcall IMP_E
ldi temp, (1<<PORTC6)
out PORTC,temp ; загрузить в порт
rcall IMP_E

cbi PORTC, 0 ; отключаем импульс RS
;****End LCD*****






;*******IMP_E*************
IMP_E:
sbi PORTB, 2 ; подаем импульс Е
nop
nop
nop
nop
cbi PORTB, 2 ; отключаем импульс
ret

;**********Delay**********
Delay:
	subi R17,1	;(T*F)/5=N					  R19 R18 R17
	sbci R18,0	;C  Гц   Тик->в шеснатиричный 00  00  00
	sbci R19,0
brcc Delay
ret; Возврат

