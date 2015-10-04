@ECHO OFF
"E:\Program Files\Atmel\AVR Tools\AvrAssembler2\avrasm2.exe" -S "J:\Blink_Deod\labels.tmp" -fI -W+ie -o "J:\Blink_Deod\Blink_Deod.hex" -d "J:\Blink_Deod\Blink_Deod.obj" -e "J:\Blink_Deod\Blink_Deod.eep" -m "J:\Blink_Deod\Blink_Deod.map" "J:\Blink_Deod\Blink_Deod.asm"
