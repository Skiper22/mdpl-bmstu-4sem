global main

extern g_signal_connect_data
extern gtk_application_new
extern g_application_run

extern gtk_application_window_new
extern gtk_window_set_application
extern gtk_window_set_title
extern gtk_window_set_position
extern gtk_window_set_resizable
extern gtk_widget_show_all

extern gtk_grid_new
extern gtk_container_add

extern gtk_label_new_with_mnemonic
extern gtk_grid_attach
extern gtk_entry_new
extern gtk_button_new_with_label

extern gtk_actionable_set_action_name
extern g_action_map_add_action_entries
extern gtk_entry_get_text
extern gtk_label_set_text

extern atoi
extern sprintf

section .data
app_domain              db "org.gtk.example", 0
activate_str            db "activate", 0
clicked_str             db "clicked", 0
title                   db "calculator app", 0
sum_label_init          db "sum = 0", 0
x_label_text            db "x", 0
y_label_text            db "y", 0
calculate_button_text   db "calculate", 0
calculate_action_name   db "app.enter", 0
show_button_text        db "show", 0
show_action_name        db "app.show", 0
enter_str               db "enter", 0
sum_format_str          db "sum = %d", 0
sum_text                db "              ", 0

app_actions dq enter_str
            dq enter_callback
            dq 0
            dq 0
            dq 0

section .bss
app                 resq 1
window              resq 1
grid                resq 1
sum_label           resq 1
x_label             resq 1
y_label             resq 1
x_entry             resq 1
y_entry             resq 1
x_text              resq 1
y_text              resq 1
calculate_button    resq 1
show_button         resq 1

section .text
main:
    push rbp
    mov  rbp, rsp
    sub  rsp, 0x20

    mov rdi, app_domain
    mov rsi, 0x0
    call gtk_application_new
    mov [app], rax

    mov rdi, [app]
    mov rsi, activate_str
    mov rdx, activate
    mov rcx, 0x0
    mov r8,  0x0
    mov r9,  0x0
    call g_signal_connect_data

    mov rdi, [app]
    mov rsi, 0x0
    mov rdx, 0x0
    call g_application_run

    leave
    ret

activate:
    push rbp
    mov  rbp, rsp

    mov rdi, [app]
    call gtk_application_window_new
    mov [window], rax

    mov rdi, [window]
    mov rsi, [app]
    call gtk_window_set_application

    mov rdi, [window]
    mov rsi, title
    call gtk_window_set_title

    call gtk_grid_new
    mov [grid], rax

    mov rdi, [window]
    mov rsi, [grid]
    call gtk_container_add

create_show_button:
    mov rdi, show_button_text
    call gtk_button_new_with_label
    mov [show_button], rax

    mov rdi, [grid]
    mov rsi, [show_button]
    mov rdx, 0
    mov rcx, 3
    mov r8,  4
    mov r9,  1
    call gtk_grid_attach

    mov rdi, [show_button]
    mov rsi, clicked_str
    mov rdx, show_callback
    mov rcx, 0x0
    mov r8,  0x0
    mov r9,  0x0
    call g_signal_connect_data

    mov rdi, [window]
    call gtk_widget_show_all

    leave
    ret

show_callback:
    push rbp
    mov  rbp, rsp

create_sum_label:
    mov rdi, sum_label_init
    call gtk_label_new_with_mnemonic
    mov [sum_label], rax

    mov rdi, [grid]
    mov rsi, [sum_label]
    mov rdx, 0
    mov rcx, 0
    mov r8,  4
    mov r9,  1
    call gtk_grid_attach

create_x_entry:
    mov rdi, x_label_text
    call gtk_label_new_with_mnemonic
    mov [x_label], rax

    mov rdi, [grid]
    mov rsi, [x_label]
    mov rdx, 0
    mov rcx, 1
    mov r8,  1
    mov r9,  1
    call gtk_grid_attach

    call gtk_entry_new
    mov [x_entry], rax

    mov rdi, [grid]
    mov rsi, [x_entry]
    mov rdx, 1
    mov rcx, 1
    mov r8,  1
    mov r9,  1
    call gtk_grid_attach

connect_x_entry:
    mov rdi, [x_entry]
    mov rsi, activate_str
    mov rdx, enter_callback
    mov rcx, 0x0
    mov r8,  0x0
    mov r9,  0x0
    call g_signal_connect_data

create_y_entry:
    mov rdi, y_label_text
    call gtk_label_new_with_mnemonic
    mov [y_label], rax

    mov rdi, [grid]
    mov rsi, [y_label]
    mov rdx, 2
    mov rcx, 1
    mov r8,  1
    mov r9,  1
    call gtk_grid_attach

    call gtk_entry_new
    mov [y_entry], rax

    mov rdi, [grid]
    mov rsi, [y_entry]
    mov rdx, 3
    mov rcx, 1
    mov r8,  1
    mov r9,  1
    call gtk_grid_attach

connect_y_entry:
    mov rdi, [y_entry]
    mov rsi, activate_str
    mov rdx, enter_callback
    mov rcx, 0x0
    mov r8,  0x0
    mov r9,  0x0
    call g_signal_connect_data

create_calculate_button:
    mov rdi, calculate_button_text
    call gtk_button_new_with_label
    mov [calculate_button], rax

    mov rdi, [grid]
    mov rsi, [calculate_button]
    mov rdx, 0
    mov rcx, 2
    mov r8,  4
    mov r9,  1
    call gtk_grid_attach

    mov rdi, [calculate_button]
    mov rsi, calculate_action_name
    call gtk_actionable_set_action_name

connect_button:
    mov rdi, [app]
    mov rsi, app_actions
    mov rdx, 1
    mov rcx, 0
    call g_action_map_add_action_entries

show_window:
    mov rdi, [window]
    call gtk_widget_show_all

    leave
    ret

enter_callback:
    push rbp
    mov  rbp, rsp

    mov rdi, [x_entry]
    call gtk_entry_get_text
    mov [x_text], rax

    mov rdi, [y_entry]
    call gtk_entry_get_text
    mov [y_text], rax

    mov rdi, [x_text]
    call atoi
    mov rbx, rax

    mov rdi, [y_text]
    call atoi
    mov rcx, rax

    mov rdx, rbx
    add rdx, rcx

    mov rdi, sum_text
    mov rsi, sum_format_str
    call sprintf

    ;mov rdi, [sum_label]
    ;mov rsi, sum_text
    ;call gtk_label_set_text

    mov rdi, [window]
    mov rsi, sum_text
    call gtk_window_set_title

    leave
    ret
