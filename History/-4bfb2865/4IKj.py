import random
import sys
import curses

choices = ['rock', 'paper', 'scissors']

def get_user_choice(stdscr):
    selected = 0
    while True:
        stdscr.clear()
        stdscr.addstr("Rock, Paper, Scissors!\n")
        stdscr.addstr("Use ↑/↓ to choose, Enter to select, or q to quit.\n\n")
        for idx, choice in enumerate(choices):
            if idx == selected:
                stdscr.addstr(f"> {choice}\n", curses.A_REVERSE)
            else:
                stdscr.addstr(f"  {choice}\n")
        stdscr.refresh()
        key = stdscr.getch()
        if key == ord('q'):
            return None
        elif key in [curses.KEY_UP, ord('w')]:
            selected = (selected - 1) % len(choices)
        elif key in [curses.KEY_DOWN, ord('s')]:
            selected = (selected + 1) % len(choices)
        elif key in [10, 13]:  # Enter key
            return choices[selected]

def play_round(stdscr):
    user_choice = get_user_choice(stdscr)
    if user_choice is None:
        return False
    computer_choice = random.choice(choices)
    stdscr.clear()
    stdscr.addstr(f"You chose: {user_choice}\n")
    stdscr.addstr(f"Computer chose: {computer_choice}\n")
    if user_choice == computer_choice:
        stdscr.addstr("It's a tie!\n")
    elif (user_choice == 'rock' and computer_choice == 'scissors') or \
         (user_choice == 'paper' and computer_choice == 'rock') or \
         (user_choice == 'scissors' and computer_choice == 'paper'):
        stdscr.addstr("You win!\n")
    else:
        stdscr.addstr("You lose!\n")
    stdscr.addstr("Press any key to play again, or q to quit.\n")
    key = stdscr.getch()
    if key == ord('q'):
        return False
    return True

def main(stdscr):
    curses.curs_set(0)
    stdscr.keypad(True)
    while play_round(stdscr):
        pass

if __name__ == "__main__":
    curses.wrapper(main)