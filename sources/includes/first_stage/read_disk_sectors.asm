 ;************************************** read_disk_sectors.asm **************************************
      read_disk_sectors: ; This function will read a number of 512-sectors stored in DI 
                         ; The sectors should be loaded at the address starting at [disk_read_segment:disk_read_offset]
            ; This function need to be written by you.
      pusha ; Save all general purpose registers on the stack
      add di,[lba_sector] ; Add lba_sector to DI as this will be the last sector to read
      mov ax,[disk_read_segment] ; Int 0x13/fn2 expect the address where read sector(s) will be loaded to to be in es:bx
      mov es,ax ; We cannot set es directly, so we load it from ax
      add bx,[disk_read_offset] ; set bx to the offset
      mov dl,[boot_drive] ; Read from boot drive
      .read_sector_loop:
      call lba_2_chs ; First we call lba_2_chs to convert the lbs value stored in [lba_sector] to CHS.
      mov ah, 0x2 ; Set Interrupt function 0x2 (Read Sectors)
      mov al,0x1 ; read only one sector
      mov cx,[Cylinder] ; Store Cylinder into CX
      shl cx,0x8 ; Shift the value of CX 8 bits to the left
      or cx,[Sector] ; Store Sector into CX first 6 bits
      mov dh,[Head] ; Store the head into dh
      int 0x13 ; Issue the Read interrupt
      jc .read_disk_error ; If carry flag is set then something wrong happened so jump to .read_disk_error
      mov si,dot ; Else print a '.' indicating successful sector read
      call bios_print
      inc word [lba_sector] ; Advance to the next sector
      add bx,0x200 ; Advance to the next memory location
      cmp word[lba_sector],di ; Check if the are done
      jl .read_sector_loop
