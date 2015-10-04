@ECHO OFF
"C:\Program Files\Atmel\AVR Tools\AvrAssembler2\avrasm2.exe" -S "D:\Progects\Atmega128\labels.tmp" -fI -W+ie -C V2E -o "D:\Progects\Atmega128\Atmega128.hex" -d "D:\Progects\Atmega128\Atmega128.obj" -e "D:\Progects\Atmega128\Atmega128.eep" -m "D:\Progects\Atmega128\Atmega128.map" "D:\Progects\Atmega128\Atmega128.asm"
