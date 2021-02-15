#------------Function Example-----------------

print("\n\nFunction Example")
print("---------------------")

def checkIfPrime (numberToCheck):
    for x in range(2, numberToCheck):
        if (numberToCheck%x == 0):
            return False
    return True

answer = checkIfPrime(13)

print(answer)

#------------Local vs Global variables Example 1-----------------

print("\n\nLocal vs Global variables Example 1")
print("---------------------")

message1 = "Global Variable"

def myFunction():
    print("\nINSIDE THE FUNCTION")
    #Global variables are accessible inside a function
    print (message1)
    #Declaring a local variable
    message2 = "Local Variable"
    print (message2)

'''
Calling the function
Note that myFunction() has no parameters. 
Hence, when we call this function, 
we use a pair of empty parentheses. 
'''
myFunction()

print("\nOUTSIDE THE FUNCTION")

#Global variables are accessible outside function
print (message1)

#Local variables are NOT accessible outside function.
#print (message2)

#------------Local vs Global variables Example 2-----------------

print("\n\nLocal vs Global variables Example 2")
print("---------------------")

message1 = "Global Variable (shares same name as a local variable)"

def myFunction():
    message1 = "Local Variable (shares same name as a global variable)"
    print("\nINSIDE THE FUNCTION")
    print (message1)	

# Calling the function
myFunction()

# Printing message1 OUTSIDE the function
print ("\nOUTSIDE THE FUNCTION")
print (message1)

#------------Default Parameter Values Example-----------------

print("\n\nDefault Parameter Values Example")
print("---------------------")

def someFunction(a, b, c=1, d=2, e=3):
    print(a, b, c, d, e)

someFunction(10, 20)

someFunction(10, 20, 30, 40)

#------------Non-keyworded Variable Length Argument List Example-----------------

print("\n\nNon-keyworded Variable Length Argument List Example")
print("---------------------")

def addNumbers(*num):
    sum = 0
    for i in num:
        sum = sum + i
    print(sum)

addNumbers(1, 2, 3, 4, 5)

addNumbers(1, 2, 3, 4, 5, 6, 7, 8)

#------------Keyworded Variable Length Argument List Example-----------------

print("\n\nKeyworded Length Argument List Example")
print("---------------------")

def printMemberAge(**age):
    for i, j in age.items():
        print("Name = %s, Age = %s" %(i, j))

printMemberAge(Peter = 5, John = 7)

printMemberAge(Peter = 5, John = 7, Yvonne = 10)
