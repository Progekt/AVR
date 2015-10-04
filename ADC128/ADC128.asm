;***************************************************************
;*
;* Project ADC ATmega128
;*
;***************************************************************
;*
;* Author: Yaroslav
;* Date: 12/08/2013
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
rjmp RESET ; Reset Handler
reti ; IRQ0 Handler
nop
reti ; IRQ1 Handler
nop
reti ; Timer2 Compare Handler
nop
reti ; Timer2 Overflow Handler
nop
reti ; Timer1 Capture Handler
nop
reti ; Timer1 CompareA Handler
nop
reti ; Timer1 CompareB Handler
nop
reti ; Timer1 Overflow Handler
nop
reti ; Timer0 Overflow Handler
nop
reti ; SPI Transfer Complete Handler
nop
reti ; USART RX Complete Handler
nop
reti ; UDR Empty Hanlder
nop
reti ; USART TX Complete Handler
nop
reti ; ADC Conversion Complete Handler
nop
reti ; EEPROM Ready Hanlder
nop
reti ; Analog Comparator Handler
nop
reti ; Two-wire Serial Interface Handler
nop
reti ; Store Program Memory Ready Handler
nop
;***************************************************************
;* Func: RESET
;***************************************************************
RESET:
; ***** Stack Pointer Init *****
ldi mpr, LOW(RAMEND)
out SPL, mpr
ldi mpr, HIGH(RAMEND)
out SPH, mpr

;******Init_UART*******
;	Установка скорости 9600 на 16Мг
ldi r16, 0
sts UBRR1H, r16
ldi r16, 103
sts UBRR1L, r16
;*****Разрешение передачи (приема)
ldi r16,(1<<TXEN1)
sts UCSR1B,r16
;*****Уртановка формата: 8bit, 2 stop bit
ldi r16, (1<<USBS1)|(3<<UCSZ10)
sts UCSR1C,r16

;*****Init_ADC******
ldi mpr, (1<<REFS0)|(1<<ADLAR)
out ADMUX, mpr		;Опорно напряжение AVCC
ldi mpr, 0
out MUX0, mpr
ldi mpr, (1<<ADEN)|(1<<ADPS0)|(1<<ADPS1)|(1<<ADPS2)
out ADCSRA, mpr		;ВКЛ АЦП, Коэффициент деления частоты 128

;******Init_Button*******
ldi mpr, 0
out DDRA, mpr ;Настройка порт А на вход (5 кнопок)
ldi mpr, (31<<PA0) ; 00011111
out PORTA, mpr

;****POWER_ON***
	ldi mpr, 0x50
	rcall transmit
	ldi mpr, 0x4f
	rcall transmit
	ldi mpr, 0x57
	rcall transmit
	ldi mpr, 0x45
	rcall transmit
	ldi mpr, 0x52
	rcall transmit
	ldi mpr, 0x5f
	rcall transmit
	ldi mpr, 0x4f
	rcall transmit
	ldi mpr, 0x4e
	rcall transmit
	


rjmp MAIN
;***************************************************************
;* Func: MAIN
;***************************************************************


MAIN:
;**** Проверка нажатия кнопки

CLI
LDI R16, (1<<COM00)|(1<<CS00)|(1<<CS01)|(1<<CS02)
OUT TCCR0, R16
LDI R16, 0xFF
OUT OCR0, R16
SET


	BUTTON1:
	sbic PINA, 0 ;Проверка нажатия 1й кнопек на PA0 Если нажата
	rjmp BUTTON1        				;пропускает следующую команду

;**** Запуск АЦП
	in mpr, ADCSRA ;сохранение параметров ADCSRA
	sbr mpr, 64		;записывем в 6 бит 1
	out ADCSRA, mpr ;возвращаем исправленные данные в ADCSRA

;**** Задержка
;rcall Delay ;Задержка для кнопки

;**** Ожидание завершения преобразования АЦП
	ACP:
	sbis ADCSRA,4
	rjmp ACP


;**** Считывание из АЦП
	in mpr, ADCH

	rcall transmit
	
;**** Считывание из АЦП
//	in mpr, ADCL
//	rcall transmit








rjmp MAIN ; Loop Indefinitly

;***************************************************************
;* Func: Delay
;***************************************************************

Delay:
	push R16
	ldi R16,0xff
	ldi R18, 0xff
	wt1:
		dec R16
		
	wt2:
		dec R18
		brne wt2
	brne wt1
	pop R16
ret

;***************************************************************
;* Func: transmit
;***************************************************************

transmit:
	lds mpr, UCSR1A
	sbrs mpr, UDRE1 ;
;	rjmp transmit
	sts UDR1, mpr ; 
ret

