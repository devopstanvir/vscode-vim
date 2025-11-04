pip install windows-curses
import random
import sys
import curses

choices = ['rock', 'paper', 'scissors']

def get_user_choice(stdscr):
    stdscr.clear()
    stdscr.addstr("Rock, Paper, Scissors!\n")
    stdscr.addstr("Choose:\n")
    for idx, choice in enumerate(choices):
        stdscr.addstr(f"{idx+1}. {choice}\n")
    stdscr.addstr("Press 1/2/3 to select, or q to quit.\n")
    stdscr.refresh()
    while True:
        key = stdscr.getch()
        if key == ord('q'):
            return None
        elif key in [ord('1'), ord('2'), ord('3')]:
            return choices[key - ord('1')]

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
    while play_round(stdscr):
        pass

if __name__ == "__main__":
    curses.wrapper(main)