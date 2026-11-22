# Snake in x86-64 Assembly

A playable terminal version of the classic Snake game, with the game logic written in **x86-64 assembly** (GNU assembler, AT&T syntax) and a thin C layer over **ncurses** for drawing and keyboard input.

Team project by Jyothi Madhurya Nalam, Venkata Vishnu Vardhan Reddy Gurram and Ayyapa Mitta.

## Features

- Snake moves with the arrow keys and keeps going in its last direction when no key is pressed.
- The snake grows each time it eats an apple; the starting length and number of apples are configurable.
- **Extras:**
  - the game speeds up after every apple;
  - a game timer limits playing time and resets when an apple is eaten;
  - apples are always placed where they don't overlap the snake.
- The assembly code follows the C calling convention, so it calls the C helper functions directly.

## Project structure

| File | What it does |
|---|---|
| `start.asm` | Program entry: sets up ncurses, starts the game (length 5, 2 apples) and exits cleanly |
| `snake.asm` | Game loop, movement, collision detection, apples, speed and timer |
| `helpers.c` | ncurses helpers: init/exit the board, read keys, draw characters, clear the screen |
| `Makefile` | Assembles the `.asm` files with GNU `as`, compiles `helpers.c` and links against ncurses |

## Build

On Linux with `gcc`, GNU `as` and the ncurses development library (`libncurses-dev` on Debian/Ubuntu), build with the provided `Makefile` and run `./snake`.

## Tech

x86-64 assembly · C · ncurses · Make
