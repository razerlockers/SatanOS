; 16-bit GUI of SatanOS, damn well created by RazerLocker. 

; Current tab: 0=Apps, 1=Commands, 2=About, 3=No Escape, 4=HELP ME, 5=System Resources
current_tab db 0


calc_input db '0', 0
calc_result db 0
calc_operator db 0


notepad_buffer times 80 db ' '
notepad_cursor dw 0


elephant_pos dw 35
rider_pos dw 0


helpme_state db 0  ; 0=initial, 1=lobotomy message

; you wanna lick that screen. Arent you?
clear_screen_blue:
    ; Set video mode 80x25 (this clears screen oh yeahhh)
    mov ax, 0x0003
    int 0x10
    
    
    mov ax, 0xB800
    mov es, ax
    mov di, 0
    mov cx, 80*25
    mov ax, 0x1F20  
.clear_loop:
    mov [es:di], ax
    add di, 2
    loop .clear_loop
    ret

; i find my friends. They are in my head
wait_key:
    mov ah, 0x00
    int 0x16
    ret

; 
check_key:
    mov ah, 0x01
    int 0x16
    jz .no_key
    mov ah, 0x00
    int 0x16
    ret
.no_key:
    xor al, al
    ret

main_gui:
    call clear_screen_blue
    call draw_tabs
    call show_apps_tab
    
.main_loop:
    ; Check for key press
    call check_key
    cmp al, 0
    je .main_loop
    
    ; Process the key
    call process_key
    jmp .main_loop

process_key:
    ; portal to agartha
    cmp al, 0x1B
    je main_gui
    
    ; Tab navigation
    cmp al, '1'
    je .tab_apps
    cmp al, '2' 
    je .tab_commands
    cmp al, '3'
    je .tab_about
    cmp al, '5'
    je .tab_noescape
    cmp al, '6'
    je .tab_helpme
    cmp al, '7'
    je .tab_system
    
    ; im so fucking special
    cmp byte [current_tab], 4
    jne .check_apps
    cmp al, 'j'
    je .lobotomy
    
.check_apps:
    ; App launches (only in apps tab)
    cmp byte [current_tab], 0
    jne .check_other
    
    cmp al, 'a'
    je launch_calculator
    cmp al, 'b'
    je launch_notepad
    cmp al, 'c'
    je launch_openword
    cmp al, 'd'
    je launch_openpoint
    cmp al, 'e'
    je launch_opencel
    cmp al, 'f'
    je launch_pingpong
    cmp al, 'g'
    je launch_ride_elephant
    cmp al, 'h'
    je launch_whoami
    cmp al, 'i'
    je launch_we_are_done
    
.check_other:
    ; Fate decision (only in about tab)
    cmp byte [current_tab], 2
    jne .check_commands
    
    cmp al, 'x'
    je decide_fate
    
.check_commands:
    ; yess
    cmp byte [current_tab], 1
    jne .done
    
    cmp al, '1'
    je cmd_help
    cmp al, '2'
    je cmd_dir
    cmp al, '3'
    je cmd_satan
    cmp al, '4'
    je cmd_kill
    cmp al, '5'
    je cmd_reboot
    cmp al, '6'
    je cmd_isit2038
    cmp al, '7'
    je cmd_thedate
    
.done:
    ret

.tab_apps:
    mov byte [current_tab], 0
    call show_apps_tab
    ret

.tab_commands:
    mov byte [current_tab], 1
    call show_commands_tab
    ret

.tab_about:
    mov byte [current_tab], 2
    call show_about_tab
    ret

.tab_noescape:
    mov byte [current_tab], 3
    call show_noescape_tab
    ret

.tab_helpme:
    mov byte [current_tab], 4
    mov byte [helpme_state], 0
    call show_helpme_tab
    ret

.tab_system:
    mov byte [current_tab], 5
    call show_system_tab
    ret

.lobotomy:
    mov byte [helpme_state], 1
    call show_helpme_tab
    ret

