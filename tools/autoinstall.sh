echo install gcc-arm-none-eabi..
sleep 2
sudo apt install gcc-arm-none-eabi -y
echo arm-none-eabi-gcc Version:
arm-none-eabi-gcc -v
sleep 5
echo
echo install qemu-system-arm..
sleep 2
sudo apt install qemu-system-arm -y
echo qemu-system-arm Version:
qemu-system-arm --version
sleep 5
echo
echo
echo VM에서 사용할 ARM System 지원 가능 기기
echo
qemu-system-arm -M ?
echo
sleep 5
