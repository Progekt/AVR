@ECHO OFF
"C:\Program Files\Atmel\AVR Tools\AvrAssembler2\avrasm2.exe" -S "D:\Progects\Progect_Prozvonka\labels.tmp" -fI -W+ie -C V2E -o "D:\Progects\Progect_Prozvonka\Progect_Prozvonka.hex" -d "D:\Progects\Progect_Prozvonka\Progect_Prozvonka.obj" -e "D:\Progects\Progect_Prozvonka\Progect_Prozvonka.eep" -m "D:\Progects\Progect_Prozvonka\Progect_Prozvonka.map" "D:\Progects\Progect_Prozvonka\Progect_Prozvonka.asm"
