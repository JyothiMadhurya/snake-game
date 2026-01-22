.section .data
    snake_x:      .long 10, 9, 8, 7, 6    # Snake initial x positions
    snake_y:      .long 5,  5, 5, 5, 5    # Snake initial y positions
    apple_x:      .long 15                # Apple initial x position
    apple_y:      .long 10                # Apple initial y position
    snake_dir:    .byte 'R'               # Initial snake direction (Right)
    speed_delay:  .long 150000            # Initial speed delay (in microseconds)
    base_delay:   .long 150000            # Base speed delay
    time_limit:   .long 60                # Time limit (in seconds)
    loop_count:   .long 0                 # Count the game loops

.section .text
    .globl start_game

# Function to start the game
start_game:
    push %rbp
    mov %rsp, %rbp

    # Main game loop
game_loop:
    call get_input            # Handle player input
    call move_snake           # Move the snake
    call check_apple          # Check if snake ate an apple
    call check_collision      # Check if snake collided with wall or itself
    call draw_game            # Draw the snake and apple on the board
    call adjust_speed         # Adjust speed after each move
    call update_timer         # Update game timer

    # Delay between each game loop iteration (controls snake speed)
    mov speed_delay, %edi
    call usleep

    jmp game_loop             # Repeat the game loop

    pop %rbp
    ret

# Handle input from the arrow keys
get_input:
    push %rbp
    mov %rsp, %rbp

    # Call the provided ncurses function to get the key
    call board_get_key
    cmp $-1, %eax
    je no_input               # No key pressed

    cmp $258, %eax            # Down arrow key
    je move_down
    cmp $259, %eax            # Up arrow key
    je move_up
    cmp $260, %eax            # Left arrow key
    je move_left
    cmp $261, %eax            # Right arrow key
    je move_right

no_input:
    pop %rbp
    ret

move_down:
    movb $'D', snake_dir
    jmp end_input

move_up:
    movb $'U', snake_dir
    jmp end_input

move_left:
    movb $'L', snake_dir
    jmp end_input

move_right:
    movb $'R', snake_dir

end_input:
    pop %rbp
    ret

# Move the snake based on direction
move_snake:
    push %rbp
    mov %rsp, %rbp

    # Shift snake body (each segment follows the previous one)
    mov snake_len, %ecx       # Length of the snake
    dec %ecx
move_body:
    mov snake_x(%ecx), %eax
    mov %eax, snake_x(%ecx,1)
    mov snake_y(%ecx), %eax
    mov %eax, snake_y(%ecx,1)
    loop move_body

    # Move the head of the snake
    movb snake_dir, %al
    cmp $'D', %al
    je move_snake_down
    cmp $'U', %al
    je move_snake_up
    cmp $'L', %al
    je move_snake_left
    cmp $'R', %al
    je move_snake_right

    jmp done_movement

move_snake_down:
    add $1, snake_y(0)
    jmp done_movement

move_snake_up:
    sub $1, snake_y(0)
    jmp done_movement

move_snake_left:
    sub $1, snake_x(0)
    jmp done_movement

move_snake_right:
    add $1, snake_x(0)

done_movement:
    pop %rbp
    ret

# Check if the snake has eaten the apple
check_apple:
    push %rbp
    mov %rsp, %rbp

    # Compare snake head position with apple position
    mov snake_x(0), %eax
    cmp apple_x, %eax
    jne no_apple

    mov snake_y(0), %eax
    cmp apple_y, %eax
    jne no_apple

    # Apple eaten; increase snake length
    inc snake_len
    call spawn_new_apple      # Generate a new apple
    call reset_timer          # Reset the game timer

no_apple:
    pop %rbp
    ret

# Spawn a new apple at a random position
spawn_new_apple:
    push %rbp
    mov %rsp, %rbp

    call rand
    xor %edx, %edx
    div $20
    mov %edx, apple_x

    call rand
    xor %edx, %edx
    div $20
    mov %edx, apple_y

    pop %rbp
    ret

# Check for collision with walls or the snake's own body
check_collision:
    push %rbp
    mov %rsp, %rbp

    # Check wall collision
    mov snake_x(0), %eax
    cmp $0, %eax
    jl end_game
    cmp $20, %eax
    jge end_game

    mov snake_y(0), %eax
    cmp $0, %eax
    jl end_game
    cmp $20, %eax
    jge end_game

    # Check self-collision
    mov $1, %ecx
check_self_collision:
    cmp snake_x(0), snake_x(%ecx,1)
    jne next_check
    cmp snake_y(0), snake_y(%ecx,1)
    je end_game

next_check:
    inc %ecx
    cmp %ecx, snake_len
    jl check_self_collision

    jmp done_collision

end_game:
    call game_exit

done_collision:
    pop %rbp
    ret

# Adjust the snake speed (reduce delay after each apple)
adjust_speed:
    push %rbp
    mov %rsp, %rbp

    # Reduce speed delay
    sub $10000, speed_delay
    cmp $50000, speed_delay
    jge set_speed

    # Set minimum delay (fastest speed)
    mov $50000, speed_delay

set_speed:
    pop %rbp
    ret

# Update the game timer
update_timer:
    push %rbp
    mov %rsp, %rbp

    # Increment loop count
    add $1, loop_count
    cmp time_limit, loop_count
    jge end_game

    pop %rbp
    ret

# Reset the game timer after eating an apple
reset_timer:
    push %rbp
    mov %rsp, %rbp

    # Reset loop count
    mov $0, loop_count
    ret
