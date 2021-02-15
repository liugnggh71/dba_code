#------------Reading Text File Example 1-----------------

print("\n\nReading Text File Example 1")
print("---------------------")

f = open ('myfile.txt', 'r')

firstline = f.readline()
secondline = f.readline()

print (firstline)
#print(firstline, end = '')
print (secondline)

f.close()

#------------Reading Text File Example 2-----------------

print("\n\nReading Text File Example 2")
print("---------------------")

f = open ('myfile.txt', 'r')

for line in f:
    print (line, end = '')

f.close()

#------------Writing to a Text File Example-----------------

print("\n\nWriting to a Text File Example")
print("---------------------")


f = open ('myfile.txt', 'a')

f.write('\nThis sentence will be appended.')
f.write('\nPython is Fun!')

f.close()

#------------Buffer Size Example-----------------

print("\n\nBuffer Size Example")
print("---------------------")

inputFile = open ('myfile.txt', 'r')
outputFile = open ('myoutputfile.txt', 'w')

msg = inputFile.read(10)

while len(msg):
    #outputFile.write(msg + '\n')
    outputFile.write(msg)
    msg = inputFile.read(10)    
    
inputFile.close()
outputFile.close()

#------------Binary File Example-----------------

print("\n\nBinary File Example")
print("---------------------")

inputFile = open ('myimage.jpg', 'rb')
outputFile = open ('myoutputimage.jpg', 'wb')

msg = inputFile.read(10)

while len(msg):
    outputFile.write(msg)
    msg = inputFile.read(10)    
    
inputFile.close()
outputFile.close()
