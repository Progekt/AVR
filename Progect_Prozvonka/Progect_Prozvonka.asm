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

;�������������� �����
clr r16 ;�������� r16
out DDRA, r16 ;�� ����
out DDRC, r16 ;�C ����
out PORTB, r16 ;����� ���� PB
out PORTD, r16 ;����� ���� PD
ldi r16, 0x4 ;00000100
out PORTE, r16 ;����� 0,1 PE �������� �������� �� 2
ldi r16, 0x3 ; 00000011
out DDRE, r16 ;�� 0,1 ������ 2 ����
ldi r16, 0xFC ;11111100
out DDRD, r16 ;PD ����� 2,3,4,5,6,7
ser r16 ; ��� �������
out DDRB, r16 ;PB �����
out PORTA, r16 ;����� ���� PA
out PORTC, r16 ;����� ���� PC

//������������� USART
ldi r16, 12 ;�������� 4800bps ��� F=1MHz
out UBRRL, r16
ldi r16,(1<<TXEN) ;�������� ��������
out UCSRB,r16
ldi r16, (1<<URSEL)|(3<<UCSZ0); ������������� ��������� ����� 8data, 1stop bit
out UCSRC,r16
//-----------------------

Button:
	sbic PINE,2 ;�������� ������� ������, ���� �� ����������� �������
	rjmp Button ;������� � ������ �����
	rcall Delay ;��������

mein:
	ldi R19,1 ;������� ������
	ldi R18,1 ;������� �������
	ldi R17,1 ;1 ���� ����� 
	

	//-------������� ������� � ������������ ������
	X1:
		out PORTB, R17
		ldi R19, 1
		in R16, PINA ; ��������� ���� �
		cpi R16, 0 ; �� R16 �������� 0 ���� ��������� =0 ������ � SREG Z=1
		breq A1 ; ���� Z=1������� � ������������
		rcall prov_vh
		A1:
		clz
		
		in R16, PINC ; ��������� ���� C
		ldi R19, 9 ; ������� �� =9
		cpi R16, 0 ; �� R16 �������� 0 ���� ��������� =0 ������ � SREG Z=1
		breq A2 ; ���� Z=0������� � ������������
		rcall prov_vh
		A2:
		clz

		inc R18 ;��������� ������� ���� 1
		lsl R17 ; ����� ���� � �������� R17 <- (��� ������������ � SREG C=1)
		brcc X1 ; ������� �� �1 ���� ����� ���������� R17 �=0
		
		ldi R17, 0 
		out PORTB, R17
		clc ;����� �
		
		ldi R17, 4 ; ���������� 3��� ����� ��

	X2:
		out PORTD, R17 ; �������� � ���� D
		ldi R19, 1
		in R16, PINA ; ��������� ���� �
		cpi R16, 0 ; �� R16 �������� 0 ���� ��������� =0 ������ � SREG Z=1
		breq B1 ; ���� Z=0������� � ������������
		rcall prov_vh
		B1:
		clz
		
		in R16, PINC ; ��������� ���� C
		ldi R19, 9 ; ������� �� =9
		cpi R16, 0 ; �� R16 �������� 0 ���� ��������� =0 ������ � SREG Z=1
		breq B2 ; ���� Z=0������� � ������������
		rcall prov_vh
		B2:
		clz

		inc R18 ;��������� ������� ���� 1
		lsl R17 ; ����� ���� � �������� R17 <- (��� ������������ � SREG C=1)
		brcc X2 ; ������� �� �2���� ����� ���������� R17 �=0

		out PORTD, R17


rjmp Button



//-------------------------������� ����� ����� � ��� �
prov_vh:
	sbrc R16, 0 ;���������� ������� ���� ���=0
	rcall transmit ; ��������� ������������ transmit
	inc R19 ; ���� R19 �� 1  ������� ��

	sbrc R16, 1 ;���������� ������� ���� ���=0
	rcall transmit ; ��������� ������������ transmit
	inc R19 ; ���� R19 �� 1  ������� ��

	sbrc R16, 2 ;���������� ������� ���� ���=0
	rcall transmit ; ��������� ������������ transmit
	inc R19 ; ���� R19 �� 1  ������� ��

	sbrc R16, 3 ;���������� ������� ���� ���=0
	rcall transmit ; ��������� ������������ transmit
	inc R19 ; ���� R19 �� 1  ������� ��

	sbrc R16, 4 ;���������� ������� ���� ���=0
	rcall transmit ; ��������� ������������ transmit
	inc R19 ; ���� R19 �� 1  ������� ��

	sbrc R16, 5 ;���������� ������� ���� ���=0
	rcall transmit ; ��������� ������������ transmit
	inc R19 ; ���� R19 �� 1  ������� ��

	sbrc R16, 6 ;���������� ������� ���� ���=0
	rcall transmit ; ��������� ������������ transmit
	inc R19 ; ���� R19 �� 1  ������� ��

	sbrc R16, 7 ;���������� ������� ���� ���=0
	rcall transmit ; ��������� ������������ transmit

ret

//---------------�������� ������ �� USART
transmit:
	sbis UCSRA, UDRE ; ���� ��� UDRE ���������� 1 ���������� ���� �������
	rjmp transmit
	out UDR, R18 ; ��������� ������� ���
m1:
	sbis UCSRA, UDRE 
	rjmp m1
	out UDR, R19 ; ��������� ������� ��
rcall Delay ;��������	
ret


//----------��������
Delay:
	push R16 ;��������� R16
	push R18 ;��������� R18
	push R19 ;��������� R19
	ldi R16,0xFF ;��������� � R16 FF
	ldi R18, 0xFF
	wt1:
		dec R16 ; �������� 1 �� R16
		nop
		nop
		nop
		brne wt1 ; ������� ���� �� 0 �� wt1
		dec R18
		brne wt1
	pop R19 ; ������������� �������� R19
	pop R18 ; ������������� �������� R18
	pop R16 ; ������������� �������� R16
ret
