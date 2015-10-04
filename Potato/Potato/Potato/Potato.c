/*
 * Potato.c
 * 
 * Ящик для картошки
 *
 * Created: 27.09.2015 0:52:04
 *  Author: Ярослав
 */ 


#include <avr/io.h>
#define F_CPU	16000000UL
#include <util/delay.h>
#include <avr/interrupt.h>
#include <avr/eeprom.h>
#include "LCD.h"

unsigned int ACH=0;//переменная считывания АЦП
//unsigned int i=0;//переменнавя для операций
unsigned char S=0;//щетчик секунд
unsigned char M=0;//щетчик минут
unsigned char H=0;//щетчик часов

void InitPorts()//инициализация портов
{
	PORTA=0; DDRA=0x40; //Кнопки
	//PORTC=0; DDRC=0xF7; //Дисплей
}

void InitT0() //Подключение часового кварца к таймеру Т0
{
	TIMSK=0;//сброс прерывания таймера по переполнению и совпадению
	ASSR=(1<<AS0);//включен Асинхронный режим
	TCCR0=(1<<CS00)|(1<<CS02)|(1<<WGM01);//Сброс при совпадении (режим работы таймера)// ДЕЛИТЕЛЬ НА128
	OCR0=0XFF; //Регистр совпадения T0
	TIMSK=(1<<OCIE0);//Разрешение прерываний при совпадении OCR0 и TCNT0
	TIFR=0;//хз зачем
}

void InitADC()//инициализация АЦП
{
	ADMUX |= (0<<REFS1)|(1<<REFS0);// Опорное напряжение AVCC
	ADMUX |= (0<<MUX3)|(0<<MUX2)|(0<<MUX1)|(1<<MUX0); //Выбор АЦП
	ADMUX |= (0<<ADLAR);//Выравнивание по левому краю результата
	ADCSRA |= (1<<ADEN);//Вкл АЦП
	ADCSRA |= (1<<ADPS2)|(1<<ADPS1)|(1<<ADPS0);//Делитель частоты 128
	ADCSRA |= (1<<ADIE);// Разрешить прерывания
	ADCSRA |= (1<<ADFR);//Срабатывает автоматически
	ADCSRA |= (1<<ADSC);//Запуск 1го преобразования
}

void SimvolCG()//Загруска символов термометра и градус
{
	unsigned char t[8]={0x04,0x0A,0x0A,0x0E,0x0E,0x1F,0x17,0x0E};//градусник адрес 0
	unsigned char o[8]={0x02,0x05,0x02,0,0,0,0,0};//градус адрес 0х01
	//загрузка термометра
	LCD_adresCG(0x00);
	_delay_us(100);
	for (unsigned char i=0;i<8;i++)
	{
		LCD_data(t[i]);
	}
	//Загрузка грудус
	LCD_adresCG(0x08);
	_delay_us(100);
	for (unsigned char i=0;i<8;i++)
	{
		LCD_data(o[i]);
	}
}

void Shablon()//Вывод на дисплей градусник, градус, С
{
	//вывод градусник поадресу А
	LCD_adres(0x0A);
	LCD_data(0x00);
	//Вывод градус по пдресу Е
	LCD_adres(0x0E);
	LCD_data(0x01);
	//Вывод буквы С
	LCD_data(0x43);
}

ISR(TIMER0_COMP_vect)//Прерывание по таймеру Т0
{
	S++;//щетчик Секунд
	}

ISR(ADC_vect)//Прерывание по АЦП
{
	ACH=ADCW;//Считывание АЦП
	ADCSRA &= (~(1<<ADIE));// Запрещает прерывания
}

void PrintClok(unsigned char N)//Вывод часов на дисплей
{
	unsigned char i=0;
	while(N>=10)		//N больше или равно 10
	{					//вычитаем десятки и считаем их
		N=N-10;
		i++;
	}
	LCD_data(i+0x30);	//Выводим насчитаные десятки
	LCD_data(N+0x30);	//Выводим оставшиеся еденицы
}

/*/ 	i=N/10;				//осделяем 
// 	LCD_data(i+0x30);
// 	if (i==0)	
// 	{
// 		LCD_data(N+0x30);//Если десятков нет выводим значение
// 	}
// 	else
// 	{
// 		i=N-(i*10);		//Если десятки есть вычитаем их и выводим остаток
// 		LCD_data(i+0x30);
// 	}
*/


void Clok()//Часы Вычисление часов и минут из секунд
{
	 // Мигание :
	LCD_adres(0x02);
	if ((S&(1<<0))==0)
	{
		LCD_data(0x3A); //Загорается :
	} 
	else
	{
		LCD_data(0x20); //Загорается Пробел
	} 
	//Вычисление
	if (S>59)	//Секунды =60 +1минута
	{
		S=0;
		M++;
		if (M>59)	//Минуты =60 +1час
		{
			M=0;
			H++;
			if (H>23)	//Часы >23 обнуляется
			{
				H=0;
			}
		}
	}
	LCD_adres(0x00); //курсор в начало 
	PrintClok(H);
	LCD_adres(0x03);
	PrintClok(M);
	
}

int main(void)
{
	InitPorts();
	InitLCD();
	InitADC();
	InitT0();
	SimvolCG();
	Shablon();
	
	sei();//Глобальное разрешение прерываний
		
    while(1)
    {
		Clok();
		 
	 //cli();//глобальное отключение прерываний

	   
    }
}