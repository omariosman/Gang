check_a20_gate:
    pusha                                   ; Save all general purpose registers on the stack

            ; This function need to be written by you.
    mov ax,0x2402
    int 0x15
    jc .error
    cmp al,0x0
    je .enable_a20

    popa                                ; Restore all general purpose registers from the stack
    ret
