#include <avr/io.h>
#include <avr/interrupt.h>
#include <avr/signal.h>

unsigned int A=0;  //Переменные для расчета сегментов
unsigned int B=0;
unsigned int C=0;
unsigned int i=0;

void INIT() //инициализация кнопок и констант
{
PORTB=0; DDRB=0xff;
PORTG=0; DDRG=0b11;//          0 1  2  3   4   5   6  7  8   9
const unsigned int buffer[9]={63,6,91,79,102,109,125,7,127,111};
PORTA=0; DDRA=0; //Вход кнопки
}

void raschet()
{
B=A/10;
Numeral(B);
C=A-B;
Numeral(C);
}

void Numeral(int temp) //База чисел 0...9
{
switch (temp)
	{
	case 0: PORTB = buffer[0];
	case 1: PORTB = buffer[1];
	case 2: PORTB = buffer[2];
	case 3: PORTB = buffer[3];
	case 4: PORTB = buffer[4];
	case 5: PORTB = buffer[5];
	case 6: PORTB = buffer[6];
	case 7: PORTB = buffer[7];
	case 8: PORTB = buffer[8];
	case 9: PORTB = buffer[9];
	default: PORTB = buffer[0];
	}
}


int main(void)
{
а=i++

i=PINA; //Считываем порт ввода
if ((1<<PA1)&i)
	{
	A=A++ //увеличиваем А	
	raschet();
	
	}


return 0;
}