; my name is razer the locker
draw_tabs:
    ; Clear top two rows for tabs
    mov dh, 0
    mov dl, 0
    call set_cursor
    mov cx, 80
    mov al, ' '
    mov bl, 0x1F
    call print_char_repeat
    
    mov dh, 1
    mov dl, 0
    call set_cursor
    mov cx, 80
    mov al, ' '
    mov bl, 0x1F
    call print_char_repeat
    
    ; i'd prefer razer instead of corsair to be honest...
    mov dh, 0
    mov dl, 2
    call set_cursor
    mov si, tab_apps
    call print_string
    
    mov dh, 0
    mov dl, 10
    call set_cursor
    mov si, tab_commands
    call print_string
    
    mov dh, 0
    mov dl, 20
    call set_cursor
    mov si, tab_about
    call print_string
    
    mov dh, 0
    mov dl, 28
    call set_cursor
    mov si, tab_noescape
    call print_string
    
    mov dh, 0
    mov dl, 40
    call set_cursor
    mov si, tab_helpme
    call print_string
    
    mov dh, 0
    mov dl, 50
    call set_cursor
    mov si, tab_system
    call print_string
    
    ; help me to fuck my brain
    mov dh, 1
    mov dl, 2
    call set_cursor
    mov si, help_line
    call print_string
    
    
    mov dh, 2
    mov dl, 0
    call set_cursor
    mov cx, 80
    mov al, '-'
    mov bl, 0x1F
    call print_char_repeat
    
    ret


show_apps_tab:
    call clear_content
    
    mov dh, 4
    mov dl, 35
    call set_cursor
    mov si, apps_title
    call print_string
    
    mov dh, 6
    mov dl, 5
    call set_cursor
    mov si, app1
    call print_string
    
    mov dh, 7
    mov dl, 5
    call set_cursor
    mov si, app2
    call print_string
    
    mov dh, 8
    mov dl, 5
    call set_cursor
    mov si, app3
    call print_string
    
    mov dh, 9
    mov dl, 5
    call set_cursor
    mov si, app4
    call print_string
    
    mov dh, 10
    mov dl, 5
    call set_cursor
    mov si, app5
    call print_string
    
    mov dh, 11
    mov dl, 5
    call set_cursor
    mov si, app6
    call print_string
    
    mov dh, 12
    mov dl, 5
    call set_cursor
    mov si, app7
    call print_string
    
    mov dh, 13
    mov dl, 5
    call set_cursor
    mov si, app8
    call print_string
    
    mov dh, 14
    mov dl, 5
    call set_cursor
    mov si, app9
    call print_string
    
    mov dh, 16
    mov dl, 5
    call set_cursor
    mov si, esc_help
    call print_string
    
    ret

; damn well no help for you dumbfuck
show_commands_tab:
    call clear_content
    
    mov dh, 4
    mov dl, 32
    call set_cursor
    mov si, commands_title
    call print_string
    
    mov dh, 6
    mov dl, 5
    call set_cursor
    mov si, cmd1_text
    call print_string
    
    mov dh, 7
    mov dl, 5
    call set_cursor
    mov si, cmd2_text
    call print_string
    
    mov dh, 8
    mov dl, 5
    call set_cursor
    mov si, cmd3_text
    call print_string
    
    mov dh, 9
    mov dl, 5
    call set_cursor
    mov si, cmd4_text
    call print_string
    
    mov dh, 10
    mov dl, 5
    call set_cursor
    mov si, cmd5_text
    call print_string
    
    mov dh, 11
    mov dl, 5
    call set_cursor
    mov si, cmd6_text
    call print_string
    
    mov dh, 12
    mov dl, 5
    call set_cursor
    mov si, cmd7_text
    call print_string
    
    mov dh, 16
    mov dl, 5
    call set_cursor
    mov si, esc_help
    call print_string
    
    ret

; am i the god?
show_about_tab:
    call clear_content
    
    mov dh, 4
    mov dl, 37
    call set_cursor
    mov si, about_title
    call print_string
    
    mov dh, 6
    mov dl, 5
    call set_cursor
    mov si, about_text1
    call print_string
    
    mov dh, 7
    mov dl, 5
    call set_cursor
    mov si, about_text2
    call print_string
    
    mov dh, 9
    mov dl, 5
    call set_cursor
    mov si, fate_prompt
    call print_string
    
    mov dh, 16
    mov dl, 5
    call set_cursor
    mov si, esc_help
    call print_string
    
    ret

