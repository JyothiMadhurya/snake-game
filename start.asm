.section .data
 snake_len: .long 5 # Initial snake length
 num_apples: .long 2 # Initial number of apples
.section .text
 .globl _start_start:
 # Initialize the ncurses environment and the board
 call board_init
 # Load initial snake length and number of apples from the command line
 movl $5, %edi # Snake length argument
 movl $2, %esi # Number of apples argument
 # Call start_game function (defined in snake.asm)
 call start_game
 # Cleanup the ncurses environment
 call game_exit
 # Exit the program
 mov $60, %rax # syscall: exit
 xor %rdi, %rdi # exit status 0
 syscall