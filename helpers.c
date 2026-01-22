#include <ncurses.h>
#include <unistd.h>
void board_init() {
 initscr(); // Initialize the screen
 cbreak(); // Disable line buffering
 noecho(); // Disable echoing of input characters
 curs_set(FALSE); // Hide the cursor
 timeout(0); // Non-blocking input
}
void game_exit() {
 endwin(); // Restore the terminal to its original state
}
int board_get_key() {
 return getch(); // Get the character from keyboard input
}
void board_put_char(int x, int y, char ch) {
 mvaddch(y, x, ch); // Place the character at position (x, y)
}
void board_clear() {
 clear(); // Clear the screen
}