; im a terrible person
show_noescape_tab:
    call clear_content
    
    mov dh, 3
    mov dl, 33
    call set_cursor
    mov si, noescape_title
    call print_string
    
    ; she wants me yeah definetly she loves me hehehehe :DD
    mov dh, 5
    mov dl, 3
    call set_cursor
    mov si, noescape1
    call print_string
    
    mov dh, 6
    mov dl, 3
    call set_cursor
    mov si, noescape2
    call print_string
    
    mov dh, 7
    mov dl, 3
    call set_cursor
    mov si, noescape3
    call print_string
    
    mov dh, 8
    mov dl, 3
    call set_cursor
    mov si, noescape4
    call print_string
    
    mov dh, 9
    mov dl, 3
    call set_cursor
    mov si, noescape5
    call print_string
    
    mov dh, 10
    mov dl, 3
    call set_cursor
    mov si, noescape6
    call print_string
    
    mov dh, 11
    mov dl, 3
    call set_cursor
    mov si, noescape7
    call print_string
    
    mov dh, 12
    mov dl, 3
    call set_cursor
    mov si, noescape8
    call print_string
    
    mov dh, 13
    mov dl, 3
    call set_cursor
    mov si, noescape9
    call print_string
    
    mov dh, 14
    mov dl, 3
    call set_cursor
    mov si, noescape10
    call print_string
    
    mov dh, 15
    mov dl, 3
    call set_cursor
    mov si, noescape11
    call print_string
    
    mov dh, 16
    mov dl, 3
    call set_cursor
    mov si, noescape12
    call print_string
    
    mov dh, 18
    mov dl, 5
    call set_cursor
    mov si, esc_help
    call print_string
    
    ret

