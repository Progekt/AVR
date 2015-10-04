@ECHO OFF
"C:\Program Files\Atmel\AVR Tools\AvrAssembler2\avrasm2.exe" -S "D:\Progects\DPCU\labels.tmp" -fI -W+ie -C V2E -o "D:\Progects\DPCU\DPCU.hex" -d "D:\Progects\DPCU\DPCU.obj" -e "D:\Progects\DPCU\DPCU.eep" -m "D:\Progects\DPCU\DPCU.map" "D:\Progects\DPCU\DPCU.asm"
