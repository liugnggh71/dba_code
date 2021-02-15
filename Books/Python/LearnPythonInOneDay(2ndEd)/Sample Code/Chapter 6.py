#------------if Example-----------------

print("\n\nif Example")
print("---------------------")

userInput = input('Enter 1 or 2: ')

if userInput == "1":
    print ("Hello World")
    print ("How are you?")
elif userInput == "2":
    print ("Python Rocks!")
    print ("I love Python")
else:
    print ("You did not enter a valid number")


#------------Inline if Example-----------------

print("\n\nInline if Example")
print("---------------------")

userInput = input('Enter a number: ')

num1 = 12 if userInput=="1" else 13
print(num1)

print ("This is task A" if userInput == "1" else "This is task B")

#------------for Example 1 (list)-----------------

print("\n\nfor Example 1 (list)")
print("---------------------")

pets = ['cats', 'dogs', 'rabbits', 'hamsters']

for myPets in pets:
    print(myPets)

#------------for Example 2 (enumerate)-----------------

print("\n\nfor Example 2 (enumerate)")
print("---------------------")

for index, myPets in enumerate(pets):
    print(index, myPets)

#------------for Example 3 (dictionary 1)-----------------

print("\n\nfor Example 3 (dictionary 1)")
print("---------------------")

age = {'Peter': 5, 'John':7}

for i in age:
    print(i)

#------------for Example 4 (dictionary 2)-----------------

print("\n\nfor Example 4 (dictionary 2)")
print("---------------------")

age = {'Peter': 5, 'John':7}

for i in age:
    print("Name = %s, Age = %d" %(i, age[i]))

#------------for Example 5 (dictionary 3)-----------------

print("\n\nfor Example 5 (dictionary 3)")
print("---------------------")

age = {'Peter': 5, 'John':7}

for i, j in age.items():
    print("Name = %s, Age = %d" %(i, j))

#------------for Example 6 (string)-----------------

print("\n\nfor Example 6 (string)")
print("---------------------")

message = 'Hello'

for i in message:
    print (i)

#------------for Example 7 (range)-----------------

print("\n\nfor Example 7 (range)")
print("---------------------")

for i in range(5):
    print (i)

#------------while Example-----------------

print("\n\nwhile Example")
print("---------------------")

counter = 5

while counter > 0:
    print ("Counter = ", counter)
    counter = counter - 1

#------------break Example-----------------

print("\n\nbreak Example")
print("---------------------")

j = 0
for i in range(5):
    j = j + 2
    print ('i = ', i, ', j = ', j)
    if j == 6:
        break

#------------continue Example-----------------

print("\n\ncontinue Example")
print("---------------------")

j = 0
for i in range(5):
    j = j + 2
    print ('\ni = ', i, ', j = ', j)
    if j == 6:
        continue
    print ('I will be skipped over if j=6')

#------------try Example 1-----------------
'''
print("\n\ntry Example 1")
print("---------------------")

try:
    answer = 12/0
    print (answer)
except:
    print ("An error occurred")
'''
#------------try Example 2-----------------

print("\n\ntry Example 2")
print("---------------------")

try:
    userInput1 = int(input("Please enter a number: "))
    userInput2 = int(input("Please enter another number: "))
    answer =userInput1/userInput2
    print ("The answer is ", answer)
    myFile = open("missing.txt", 'r')
except ValueError:
    print ("Error: You did not enter a number")
except ZeroDivisionError:
    print ("Error: Cannot divide by zero")
except Exception as e:
    print ("Unknown error: ", e)