; I HATE HER SHE DOES NOT WANTS ME 
show_helpme_tab:
    call clear_content
    
    mov dh, 4
    mov dl, 35
    call set_cursor
    mov si, helpme_title
    call print_string
    
    cmp byte [helpme_state], 0
    je .initial_state
    
    ; im so sad :(
    mov dh, 8
    mov dl, 5
    call set_cursor
    mov si, lobotomy_msg1
    call print_string
    
    mov dh, 9
    mov dl, 5
    call set_cursor
    mov si, lobotomy_msg2
    call print_string
    
    mov dh, 10
    mov dl, 5
    call set_cursor
    mov si, lobotomy_msg3
    call print_string
    
    mov dh, 11
    mov dl, 5
    call set_cursor
    mov si, lobotomy_msg4
    call print_string
    
    mov dh, 12
    mov dl, 5
    call set_cursor
    mov si, lobotomy_msg5
    call print_string
    
    mov dh, 13
    mov dl, 5
    call set_cursor
    mov si, lobotomy_msg6
    call print_string
    
    mov dh, 14
    mov dl, 5
    call set_cursor
    mov si, lobotomy_msg7
    call print_string
    
    jmp .done
    
.initial_state:
    mov dh, 10
    mov dl, 30
    call set_cursor
    mov si, helpme_prompt
    call print_string

.done:
    mov dh, 18
    mov dl, 5
    call set_cursor
    mov si, esc_help
    call print_string
    ret

; i love her
show_system_tab:
    call clear_content
    
    mov dh, 3
    mov dl, 32
    call set_cursor
    mov si, system_title
    call print_string
    
    ; damn
    mov dh, 5
    mov dl, 5
    call set_cursor
    mov si, file_explorer_title
    call print_string
    
    mov dh, 7
    mov dl, 10
    call set_cursor
    mov si, file1
    call print_string
    
    mov dh, 8
    mov dl, 10
    call set_cursor
    mov si, file2
    call print_string
    
    mov dh, 9
    mov dl, 10
    call set_cursor
    mov si, file3
    call print_string
    
    mov dh, 10
    mov dl, 10
    call set_cursor
    mov si, file4
    call print_string
    
    mov dh, 11
    mov dl, 10
    call set_cursor
    mov si, file5
    call print_string
    
    mov dh, 12
    mov dl, 10
    call set_cursor
    mov si, file6
    call print_string
    
    
    mov dh, 5
    mov dl, 45
    call set_cursor
    mov si, task_manager_title
    call print_string
    
    mov dh, 7
    mov dl, 45
    call set_cursor
    mov si, cpu_usage
    call print_string
    
    mov dh, 8
    mov dl, 45
    call set_cursor
    mov si, gpu_usage
    call print_string
    
    mov dh, 9
    mov dl, 45
    call set_cursor
    mov si, ram_usage
    call print_string
    
    
    mov dh, 7
    mov dl, 65
    call set_cursor
    mov si, cpu_bar
    call print_string
    
    mov dh, 8
    mov dl, 65
    call set_cursor
    mov si, gpu_bar
    call print_string
    
    mov dh, 9
    mov dl, 65
    call set_cursor
    mov si, ram_bar
    call print_string
    
    mov dh, 16
    mov dl, 5
    call set_cursor
    mov si, esc_help
    call print_string
    
    ret

; Clear me from world
clear_content:
    mov dh, 3
.clear_rows:
    mov dl, 0
    call set_cursor
    
    mov cx, 80
    mov al, ' '
    mov bl, 0x1F
    call print_char_repeat
    
    inc dh
    cmp dh, 25
    jl .clear_rows
    ret

; im not scared

set_cursor:
    mov ah, 0x02
    mov bh, 0x00
    int 0x10
    ret

; i dont belong this world
; help me
print_string:
    mov ah, 0x0E
    mov bl, 0x1F
.loop:
    lodsb
    test al, al
    jz .done
    int 0x10
    jmp .loop
.done:
    ret

; no
; please help me
print_char_repeat:
    mov ah, 0x09
    mov bh, 0x00
    int 0x10
    ret

; ========== my beatiful apps better than her probably ==========

; casio calc
launch_calculator:
    call clear_screen_blue
    mov dh, 10
    mov dl, 30
    call set_cursor
    mov si, calc_msg
    call print_string
    call wait_esc
    call main_gui
    ret

; the tool i will wrote my last notes with
launch_notepad:
    call clear_screen_blue
    mov dh, 10
    mov dl, 30
    call set_cursor
    mov si, notepad_msg
    call print_string
    call wait_esc
    call main_gui
    ret

; ride the elephant (so fun game please play it )
launch_ride_elephant:
    call clear_screen_blue
    mov dh, 10
    mov dl, 30
    call set_cursor
    mov si, elephant_msg
    call print_string
    
    ; phenotype of elephant
    mov dh, 12
    mov dl, 35
    call set_cursor
    mov si, elephant_art1
    call print_string
    
    mov dh, 13
    mov dl, 35
    call set_cursor
    mov si, elephant_art2
    call print_string
    
    mov dh, 14
    mov dl, 35
    call set_cursor
    mov si, elephant_art3
    call print_string
    
    mov dh, 15
    mov dl, 35
    call set_cursor
    mov si, elephant_art4
    call print_string
    
    call wait_esc
    call main_gui
    ret

; Where is my mind
launch_whoami:
    call clear_screen_blue
    mov dh, 12
    mov dl, 30
    call set_cursor
    mov si, whoami_msg
    call print_string
    call wait_esc
    call main_gui
    ret

; i was swimmed in the carrabean
launch_we_are_done:
    call clear_screen_blue
    
    mov dh, 5
    mov dl, 25
    call set_cursor
    mov si, we_are_done_title
    call print_string
    
    mov dh, 7
    mov dl, 10
    call set_cursor
    mov si, we_are_done1
    call print_string
    
    mov dh, 8
    mov dl, 10
    call set_cursor
    mov si, we_are_done2
    call print_string
    
    mov dh, 9
    mov dl, 10
    call set_cursor
    mov si, we_are_done3
    call print_string
    
    mov dh, 10
    mov dl, 10
    call set_cursor
    mov si, we_are_done4
    call print_string
    
    mov dh, 11
    mov dl, 10
    call set_cursor
    mov si, we_are_done5
    call print_string
    
    mov dh, 12
    mov dl, 10
    call set_cursor
    mov si, we_are_done6
    call print_string
    
    mov dh, 13
    mov dl, 10
    call set_cursor
    mov si, we_are_done7
    call print_string
    
    mov dh, 14
    mov dl, 10
    call set_cursor
    mov si, we_are_done8
    call print_string
    
    mov dh, 15
    mov dl, 10
    call set_cursor
    mov si, we_are_done9
    call print_string
    
    call wait_esc
    call main_gui
    ret

; your head will collapse, but theres nothing in it
launch_openword:
    call clear_screen_blue
    mov dh, 10
    mov dl, 30
    call set_cursor
    mov si, openword_msg
    call print_string
    call wait_esc
    call main_gui
    ret

launch_openpoint:
    call clear_screen_blue
    mov dh, 10
    mov dl, 30
    call set_cursor
    mov si, openpoint_msg
    call print_string
    call wait_esc
    call main_gui
    ret

launch_opencel:
    call clear_screen_blue
    mov dh, 10
    mov dl, 30
    call set_cursor
    mov si, opencel_msg
    call print_string
    call wait_esc
    call main_gui
    ret

launch_pingpong:
    call clear_screen_blue
    mov dh, 10
    mov dl, 30
    call set_cursor
    mov si, pingpong_msg
    call print_string
    call wait_esc
    call main_gui
    ret

; and you ask yourself
wait_esc:
    mov dh, 22
    mov dl, 25
    call set_cursor
    mov si, esc_help
    call print_string
.esc_loop:
    call wait_key
    cmp al, 0x1B  ; ESC key
    jne .esc_loop
    ret

; where is my mind
decide_fate:
    call clear_screen_blue
    
    ; where is my mind 
    mov ah, 0x00
    int 0x1A
    and dx, 0x0007
    
    cmp dx, 0
    je .fate1
    cmp dx, 1
    je .fate2
    cmp dx, 2
    je .fate3
    cmp dx, 3
    je .fate4
    jmp .fate5

.fate1:
    mov si, fate1_msg
    jmp .show
.fate2:
    mov si, fate2_msg
    jmp .show
.fate3:
    mov si, fate3_msg
    jmp .show
.fate4:
    mov si, fate4_msg
    jmp .show
.fate5:
    mov si, fate5_msg
.show:
    mov dh, 10
    mov dl, 30
    call set_cursor
    call print_string
    call wait_esc
    call show_about_tab
    ret

; they did warned us
cmd_help:
    call clear_content
    mov dh, 10
    mov dl, 5
    call set_cursor
    mov si, cmd_help_msg
    call print_string
    call wait_esc
    call show_commands_tab
    ret

cmd_dir:
    call clear_content
    mov dh, 10
    mov dl, 5
    call set_cursor
    mov si, cmd_dir_msg
    call print_string
    call wait_esc
    call show_commands_tab
    ret

cmd_satan:
    call clear_content
    mov dh, 10
    mov dl, 5
    call set_cursor
    mov si, cmd_satan_msg
    call print_string
    call wait_esc
    call show_commands_tab
    ret

cmd_kill:
    call clear_screen_blue
    mov dh, 12
    mov dl, 25
    call set_cursor
    mov si, cmd_kill_msg
    call print_string
    jmp $  ; Hang system

cmd_reboot:
    mov dh, 12
    mov dl, 30
    call set_cursor
    mov si, cmd_reboot_msg
    call print_string
    ; Wait a bit
    mov cx, 0xFFFF
.delay:
    loop .delay
    ; Warm reboot
    mov ax, 0x0040
    mov ds, ax
    mov word [0x0072], 0x0000
    jmp 0xFFFF:0x0000

cmd_isit2038:
    call clear_content
    mov dh, 10
    mov dl, 5
    call set_cursor
    mov si, cmd_isit2038_msg
    call print_string
    call wait_esc
    call show_commands_tab
    ret

cmd_thedate:
    call clear_content
    mov dh, 10
    mov dl, 5
    call set_cursor
    mov si, cmd_thedate_msg
    call print_string
    call wait_esc
    call show_commands_tab
    ret

; ========== DATA SEXTION (SO GOOD LICK YOUR FINGERS) ==========

; cheeseburger
tab_apps: db "1. Apps", 0
tab_commands: db "2. Commands", 0
tab_about: db "3. About", 0
tab_noescape: db "5. NO ESCAPE", 0
tab_helpme: db "6. HELP ME", 0
tab_system: db "7. System", 0
help_line: db "Press 1,2,3,5,6,7 for tabs, ESC to return home", 0
esc_help: db "Press ESC to return to main menu", 0

; jesus is a lie 
apps_title: db "APPLICATIONS", 0
app1: db "a. Calculator", 0
app2: db "b. Notepad", 0
app3: db "c. OpenWord", 0
app4: db "d. OpenPoint", 0
app5: db "e. OpenCel", 0
app6: db "f. PingPong Game", 0
app7: db "g. Ride Elephant", 0
app8: db "h. Who Am I?", 0
app9: db "i. WE ARE DONE", 0

; there is not a god expect me
commands_title: db "COOL COMMANDS", 0
cmd1_text: db "1. /help - lists commands", 0
cmd2_text: db "2. /dir - lists files", 0
cmd3_text: db "3. /satan - satan message", 0
cmd4_text: db "4. /kill - closes GUI", 0
cmd5_text: db "5. /reboot - reboots", 0
cmd6_text: db "6. /isit2038 - prints yes", 0
cmd7_text: db "7. /thedateworldwillend - prints date", 0

; im not a animal
about_title: db "ABOUT", 0
about_text1: db "SatanOS x16 - Open source and free OS", 0
about_text2: db "Hard shit to do honestly", 0
fate_prompt: db "Press x to decide your fate", 0

; i like fish
noescape_title: db "NO ESCAPE", 0
noescape1: db "You got blessed by an unreligious god.", 0
noescape2: db "You will die. Never enjoy any moment of your life.", 0
noescape3: db "You are worthless. Your life is not important for anyone.", 0
noescape4: db "No one cares a fuck about you.", 0
noescape5: db "Yeah im telling this to you, disappointing loser", 0
noescape6: db "piece of shit behind that monitor.", 0
noescape7: db "No one would give a fuck about your death body", 0
noescape8: db "lying in your room if you decide to pull the trigger.", 0
noescape9: db "They will put you in a corpse bag and you will rot", 0
noescape10: db "for eternity. No vision, no memory.", 0
noescape11: db "Nothing until forever, just like you didnt born.", 0
noescape12: db "So now, pull the trigger before the big day in 2038.", 0

; mrs pacman
helpme_title: db "HELP ME", 0
helpme_prompt: db "press j for lobotomy", 0
lobotomy_msg1: db "THERE ARE WIRES UNDER YOUR SKIN", 0
lobotomy_msg2: db "GOVERNMENT IS TRYING TO TAKE CONTROL OVER YOU", 0
lobotomy_msg3: db "THERE IS SUBHUMAN CREATURES INSIDE OF YOUR", 0
lobotomy_msg4: db "BELLY-BUTTON REMOVE IT REMOVE IT REMOVE IT", 0
lobotomy_msg5: db "REMOVE IT REMOVE IT REMOVE IT", 0
lobotomy_msg6: db "REMOVE IT REMOVE IT REMOVE IT", 0
lobotomy_msg7: db "REMOVE IT REMOVE IT REMOVE IT", 0

; chavez
system_title: db "SYSTEM RESOURCES", 0
file_explorer_title: db "FILE EXPLORER:", 0
file1: db "boot.asm - 512 bytes", 0
file2: db "kernel.asm - 2.1 KB", 0
file3: db "gui.asm - 15.7 KB", 0
file4: db "satan.dll - 666 bytes", 0
file5: db "system.sys - 1.2 KB", 0
file6: db "doom.exe - 2.3 MB", 0
task_manager_title: db "TASK MANAGER:", 0
cpu_usage: db "CPU: 60%", 0
gpu_usage: db "GPU: 0%", 0
ram_usage: db "RAM: 80%", 0
cpu_bar: db "[======", 0
gpu_bar: db "[", 0
ram_bar: db "[========", 0

; sırpski film director
we_are_done_title: db "WE ARE DONE", 0
we_are_done1: db "In those days Ashtar Sheran sent his", 0
we_are_done2: db "Pterodactylus demons to madden men", 0
we_are_done3: db "and halt the age of steam and iron.", 0
we_are_done4: db "", 0
we_are_done5: db "Yet the people saw the lie, defied", 0
we_are_done6: db "the false angels, and the wheels turned.", 0
we_are_done7: db "", 0
we_are_done8: db "Thus saith the Lord: We were warred", 0
we_are_done9: db "upon from the stars, and we won. Selah.", 0

; App cloud
calc_msg: db "Calculator: Basic math operations", 0
notepad_msg: db "Notepad: Simple text editor", 0
elephant_msg: db "Ride Elephant Game", 0
elephant_art1: db "  __==__", 0
elephant_art2: db "-[      ]-", 0
elephant_art3: db "  /    \\", 0
elephant_art4: db " [  O  ] Rider", 0
whoami_msg: db "you are a little piece of history", 0
openword_msg: db "OpenWord - Document Editor", 0
openpoint_msg: db "OpenPoint - Presentation", 0
opencel_msg: db "OpenCel - Spreadsheet", 0
pingpong_msg: db "PingPong Game", 0

; see you in non existing hell!
fate1_msg: db "1) you will never see the year 2038", 0
fate2_msg: db "2) you got blessed by a non-religious god.", 0
fate3_msg: db "3) you will die.", 0
fate4_msg: db "4) your life looks fucked up.", 0
fate5_msg: db "5) enough for you.", 0

; please help - today
cmd_help_msg: db "Available: /help, /dir, /satan, /kill, /reboot, /isit2038, /thedateworldwillend", 0
cmd_dir_msg: db "Files: boot.asm, kernel.asm, gui.asm, system.sys", 0
cmd_satan_msg: db "You are inside of my walls. Your god is blind here. I decide your fate.", 0
cmd_kill_msg: db "GUI killed. System halted. Press CTRL+ALT+DEL to damn reboot.", 0
cmd_reboot_msg: db "Rebooting your trash...", 0
cmd_isit2038_msg: db "yes", 0
cmd_thedate_msg: db "12/12/2038", 0
