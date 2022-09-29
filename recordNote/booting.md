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

## Stack 구현하기

스택은 **메모리를 반대 방향으로 사용**합니다.  
**ex)** 0x00009089 주소에 데이터를 쓰면 스택에서는 그다음 0x00009084 주소에 데이터를 씁니다.  
그래서 스택을 초기화할 때는 아래의 간단한 공식으로 스택 꼭대기 메모리 주소를 구한 다음 그 값을 사용합니다.  
  
`스택의 꼭대기 주소 = 스택의 시작 주소 + 스택의 크기 - 4`

### Code

```c
#define INST_ADDR_START     0                                               // 스택의 시작 주소를 설정합니다.
#define USRSYS_STACK_START  0x00100000
#define SVC_STACK_START     0x00300000
#define IRQ_STACK_START     0x00400000                  
#define FIQ_STACK_START     0x00500000
#define ABT_STACK_START     0x00600000
#define UND_STACK_START     0x00700000
#define TASK_STACK_START    0x00800000
#define GLOBAL_ADDR_START   0x04800000
#define DALLOC_ADDR_START   0x04900000

#define INST_MEM_SIZE       (USRSYS_STACK_START - INST_ADDR_START)          // 스택의 크기를 구합니다.
#define USRSYS_STACK_SIZE   (SVC_STACK_START - USRSYS_STACK_START)
#define SVC_STACK_SIZE      (IRQ_STACK_START - SVC_STACK_START)
#define IRQ_STACK_SIZE      (FIQ_STACK_START- IRQ_STACK_START)
#define FIQ_STACK_SIZE      (ABT_STACK_START - FIQ_STACK_START)
#define ABT_STACK_SIZE      (UND_STACK_START - ABT_STACK_START)
#define UND_STACK_SIZE      (TASK_STACK_START - UND_STACK_START)
#define TASK_STACK_SIZE     (GLOBAL_ADDR_START - TASK_STACK_START)
#define DALLOC_MEM_SIZE     (55 * 1024 * 1024)
                                                                            // 스택의 꼭대기 주소를 구합니다.
#define USRSYS_STACK_TOP    (USRSYS_STACK_START + USRSYS_STACK_SIZE - 4)    // -4byte는 값을 비우기 위해(padding) 사용하지 않습니다.
#define SVC_STACK_TOP       (SVC_STACK_START + SVC_STACK_SIZE - 4)          // -4byte로 구분함으로서 스택과 스택 사이를 구분하는 데에 사용하기도 합니다.
#define IRQ_STACK_TOP       (IRQ_STACK_START + IRQ_STACK_SIZE - 4)
#define FIQ_STACK_TOP       (FIQ_STACK_START + FIQ_STACK_SIZE - 4)
#define ABT_STACK_TOP       (ABT_STACK_START + ABT_STACK_SIZE - 4)
#define UND_STACK_TOP       (UND_STACK_START + UND_STACK_SIZE - 4)
```
