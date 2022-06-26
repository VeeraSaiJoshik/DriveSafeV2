import random

numberList = []

for i in range(100):
    number = ""
    for j in range(10):
        number = number + str(random.randrange(start=0, stop = 9))
    numberList.append(number)
print(numberList)
