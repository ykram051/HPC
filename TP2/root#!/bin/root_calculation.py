import math
import sys

with open("discriminant.txt", "r") as file:
    D = float(file.read())

def calculate_roots(D, a, b):
    if D > 0:
        root1 = (-b + math.sqrt(D)) / (2 * a)
        root2 = (-b - math.sqrt(D)) / (2 * a)
        print(f"The roots are real and different: {root1}, {root2}")
    elif D == 0:
        root = -b / (2 * a)
        print(f"The root is real and repeated: {root}")
    else:
        print("The equation has no real roots.")

a = float(sys.argv[1])
b = float(sys.argv[2])

calculate_roots(D, a, b)
