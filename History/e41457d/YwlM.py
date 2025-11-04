import curses
import subprocess

commands = [
    ("Status", ["git", "status"]),
    ("Log", ["git", "log", "--oneline", "--graph", "--decorate", "--all"]),
    ("Add .", ["git", "add", "."]),
    ("Commit", ["git", "commit", "-m", "TUI commit"]),
    ("Push", ["git", "push"]),
    ("Quit", None)
]

def run_command(cmd):
    try:
        result = subprocess.run(cmd, capture_output=True, text=True, check=True)
        return result.stdout
    except subprocess.CalledProcessError as e:
        return e.stderr

def main(stdscr):
    curses.curs_set(0)
    stdscr.keypad(True)
    selected = 0
    while True:
        stdscr.clear()
        stdscr.addstr("Git CLI TUI\n", curses.A_BOLD)
        stdscr.addstr("Use ↑/↓ to choose, Enter to run, q to quit.\n\n")
        for idx, (name, _) in enumerate(commands):
            if idx == selected:
                stdscr.addstr(f"> {name}\n", curses.A_REVERSE)
            else:
                stdscr.addstr(f"  {name}\n")
        stdscr.refresh()
        key = stdscr.getch()
        if key == ord('q') or (selected == len(commands) - 1 and key in [10, 13]):
            break
        elif key in [curses.KEY_UP, ord('w')]:
            selected = (selected - 1) % len(commands)
        elif key in [curses.KEY_DOWN, ord('s')]:
            selected = (selected + 1) % len(commands)
        elif key in [10, 13]:  # Enter
            cmd = commands[selected][1]
            if cmd:
                stdscr.clear()
                stdscr.addstr(f"Running: {' '.join(cmd)}\n\n", curses.A_BOLD)
                output = run_command(cmd)
                for line in output.splitlines():
                    stdscr.addstr(line + "\n")
                stdscr.addstr("\nPress any key to return to menu.")
                stdscr.refresh()
                stdscr.getch()

if __name__ == "__main__":
    curses.wrapper(main)