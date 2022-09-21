# Entry.S

```S
.text                       ; .text는 .end가 나올 때까지의 모든 코드가 text 섹션이라는 뜻이고,
                            ;이 코드를 바이너리로 변경해서 모아 놓은 것을 실행파일에서는 text 섹션이라고 합니다.

    .code 32                ; 코드가 시작되는 부분이고, 명령어의 크기가 32bit라는 뜻입니다.

                            ; .global은 C 언어의 지시어인 extern(예시: 다른 파일에서 선언된 함수 / 변수)과 같은 일을 합니다.
    .global vector_start    ; vector_start와 vector_end의 주소 정보를 외부 파일에서 심벌로 읽을 수 있게 설정하는 것입니다.
    .global vector_end      ; vector_start와 vector_end를 선언합니다.

    vector_start:
        MOV R0, R1          ; R1의 값을 R0에 넣습니다.(의미 x)
    vector_end:
        .space 1024, 0      ; 해당 위치부터 1024바이트를 0으로 채우라는 의미입니다.
.end                        ; text 섹션이 끝났음을 알리는 지시어입니다.
```
