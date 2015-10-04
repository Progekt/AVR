/*
 * GccApplication1.c
 *
 * Created: 14.02.2015 23:58:11
 *  Author: Ярослав
 *
 *Секундомер Привет АЦП
 */ 


#include <avr/io.h>
#define F_CPU 16000000UL
#include <util/delay.h>
#include <avr/interrupt.h>
#include <avr/eeprom.h>

unsigned int ACH=0, ACL=0;

char X=0;
char M=0;
char H=0;
char q=0;
unsigned int i=0;
uint8_t w EEMEM; // объявил переменную в еепром


void InitPorts() //Инициализация портов
{
	PORTA=0; DDRA=0x40; //Кнопки
	PORTC=0; DDRC=0xF7; //Дисплей
	PORTB=0; DDRB=0xff;//диоды
}

void InitT0() //Подключение часового кварца к Т0
{
	cli();//глобальное отключение прирываний
	TIMSK=0;//сброс прерывания таймера по переполнению и совпадению
	ASSR=(1<<AS0);//включен Асинхронный режим
	TCCR0=(1<<CS00)|(1<<CS02)|(1<<WGM01);//Сброс при совпадении (режим работы таймера)// ДЕЛИТЕЛЬ НА128
	OCR0=0XFF; //Регистр совпадения T0
	TIMSK=(1<<OCIE0);//Разрешение прерываний при совпадении OCR0 и TCNT0
	TIFR=0;//хз зачем
	}

void E_puls()
{
	PORTC=PORTC|0b00000100; //Установка Е
	_delay_us(100);
	PORTC=PORTC&0b11111011;//Отключение Е
	
}

void InitLCD() //Инициализация дисплея LCD
{
	_delay_ms(250);//1 сек
	_delay_ms(250);
	_delay_ms(250);
	_delay_ms(250);
	
	PORTC=0b00110000;
	PORTC|=(1<<2);//E
	PORTC&=~(1<<2);
	_delay_ms(5);
	
	PORTC=0b00110000;
	PORTC|=(1<<2);//E
	PORTC&=~(1<<2);
	_delay_us(100);
	
	PORTC=0b00110000;
	PORTC|=(1<<2);//E
	PORTC&=~(1<<2);
	_delay_us(200);
	
	PORTC=0b00100000;
	PORTC|=(1<<2);//E
	PORTC&=~(1<<2);
	_delay_us(100);
	
	PORTC=0b00100000;
	PORTC|=(1<<2);//E
	PORTC&=~(1<<2);
	PORTC=0b11000000;
	PORTC|=(1<<2);//E
	PORTC&=~(1<<2);
	_delay_us(100);
	
	PORTC=0b00000000;
	PORTC|=(1<<2);//E
	PORTC&=~(1<<2);
	PORTC=0b11000000; //курсор
	PORTC|=(1<<2);//E
	PORTC&=~(1<<2);
	_delay_us(100);
	
	PORTC=0b00000000;
	PORTC|=(1<<2);//E
	PORTC&=~(1<<2);
	PORTC=0b00010000;
	PORTC|=(1<<2);//E
	PORTC&=~(1<<2);
	_delay_us(100);
	
	PORTC=0b00000000;
	PORTC|=(1<<2);//E
	PORTC&=~(1<<2);
	PORTC=0b01000000;
	PORTC|=(1<<2);//E
	PORTC&=~(1<<2);
	_delay_ms(2);
}

void LCD_data(unsigned char p)//р байт данных
{
	PORTC|=(1<<0)|(1<<2);//RS=1 запись данных E=1 установка записи 
	_delay_us(100);
	PORTC&=0x0F;//чистим старшие биты на порту
	PORTC|=(p&0xF0);//отделяем и записываем старший нибл р
	_delay_us(100);
	PORTC&=~(1<<2);//Е=0 окончание записи
	_delay_us(100);
	PORTC|=(1<<2);//E=1 установка записи
	_delay_us(100);
	PORTC&=0x0F;//чистим старшие биты на порту
	PORTC|=(p<<4);//Сдвигаем младшии биты на левои записываем в порт
	_delay_us(100);
	PORTC&=~(1<<2);//Е=0 окончание записи
	_delay_us(100);
}

ISR(TIMER0_COMP_vect)//прерываниеТаймера Т0
{
	X=X+1;//щетчик
	PORTB^=(1<<0);//инвертирование порта
}

ISR(ADC_vect)//Прерывание по АЦП
{
	//double A=0;
	ACH=ADCW;
	ADCSRA &= (~(1<<ADIE));// Запрещает прерывания

}

