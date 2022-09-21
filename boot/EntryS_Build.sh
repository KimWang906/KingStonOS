arm-none-eabi-as -march=armv7-a -mcpu=cortex-a8 -o Entry.o Entry.S # arm-none-eabi-as를 포함한 명령이 어셈블리어 소스파일을 컴파일하는 명령입니다.
arm-none-eabi-objcopy -O binary Entry.o Entry.bin # Entry.o에서 arm-none-eabi-objcopy 명령으로 바이너리만 추출합니다.
hexdump Entry.bin # hexdump 명령으로 바이너리 내용을 확인합니다.
