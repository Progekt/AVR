@ECHO OFF
"C:\Program Files\Atmel\AVR Tools\AvrAssembler2\avrasm2.exe" -S "D:\Progects\ADC128\labels.tmp" -fI -W+ie -C V2E -o "D:\Progects\ADC128\ADC128.hex" -d "D:\Progects\ADC128\ADC128.obj" -e "D:\Progects\ADC128\ADC128.eep" -m "D:\Progects\ADC128\ADC128.map" "D:\Progects\ADC128\ADC128.asm"