void Tamperatyra()
{
	PORTC=0b10000000; //Установка курсора на 0C Первая часть
	PORTC|=(1<<2);//E
	PORTC&=~(1<<2);
	PORTC=0b11000000; //Установка курсора на 0C Вторая часть		
	PORTC|=(1<<2);//E
	PORTC&=~(1<<2);
	
	if (ACH>=474)
	{
		LCD_data(0x20);
		
		ACL=(ACH-474)/1.6; //Расчет температуры из ацп	
	} 
	else
	{
	
	LCD_data(0x2D);//-
		
		ACL=(474-ACH)/1.6; //Расчет температуры из ацп
	}
}

void ADCtest()
	{
		//Вывод АЦП
/*	PORTC=0b11000000; //Установка курсора на 4С Первая часть
	PORTC|=(1<<2);//E
	PORTC&=~(1<<2);
	PORTC=0b11000000; //Установка курсора на 4С Вторая часть		
	PORTC|=(1<<2);//E
	PORTC&=~(1<<2);
*/
//РАсчет АЦП для LCD
		
	i=(ACL/10); //находим десятки ADCH
		
	LCD_data(i+0x30);//вывод десятков
	
	ACL=ACL-(i*10);//Удаление десятков
		
	LCD_data(ACL+0x30);//Выводим еденицы
	}

void INITADC() //Инициализация АЦП
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


void MiganieH()
{
				PORTC=0b00000000; //Установка курсора в начало
				PORTC|=(1<<2);//E
				PORTC&=~(1<<2);
				PORTC=0b00100000;
				PORTC|=(1<<2);//E
				PORTC&=~(1<<2);
				_delay_us(100);
				_delay_ms(500);
				LCD_data(0x20);//Гасит часы
				LCD_data(0x20);
				_delay_ms(500);
		

	i=PINA;
	if ((i&(1<<2))==0)
	{
	_delay_ms(150);
	q=2;
	}
	
	if ((i&(1<<0))==0)//Нажатие кнопки вверх
	{
		_delay_ms(150);
		H++;
	}
	if ((i&(1<<4))==0)//Нажатие кнопки Вниз
	{
		_delay_ms(150);
		H--;
	}
		
}

void MiganieM() // Мигание Минут
{
	PORTC=0b10000000; //Установка курсора по адресу
	PORTC|=(1<<2);//E
	PORTC&=~(1<<2);
	PORTC=0b00110000;//адрес 0х03 вторая строка
	PORTC|=(1<<2);//E
	PORTC&=~(1<<2);
	_delay_us(100);
	
	_delay_ms(500);
				LCD_data(0x20);//Гасит Минуты
				LCD_data(0x20);
				_delay_ms(500);
			i=PINA;
	if ((i&(1<<2))==0)
	{
	_delay_ms(150);
	q=0;
	}
	
	if ((i&(1<<0))==0)//Нажатие кнопки вверх
	{
		_delay_ms(150);
		M++;
	}
	if ((i&(1<<4))==0)//Нажатие кнопки Вниз
	{
		_delay_ms(150);
		M--;
	}
}

