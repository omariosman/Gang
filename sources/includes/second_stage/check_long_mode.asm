        check_long_mode:
            pusha                           ; Save all general purpose registers on the stack
            call check_cpuid_support        ; Check if cpuid instruction is supported by the CPU
            call check_long_mode_with_cpuid ; check long mode using cpuid
            popa                            ; Restore all general purpose registers from the stack
            ret

        check_cpuid_support:
            pusha               ; Save all general purpose registers on the stack
                  ; This function need to be written by you.
                pushfd ; Push eflags for restoring them at the end of the subroutine
                pushfd ; Push eflags again to use them for comparison
                pushfd ; Copy flags to eax
                pop eax
                xor eax,0x0200000 ; Flip bit 21
                push eax ; Copy value of eax to the eflags
                popfd
                pushfd ; Copy eflags to eax
                pop eax
                pop ecx ; Copy original eflags to ecx (second pushfd above)
                ; Now if the modified bit 21 is written to the eflags then bit 21 in eax is different from that in eax
                xor eax,ecx ; This means that xoring the two bits will always produce 1
                and eax,0x0200000 ; Zero out all bits except bit 21, it will stay as is
                cmp eax,0x0 ; If eax equal zero this means that bit 21 was not modified in eflags
                jne .cpuid_supported ; Jump to .cpuid_supported if cpuid is supported
                mov si,cpuid_not_supported ; Else print error message and hang as we cannot proceed
                call bios_print
                jmp hang
                .cpuid_supported: ; Print a message indicating that cpuid is supported
                mov si,cpuid_supported
                call bios_print
                popfd



            popa                ; Restore all general purpose registers from the stack
            ret

        check_long_mode_with_cpuid:
            pusha                                   ; Save all general purpose registers on the stack
                  ; This function need to be written by you.
                mov eax,0x80000000 ; cpuid function to determine the largest function number
                cpuid
                cmp eax,0x80000001 ; If the largest function number is less than 0x80000001 then it is not supported
                jl .long_mode_not_supported ; Error and hang
                mov eax,0x80000001 ; Else invoke cpuid function 0x80000001 to get the processor extended features bits (EDX).
                cpuid
                and edx,0x20000000 ; Mask out all bits in edx except bit # 29 which is the Long Mode LM-bit
                cmp edx,0 ; if edx is zero them LM-bit is not set
                je .long_mode_not_supported ; If Long mode is not supported then we need to print a message and stop
                mov si,long_mode_supported_msg ; Else print a message indicating the long mode is supported
                call bios_print
                jmp .exit_check_long_mode_with_cpuid ; Skip over the long mode not supported section
                .long_mode_not_supported:
                mov si,long_mode_not_supported_msg ; If we are here then long mode is not supported
                call bios_print ; Print an error message and jump to hang
                jmp hang
                .exit_check_long_mode_with_cpuid:

            popa                                ; Restore all general purpose registers from the stack
            ret
