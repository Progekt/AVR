;***************************************************************
;*
;* Project Name Here
;*
;* Project Description Here
;*
;***************************************************************
;*
;* Author: Your Name
;* Lab: Lab Number Here
;* Date: Enter the date Here
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
;* Desc: Reset Handler Routine
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


rjmp MAIN
;***************************************************************
;* Func: MAIN
;* Desc: Main Entry into program
;***************************************************************

MAIN:
;< Insert your program Here>
rjmp MAIN ; Loop Indefinitly
