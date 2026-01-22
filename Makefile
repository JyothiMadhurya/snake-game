CC = gcc
ASM = as
CFLAGS = -lncurses

all: snake

snake: start.o snake.o helpers.o
    $(CC) -o snake start.o snake.o helpers.o $(CFLAGS)

start.o: start.asm
    $(ASM) -o start.o start.asm

snake.o: snake.asm
    $(ASM) -o snake.o snake.asm

helpers.o: helpers.c
    $(CC) -c helpers.c -o helpers.o

clean:
    rm -f *.o snake
