# Booting

## Make Exception Vector Table

```S
.text
    .code 32

    .global vector_start
    .global vector_end

    vector_start: ; Exception Vector Table
        LDR     PC, reset_handler_addr
        LDR     PC, svc_handler_addr
        LDR     PC, pftch_abt_handler_addr
        LDR     PC, data_abt_handler_addr
        B       .
        LDR     PC, irq_handler_addr
        LDR     PC, fiq_handler_addr

        reset_handler_addr:     .word reset_handler
        undef_handler_addr:     .word dummy_handler
        svc_handler_addr:       .word dummy_handler
        pftch_abt_handler_addr: .word dummy_handler
        data_abt_handler_addr:  .word dummy_handler
        irq_handler_addr:       .word dummy_handler
        fiq_handler_addr:       .word dummy_handler
    vector_end:
        
    reset_handler: ; read SYS_ID
        LDR     R0, =0x100000000
        LDR     R1, [R0]

    dummy_handler: ; loop
        B .
.end

```

### Exception

**익셉션(exception)** 이란 주변장치(peripheral) 등에서 발생한 신호를 처리하기 위해 **순차적으로 진행하던 프로그램의 수행을 끊는 것**을 말합니다.

### Abort

Abort에 대한 일반적인 정의는 **어디서 문제가 일어났는지 보고하지 않고 프로그램의 동작이 더 이상 진행되지 않도록 하는 것**입니다. ARM에서 abort는 인터럽트(현재로는 인터럽트를 익셉션과 거의 동일한 동작을 한다고 정의하였습니다.)와 함께 익셉션의 한 종류로 정의되어 있습니다. ARM에서는 다음 세 가지 경우에 abort가 발생합니다.

* **MCPU(Memory Protection Unit)** 로 **보호되는 메모리 영역에 접근 권한 없이 접근 했을 때**
* **AMBA(SoC(System on Chip)** 의 주변장치 연결 및 관리를 위한 공개 표준) **메모리 버스가 에러를 응답**했을 때
* **ECC(Error Correcting Code)** **로직에서 에러가 발생**하였을 때

### Exception Vector Table Config

* **Reset(0x0)**: 전원이 켜지면 실행되는 명령
* **Undefined Instruction(0x04)**: 잘못된 명령어를 실행하였을 때
* **SVC(Supervisor Call)(0x08)**:  SVC 명령으로 발생시키는 익셉션
* **Prefetch Abort(0x0C)**: 명령어 메모리에서 명령어를 읽다가 문제가 생김
* **DataAbort(0x10)**: 데이터 메모리에서 데이터를 읽다가 문제가 생김
* **Notused(0x14)**: 사용하지 않음
* **IRQ interrupt(0x18)**: IRQ 인터럽트가 발생하였을 때
* **FIQ interrupt(0x1C)**: FIQ 인터럽트가 발생했을 때

## Debugging

```s
r0             0x0                 0
r1             0xe59ff014          -442503148
r2             0x0                 0
r3             0x0                 0
r4             0x0                 0
r5             0x0                 0
r6             0x0                 0
r7             0x0                 0
r8             0x0                 0
r9             0x0                 0
r10            0x0                 0
r11            0x0                 0
r12            0x0                 0
sp             0x0                 0x0
lr             0x0                 0
pc             0x40                0x40
cpsr           0x400001d3          1073742291
```
