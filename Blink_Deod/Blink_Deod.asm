;***************************************************************
;*
;* Project Blink_Deod #1 ATmega128
;*
;***************************************************************
;*
;* Author: Yaroslav
;* Date: 30/12/2013
;*
;***************************************************************
.include "m128def.inc" ; Definition file for ATmega128
;***************************************************************
;* Program Constants
;***************************************************************
.equ const =$00 ; Generic Constant Structure
;***************************************************************
;* Program Variables Definitions
;***************************************************************
.def mpr =r16 ; Multipurpose Register
;***************************************************************
;* Interrupt Vectors
;***************************************************************
.cseg
.org $0000 ; Define start of Code segment
jmp RESET ; Reset Handler
jmp EXT_INT0 ; IRQ0 Handler
jmp EXT_INT1 ; IRQ1 Handler
jmp EXT_INT2 ; IRQ2 Handler
jmp EXT_INT3 ; IRQ3 Handler
jmp EXT_INT4 ; IRQ4 Handler
jmp EXT_INT5 ; IRQ5 Handler
jmp EXT_INT6 ; IRQ6 Handler
jmp EXT_INT7 ; IRQ7 Handler
jmp TIM2_COMP ; Timer2 Compare Handler
jmp TIM2_OVF ; Timer2 Overflow Handler
jmp TIM1_CAPT ; Timer1 Capture Handler
jmp TIM1_COMPA; Timer1 CompareA Handler
jmp TIM1_COMPB; Timer1 CompareB Handler
jmp TIM1_OVF ; Timer1 Overflow Handler
jmp TIM0_COMP ; Timer0 Compare Handle
jmp TIM0_OVF ; Timer0 Overflow Handler
jmp SPI_STC ; SPI Transfer Complete Handler
jmp USART0_RXC; USART0 RX Complete Handler
jmp USART0_DRE; USART0,UDR Empty Handler
jmp USART0_TXC; USART0 TX Complete Handler
jmp ADC_1 ; ADC Conversion Complete Handler
jmp EE_RDY ; EEPROM Ready Handler
jmp ANA_COMP ; Analog Comparator Handler
jmp TIM1_COMPC; Timer1 CompareC Handler
jmp TIM3_CAPT ; Timer3 Capture Handler
jmp TIM3_COMPA; Timer3 CompareA Handler
jmp TIM3_COMPB; Timer3 CompareB Handler
jmp TIM3_COMPC; Timer3 CompareC Handler
jmp TIM3_OVF ; Timer3 Overflow Handler
jmp USART1_RXC; USART1 RX Complete Handler
jmp USART1_DRE; USART1,UDR Empty Handler
jmp USART1_TXC; USART1 TX Complete Handler
jmp TWI ; Two-wire Serial Interface Interrupt Handler
jmp SPM_RDY ; SPM Ready Handler

;�������� �������������� ������������ ����������
	;RESET:;Reset;Handler
EXT_INT0:;IRQ0;Handler
EXT_INT1:;IRQ1;Handler
EXT_INT2:;IRQ2;Handler
EXT_INT3:;IRQ3;Handler
EXT_INT4:;IRQ4;Handler
EXT_INT5:;IRQ5;Handler
EXT_INT6:;IRQ6;Handler
EXT_INT7:;IRQ7;Handler
TIM2_COMP:;Timer2;Compare;Handler
TIM2_OVF:;Timer2;Overflow;Handler
TIM1_CAPT:;Timer1;Capture;Handler
TIM1_COMPA:;Timer1;CompareA;Handler
TIM1_COMPB:;Timer1;CompareB;Handler
TIM1_OVF:;Timer1;Overflow;Handler
TIM0_COMP:;Timer0;Compare;Handle
;	TIM0_OVF:;Timer0;Overflow;Handler
SPI_STC:;SPI;Transfer;Complete;Handler
USART0_RXC:;USART0;RX;Complete;Handler
USART0_DRE:;USART0,UDR;Empty;Handler
USART0_TXC:;USART0;TX;Complete;Handler
ADC_1:;ADC;Conversion;Complete;Handler
EE_RDY:;EEPROM;Ready;Handler
ANA_COMP:;Analog;Comparator;Handler
TIM1_COMPC:;Timer1;CompareC;Handler
TIM3_CAPT:;Timer3;Capture;Handler
TIM3_COMPA:;Timer3;CompareA;Handler
TIM3_COMPB:;Timer3;CompareB;Handler
TIM3_COMPC:;Timer3;CompareC;Handler
TIM3_OVF:;Timer3;Overflow;Handler
USART1_RXC:;USART1;RX;Complete;Handler
USART1_DRE:;USART1,UDR;Empty;Handler
USART1_TXC:;USART1;TX;Complete;Handler
TWI:;Two-wire;Serial;Interface;Interrupt;Handler
SPM_RDY:;SPM;Ready;Handler
  reti
;***************************************************************
;* Func: RESET
;***************************************************************
RESET:
; ***** Stack Pointer Init *****
ldi mpr, LOW(RAMEND)
out SPL, mpr
ldi mpr, HIGH(RAMEND)
out SPH, mpr

;******Init_Button*******
ldi mpr, 0
out DDRA, mpr ;��������� ���� � �� ���� (5 ������)
ldi mpr, (31<<PA0) ; 00011111
out PORTA, mpr

;******Inir_Out**********
ldi mpr, 7 ; 00000111
out DDRB, mpr ; ��������� ����� � ����� (3 ������ ������)
ldi mpr, 0
out PORTB, mpr ; �� ������ ������ ���������

ldi r16,(1<<4) ;��������� OC0 ��� �����
out DDRB, r16
ldi r16,(1<<6) ;���������� ����
out DDRA, r16

;********Timer0***********
CLI
LDI R16, (1<<COM00)|(1<<CS00)|(1<<CS01)|(1<<CS02)
OUT TCCR0, R16 ;�������� ������� 1024, ��� ��
LDI R16, 0xFF
OUT OCR0, R16 ;��������� ������� ���������
LDI R16, 0
ldi r16, (1<<TOIE0); ���������� �� ������������
out TIMSK, r16

SEI; ���������� ����������


LDI R16,0x0
out TCNT0, R16




;********Operation*******

ldi R17,0
;ldi R18,0

BUTTON1:
	sbic PINA, 1 ;�������� ������� 1� ������ �� PA0 ���� ������
	rjmp BUTTON1

;*********������� ������������ ����������*********

Tim1:
	CPI R17,60 ; ��������� � 255
	brne RET1; ������� ���� R17<>255 �������
;	INC R18 ;���� �� 1
	ldi R17,0 ;�������� �������
;	CPI R18, 5 ;�������� � 255
;	brne RET1; ������� ���� R18<>255 �������
;	LDI R18,0 ;�������� �������
	SBIC PINA, 6 ;���������� ���� ��� ��� ������
	RJMP bip1 ;�������
	RJMP bip2 ;�������
bip1:		
	CBI PORTA, 6 ;���������� 0
	reti
bip2:
	SBI PORTA, 6 ; ���������� 1
	reti


;*******Intrrupt Timer0*******
TIM0_OVF:
	INC R17 ;���� �� 1
	rjmp Tim1

;********RETI*******
RET1:
	reti
