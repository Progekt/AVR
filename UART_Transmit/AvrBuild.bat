@ECHO OFF
"C:\Program Files\Atmel\AVR Tools\AvrAssembler2\avrasm2.exe" -S "D:\Progects\UART_Transmit\labels.tmp" -fI -W+ie -C V2E -o "D:\Progects\UART_Transmit\UART_Transmit.hex" -d "D:\Progects\UART_Transmit\UART_Transmit.obj" -e "D:\Progects\UART_Transmit\UART_Transmit.eep" -m "D:\Progects\UART_Transmit\UART_Transmit.map" "D:\Progects\UART_Transmit\UART_Transmit.asm"
