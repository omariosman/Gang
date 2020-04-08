;************************************** first_stage_data.asm **************************************
      boot_drive db 0x0                 ; memory variable for boot drive number
      lba_sector dw 0x1                 ; memory variable for next sector to read
      spt dw 0x12                       ; memory variable for number of sectors/track.
      hpc dw 0x2                        ; memory variable for number of head/cylinder

; Three memory variables that we will use to store the conversion from LBA to CHS to use it with INT 0x13/fn2
      Cylinder dw 0x0
      Head db 0x0
      Sector dw 0x0

; string messages that will be used in first stage boot loader
      disk_error_msg db 'Disk Error',13,10,0
      fault_msg db 'Unknown Boot Device',13,10,0
      booted_from_msg db 'Booted from ',0
      floppy_boot_msg db 'Floppy',13,10,0
      drive_boot_msg db 'Disk',13,10,0
      greeting_msg db '1st Stage Loader',13,10,0
      second_stage_loaded_msg db 13,10,'2nd Stage loaded, press any key to resume!',0
      dot db '.',0
      newline db 13,10,0
      disk_read_segment dw 0
      disk_read_offset dw 0
