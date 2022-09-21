echo install gcc-arm-none-eabi..
sudo apt install gcc-arm-none-eabi -y
echo arm-none-eabi-gcc Version:
arm-none-eabi-gcc -v
echo
echo install qemu-system-arm..
sudo apt install qemu-system-arm -y
echo qemu-system-arm Version:
qemu-system-arm --version
echo
echo
echo VM에서 사용할 ARM System 지원 가능 기기
echo
qemu-system-arm -M ?
echo
