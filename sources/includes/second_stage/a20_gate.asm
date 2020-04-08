check_a20_gate:
    pusha ; saving all the general purpose registors in the stack again

    ; This function need to be written by you.
    mov ax,0x2402   ;intitiating the function 2402 to be stored in ax
    int 0x15        ; intitiating the int 15 to check a20 gate with the corresponding fn number
    jc .error       ; checking the carry flag and jumping to the error label 
    cmp al,0x0      ;  comparing the al with 0x0 as a result from the int 15 
    je .enable_a20  ; if equal enable the a20 gate 

    popa    ;retreive the general purpose registers again from the stack
    ret     ; return to the call 
