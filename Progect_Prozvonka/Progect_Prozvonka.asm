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

;инициализируем порты
clr r16 ;обнуляем r16
out DDRA, r16 ;РА вход
out DDRC, r16 ;РC вход
out PORTB, r16 ;Гасим порт PB
out PORTD, r16 ;Гасим порт PD
ldi r16, 0x4 ;00000100
out PORTE, r16 ;Гасим 0,1 PE включаем резистор на 2
ldi r16, 0x3 ; 00000011
out DDRE, r16 ;РЕ 0,1 выходы 2 вход
ldi r16, 0xFC ;11111100
out DDRD, r16 ;PD выход 2,3,4,5,6,7
ser r16 ; Все еденицы
out DDRB, r16 ;PB выход
out PORTA, r16 ;Гасим порт PA
out PORTC, r16 ;Гасим порт PC

//Инициализация USART
ldi r16, 12 ;скорость 4800bps при F=1MHz
out UBRRL, r16
ldi r16,(1<<TXEN) ;разрешаю передачу
out UCSRB,r16
ldi r16, (1<<URSEL)|(3<<UCSZ0); Устанавливаем параметры слова 8data, 1stop bit
out UCSRC,r16
//-----------------------

Button:
	sbic PINE,2 ;Проверка нажатия кнопки, если да перескочить команду
	rjmp Button ;Возврат в начало цикла
	rcall Delay ;Задержка

mein:
	ldi R19,1 ;Счетчик входов
	ldi R18,1 ;Счетчик выходов
	ldi R17,1 ;1 нога порта 
	

	//-------Перебор выходов и отслеживание входов
	X1:
		out PORTB, R17
		ldi R19, 1
		in R16, PINA ; Считываем порт А
		cpi R16, 0 ; из R16 отнимаем 0 Если результат =0 запись в SREG Z=1
		breq A1 ; если Z=1переход в подпрограмму
		rcall prov_vh
		A1:
		clz
		
		in R16, PINC ; Считываем порт C
		ldi R19, 9 ; Счетчик вх =9
		cpi R16, 0 ; из R16 отнимаем 0 Если результат =0 запись в SREG Z=1
		breq A2 ; если Z=0переход в подпрограмму
		rcall prov_vh
		A2:
		clz

		inc R18 ;увеличить счетчик вхна 1
		lsl R17 ; Сдвиг бита в регистре R17 <- (при переполнении в SREG C=1)
		brcc X1 ; переход на Х1 если небыл переполнен R17 С=0
		
		ldi R17, 0 
		out PORTB, R17
		clc ;сброс С
		
		ldi R17, 4 ; установить 3бит порта вх

	X2:
		out PORTD, R17 ; загруска в порт D
		ldi R19, 1
		in R16, PINA ; Считываем порт А
		cpi R16, 0 ; из R16 отнимаем 0 Если результат =0 запись в SREG Z=1
		breq B1 ; если Z=0переход в подпрограмму
		rcall prov_vh
		B1:
		clz
		
		in R16, PINC ; Считываем порт C
		ldi R19, 9 ; Счетчик вх =9
		cpi R16, 0 ; из R16 отнимаем 0 Если результат =0 запись в SREG Z=1
		breq B2 ; если Z=0переход в подпрограмму
		rcall prov_vh
		B2:
		clz

		inc R18 ;увеличить счетчик вхна 1
		lsl R17 ; Сдвиг бита в регистре R17 <- (при переполнении в SREG C=1)
		brcc X2 ; переход на Х2если небыл переполнен R17 С=0

		out PORTD, R17


rjmp Button



//-------------------------Перебор порта входа А или С
prov_vh:
	sbrc R16, 0 ;пропустить команду если бит=0
	rcall transmit ; запустить подпрограмму transmit
	inc R19 ; увел R19 на 1  счетчик вх

	sbrc R16, 1 ;пропустить команду если бит=0
	rcall transmit ; запустить подпрограмму transmit
	inc R19 ; увел R19 на 1  счетчик вх

	sbrc R16, 2 ;пропустить команду если бит=0
	rcall transmit ; запустить подпрограмму transmit
	inc R19 ; увел R19 на 1  счетчик вх

	sbrc R16, 3 ;пропустить команду если бит=0
	rcall transmit ; запустить подпрограмму transmit
	inc R19 ; увел R19 на 1  счетчик вх

	sbrc R16, 4 ;пропустить команду если бит=0
	rcall transmit ; запустить подпрограмму transmit
	inc R19 ; увел R19 на 1  счетчик вх

	sbrc R16, 5 ;пропустить команду если бит=0
	rcall transmit ; запустить подпрограмму transmit
	inc R19 ; увел R19 на 1  счетчик вх

	sbrc R16, 6 ;пропустить команду если бит=0
	rcall transmit ; запустить подпрограмму transmit
	inc R19 ; увел R19 на 1  счетчик вх

	sbrc R16, 7 ;пропустить команду если бит=0
	rcall transmit ; запустить подпрограмму transmit

ret

//---------------Передача данных по USART
transmit:
	sbis UCSRA, UDRE ; Если бит UDRE установлен 1 пропустить след команду
	rjmp transmit
	out UDR, R18 ; отправить счетчик вых
m1:
	sbis UCSRA, UDRE 
	rjmp m1
	out UDR, R19 ; отправить счетчик вх
rcall Delay ;Задержка	
ret


//----------задержка
Delay:
	push R16 ;Сохраняем R16
	push R18 ;Сохраняем R18
	push R19 ;Сохраняем R19
	ldi R16,0xFF ;загружаем в R16 FF
	ldi R18, 0xFF
	wt1:
		dec R16 ; отнимаем 1 от R16
		nop
		nop
		nop
		brne wt1 ; переход если не 0 на wt1
		dec R18
		brne wt1
	pop R19 ; востановление значения R19
	pop R18 ; востановление значения R18
	pop R16 ; востановление значения R16
ret
