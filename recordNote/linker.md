# Linker Script

QEMU가 firmware 파일을 읽어서 부팅하려면 입력으로 지정한 firmware binary 파일이 ELF 형식이어야 합니다.  
ELF 파일을 만드려면 링커(linker)의 도움이 필요합니다. 링커는 여러 Object 파일을 묶어서(linking) 하나의 실행 파일로 만드는 프로그램입니다.
링커 파일의 이름은 `KingSton_linker.ld`입니다.

```ld
ENTRY(vector_start)         /* ENTRY 지시어는 시작 위치의 심벌을 정합니다. */
SECTIONS                    /* SECTIONS 지시어는 블록이 섹션 배치 설정 정보를 가지고 있는 것이라고 알려주는 것입니다. */
{
    . = 0x0;                /* 첫 번째 섹션이 메모리 주소 0x00000000에 위치한다는 것을 알려줍니다. */


    .text :                 /* .text는 text 섹션의 배치 순서를 지정합니다.
    {                          추가 정보를 입력하면 배치 메모리 주소까지 지정할 수 있습니다. */
        *(vector_start)     /* 주소 0x00000000에 리셋 벡터가 위치해야 하므로 vector_start 심벌이 먼저 나옵니다. */
        *(.text .rodata)    /* 그 후 .text 섹션이 나오게 됩니다. */
    }

    /* 이어서 data 섹션과 bss 섹션을 연속된 메모리에 배치하도록 설정했습니다. */

    .data :
    {
        *(.data)
    }

    .bss :
    {
        *(.bss)
    }
}
```
