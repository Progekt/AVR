/*
 * GccApplication1.c
 * 7 сегментный дисплей
 * Created: 13.07.2014 19:26:57
 *  Author: Ярослав
 */ 


#include <avr/io.h>
#define F_CPU 16000000UL
#include <util/delay.h>
#include <avr/interrupt.h>
//#include <avr/signal.h>
unsigned int qbuffer[]={0x40,0x79,0x24,0x30,0x19,0x12,0x2,0x78,0x0,0x10,0x79};
float A=0;  //Переменные для расчета сегментов
unsigned int B=0;
unsigned int C=0;
unsigned int i=0;

void Stop() //Остановка актуатора
{
	while (1)
	{
		i=PINA; //Считываем порт ввода
		if ((i & (1<<4)) == 0 ) //Проверка нажатия кнопки Стоп
		{
		_delay_ms(200);
		PORTE=0;
		break;
		}	
	}
}

int Numeral(int temp) //База чисел 0...9
{
switch (temp)
	{
	case (0): PORTB = qbuffer[0];
	break;
	case (1): PORTB = qbuffer[1];
	break;
	case (2): PORTB = qbuffer[2];
	break;
	case (3): PORTB = qbuffer[3];
	break;
	case (4): PORTB = qbuffer[4];
	break;
	case (5): PORTB = qbuffer[5];
	break;
	case (6): PORTB = qbuffer[6];
	break;
	case (7): PORTB = qbuffer[7];
	break;
	case (8): PORTB = qbuffer[8];
	break;
	case (9): PORTB = qbuffer[9];
	break;
	case (10): PORTB = qbuffer[10];
	break;
	default: PORTB = qbuffer[0];
	break;
	}
}


void raschet()
{
PORTB=0;
B=A/10;

if (PORTG==0b1)
	{
	PORTG=0b10;
	Numeral(B);	
	}
else
	{
	B=B*10;
	C=A-B;
	PORTG=0b1;
	Numeral(C);	
	}

}




ISR( TIMER1_OVF_vect )// Прерывание по переполнению таймера
{
raschet();	
TCNT1 = 6380;
}

ISR(ADC_vect)//Прерывание по АЦП
{
	A=ADCH/2.57;//перевод в проценты.
}

void INITtimer() //инициализация таймер
{ 
 TCCR1B = (0<<CS12)|(0<<CS11)|(1<<CS10); // настраиваем делитель 1024
// TCCR1B = (0<<CS12)|(0<<CS11)|(1<<CS10);// делитель 1
 TIMSK |= (1<<TOIE1); // разрешаем прерывание по переполнению таймера
 TCNT1 = 6380;        // выставляем начальное значение TCNT1 для 100Гц
 
}

void INITADC() //Инициализация АЦП
{
	ADMUX |= (0<<REFS1)|(1<<REFS0);// Опорное напряжение AVCC
	ADMUX |= (0<<MUX3)|(0<<MUX2)|(0<<MUX1)|(0<<MUX0); //Выбор АЦП
	ADMUX |= (1<<ADLAR);//Выравнивание по левому краю результата
	ADCSRA |= (1<<ADEN);//Вкл АЦП
	ADCSRA |= (1<<ADPS2)|(1<<ADPS1)|(1<<ADPS0);//Делитель частоты 128
	ADCSRA |= (1<<ADIE);// Разрешить прерывания
	ADCSRA |= (1<<ADFR);//Срабатывает автоматически
	ADCSRA |= (1<<ADSC);//Запуск 1го преобразования
	
}

void INIT() //инициализация кнопок и констант
{
PORTB=0; DDRB=0xff;//Выход Дисплей
PORTG=0; DDRG=0b11;//Вывод переключатель дисплея
PORTA=0; DDRA=0; //Вход кнопки
PORTC=0; DDRC=0xff; //Выход светодиоды
PORTE=0; DDRE=0xff; //Выход Реле и Ключ
}

int main(void)
{

INIT();														
INITADC();
INITtimer();

sei();                // выставляем бит общего разрешения прерыва
unsigned int ACP=1;
PORTC=1;//1й светодиод актуатора1
while (1)
{
	i=PINA; //Считываем порт ввода

	if ((i & (1<<0)) == 0 ) //Проверка нажатия кнопки переключения АЦП
	{
	
	ADCSRA &= (~(1<<ADEN));//Выкл АЦП
	_delay_ms(200);
	ACP=ACP+1;
		
	switch(ACP)
		{
		case (1): ADMUX ^= (1<<MUX1)|(1<<MUX0);//Выбор АЦП1
		PORTC=0b0001;//1й светодиод актуатора1
		break;
		case (2): ADMUX |= (1<<MUX0); //Выбор АЦП2
		PORTC=0b0010;//2й светодиод актуатора1
		break;
		case (3): ADMUX ^= (1<<MUX1)|(1<<MUX0); //Выбор АЦП3
		PORTC=0b0100;//3й светодиод актуатора1
		break;
		case (4): ADMUX |= (1<<MUX0); //Выбор АЦП4
		ACP=0;
		PORTC=0b1000;//4й светодиод актуатора1
		break;
		}
	ADCSRA |= (1<<ADEN);//Вкл АЦП	
	//ADCSRA |= (1<<ADFR);//Срабатывает вручную
	ADCSRA |= (1<<ADSC);//Запуск 1го преобразования
		}
	
	if ((i & (1<<1)) == 0 ) //Проверка нажатия кнопки Ручной режим
	{
		_delay_ms(200);
		
			if ((i & (1<<2)) == 0 ) //Проверка нажатия кнопки Вперед
		{
			_delay_ms(200);
			switch(ACP)
				{
					case (1): PORTE|=(1<<PE2);
					break;
					case (2): PORTE|=(1<<PE3);
					break;
					case (3): PORTE|=(1<<PE4);
					break;
					case (4): PORTE|=(1<<PE5);
					break;
				}
			_delay_ms(200);
			PORTE|=(1<<6); //Подаем на ключ PE6
			Stop();
		}	
			if ((i & (1<<3)) == 0 ) //Проверка нажатия кнопки Назад
		{
			_delay_ms(200);
			switch(ACP)
				{
					case (1): PORTE|=(1<<PE2);
					break;
					case (2): PORTE|=(1<<PE3);
					break;
					case (3): PORTE|=(1<<PE4);
					break;
					case (4): PORTE|=(1<<PE5);
					break;
				}
			_delay_ms(200);			
			PORTE|=(1<<7); //Подаем на ключ PE7
			Stop();
		}	
	}	
}
return 0;
}
