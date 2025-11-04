import math

# Python Basics for Beginners

# 1. Printing output
print("Hello, World!")  # Prints text to the console

# 2. Getting user input
name = input("Enter your name: ")  # Prompts user and stores input as a string
print("Hello,", name)

# 3. Variables and Data Types
age = 25                # Integer
height = 5.9            # Float
is_student = True       # Boolean
message = "Welcome!"    # String

# 4. Lists (Arrays in other languages)
fruits = ["apple", "banana", "cherry"]  # List of strings
print(fruits[0])        # Access first element
fruits.append("orange") # Add an element
print(fruits)

# 5. Tuples (Immutable lists)
coordinates = (10, 20)  # Tuple with two integers
print(coordinates[1])   # Access second element

# 6. Dictionaries (Key-value pairs)
person = {"name": "Alice", "age": 30}
print(person["name"])   # Access value by key

# 7. Conditional Statements
if age > 18:
    print("You are an adult.")
else:
    print("You are a minor.")

# 8. Loops
# For loop
for fruit in fruits:
    print(fruit)        # Prints each fruit in the list

# While loop
count = 0
while count < 3:
    print("Counting:", count)
    count += 1

# 9. Functions
def greet(user_name):
    """Greets the user by name."""
    print("Hello,", user_name)

greet(name)

# 10. Comments
# This is a single-line comment

"""
This is a
multi-line comment
or docstring.
"""

# 11. Importing modules
print(math.sqrt(16))    # Prints the square root of 16

# 12. Error handling
try:
    number = int(input("Enter a number: "))
    print("You entered:", number)
except ValueError:
    print("That's not a valid number!")

# 13. List comprehensions (Advanced, but useful)
squares = [x**2 for x in range(5)]  # Creates a list of squares
print(squares)