int main(void)
{

	InitPorts();//Инициализация портов
	InitT0();//Инициализация асинхронного таймера Т0
	InitLCD();//Инициализация дисплея LCD
	INITADC();//Инициализация АЦП
	sei();

	//Символ термометра
	unsigned int t[8]={0x4,0xA,0xA,0xE,0xE,0x1F,0x17,0xE};
	PORTC=0b01000000; //Установка курсора по адресу
	PORTC|=(1<<2);//E
	PORTC&=~(1<<2);
	PORTC=0b00000000;//адрес 0х00 вторая строка
	PORTC|=(1<<2);//E
	PORTC&=~(1<<2);
	_delay_us(100);
	
	for (i=0;i<8;i++)
	{
		LCD_data(t[i]);
	}
	//Вывод градусника
	PORTC=0b10000000; //Установка курсора по адресу
	PORTC|=(1<<2);//E
	PORTC&=~(1<<2);
	PORTC=0b10110000;//адрес 0х0B вторая строка
	PORTC|=(1<<2);//E
	PORTC&=~(1<<2);
	_delay_us(100);
	
	LCD_data(0);
	//вывод С
	PORTC=0b10000000; //Установка курсора по адресу
	PORTC|=(1<<2);//E
	PORTC&=~(1<<2);
	PORTC=0b11110000;//адрес 0х0E вторая строка
	PORTC|=(1<<2);//E
	PORTC&=~(1<<2);
	_delay_us(100);
	//LCD_data(0x6F);
	LCD_data(0x43);
	
	
	PORTC=0b11000000; //Установка курсора по адресу
	PORTC|=(1<<2);//E
	PORTC&=~(1<<2);
	PORTC=0b00000000;//адрес 0х40 вторая строка
	PORTC|=(1<<2);//E
	PORTC&=~(1<<2);
	_delay_us(100);
	
	LCD_data('H');
	LCD_data('e');	
	LCD_data('l');
	LCD_data('l');
	LCD_data('o');	
	
	while(1)
	{
	
		PORTC=0b00000000; //Установка курсора в начало
		PORTC|=(1<<2);//E
		PORTC&=~(1<<2);
		PORTC=0b00100000;
		PORTC|=(1<<2);//E
		PORTC&=~(1<<2);
		_delay_us(100);	
		
	
		if (X>59) //Секунды
			{ 
			X=0;
			M=M+1;
			}
		if (M>59) //Минуты
			{ 
			M=0;
			H=H+1;
			}
		if (H>23) //Часы
			{ 
			H=0;
			}
	
	//вычисление визуальных данных для дисплея
		
	PORTC=0b00000000; //Установка курсора в начало
	PORTC|=(1<<2);//E
	PORTC&=~(1<<2);
	PORTC=0b00100000;
	PORTC|=(1<<2);//E
	PORTC&=~(1<<2);
	_delay_us(100);
	
	i=H/10;//первая часть часа
	i=i+0x30;
	LCD_data(i);
	
	if(H<9)
	{
		i=H+0x30;
		LCD_data(i);
	}
	else
	{
		i=H-((i-0x30)*10);//вторая часть часа
		i=i+0x30;
		LCD_data(i);	
	}	
	LCD_data(':');
	
	i=M/10;//первая часть минут
	i=i+0x30;
	LCD_data(i);		
	
	if(M<9)
	{
		i=M+0x30;
		LCD_data(i);
	}
	else
	{
		i=M-((i-0x30)*10);//вторая часть минут
		i=i+0x30;
		LCD_data(i);	
	}
	LCD_data(':');
	
	i=X/10;//первая часть секунд
	i=i+0x30;
	LCD_data(i);		
	if(i==0)
	{
		i=X+0x30;
		LCD_data(i);
	}
	else
	{
		i=X-((i-0x30)*10);//вторая часть секунд
		i=i+0x30;
		LCD_data(i);	
	}
		
	//Вывод АЦП
	Tamperatyra();
	
	if (ACL<=2)//вкл реле при Т<2
	{
		PORTA|=(1<<6);
	}
	
	if (ACL>=5)//выкл реле при Т>5
	{
		PORTA&=~(1<<6);
	}
	
	ADCtest();
	
/*	
	PORTC=0b10000000; //Установка курсора на 0С Первая часть
	PORTC|=(1<<2);//E
	PORTC&=~(1<<2);
	PORTC=0b11000000; //Установка курсора на 0С Вторая часть		
	PORTC|=(1<<2);//E
	PORTC&=~(1<<2);

//РАсчет АЦП для LCD
		
	//i=(ACH/1000); //находим тысячи ADCH
	//LCD_data(i+0x30);//вывод сотен
	
	//ACH=ACH-(i*1000);//Удаление тысяч
	i=(ACH/100); //находим сотни ADCH
		
	LCD_data(i+0x30);//вывод сотен
	
	ACH=ACH-(i*100);//Удаление сотен
	
	i=(ACH/10); //находим десятки ADCH
		
	LCD_data(i+0x30);//вывод десятков
	
	ACH=ACH-(i*10);//Удаление десятков
		
	LCD_data(ACH+0x30);//Выводим еденицы

*/
	
	ADCSRA |= (1<<ADIE);//Вкл прерывание по ацп
	
	
	//Нажатие кнопки
	
	i=PINA;//считываем порт
	if ((i&(1<<2))==0)
	{
			_delay_ms(500);
			i=PINA;
			if ((i&(1<<2))==0)
			{
				_delay_ms(100);
				q=1;
			}
	}
	if ((i&(1<<1))==0)//eeprom	
	{
		_delay_ms(200);
		eeprom_write_byte(&w ,q);
	}
	if ((i&(1<<3))==0)//eeprom	
	{ 
		_delay_ms(200);
		q=eeprom_read_byte(&w);//читает
		
		PORTC=0b11000000; //Установка курсора по адресу
		PORTC|=(1<<2);//E
		PORTC&=~(1<<2);
		PORTC=0b01100000;//адрес 0х46 вторая строка
		PORTC|=(1<<2);//E
		PORTC&=~(1<<2);
		_delay_us(100);
		LCD_data(q+0x30);	
	}
	
	
	if (q==1)     //Запуск мигания Часы
	{
		MiganieH();
	}
	if (q==2)     //Запуск мигания Часы
	{
		MiganieM();
	}
	
	
	}
}