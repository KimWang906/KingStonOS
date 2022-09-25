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

## Disassemble Code

```S
KingStone.axf:     file format elf32-littlearm


Disassembly of section .text:

00000000 <vector_start>:
   0:   e1a00001        mov     r0, r1

00000004 <vector_end>:
        ...

Disassembly of section .ARM.attributes:

00000000 <.ARM.attributes>:
   0:   00002441        andeq   r2, r0, r1, asr #8
   4:   61656100        cmnvs   r5, r0, lsl #2
   8:   01006962        tsteq   r0, r2, ror #18
   c:   0000001a        andeq   r0, r0, sl, lsl r0
  10:   726f4305        rsbvc   r4, pc, #335544320      ; 0x14000000
  14:   2d786574        cfldr64cs       mvdx6, [r8, #-464]!     ; 0xfffffe30
  18:   06003841        streq   r3, [r0], -r1, asr #16
  1c:   0841070a        stmdaeq r1, {r1, r3, r8, r9, sl}^
  20:   44020901        strmi   r0, [r2], #-2305        ; 0xfffff6ff
  24:   Address 0x0000000000000024 is out of bounds.
```

## GDB로 실행파일 확인해보기

```S
(gdb) target remote:1234
Remote debugging using :1234
warning: No executable has been specified and target does not support
determining executable automatically.  Try using the "file" command.
0x00000000 in ?? ()

(gdb) x/4x 0
0x0:    0xe1a00001      0x00000000      0x00000000      0x00000000
```

## [Readme로 돌아가기](/readme.md)