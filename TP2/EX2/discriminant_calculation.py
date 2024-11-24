import sys

a = float(sys.argv[1])
b = float(sys.argv[2])
c = float(sys.argv[3])

def calculate_discriminant(a, b, c):
    return b**2 - 4*a*c


D = calculate_discriminant(a, b, c)

with open("discriminant.txt", "w") as file:
    file.write(str(D))
