#------------% Example-----------------

print("\n\n% Example")
print("---------------------")

brand = 'Apple'
exchangeRate = 1.235235245
message = 'The price of this %s laptop is %d USD and the exchange rate is %4.2f USD to 1 EUR' %(brand, 1299, exchangeRate)

print (message)

#------------format() Example 1-----------------

print("\n\nformat() Example 1")
print("---------------------")

message = 'The price of this {0:s} laptop is {1:d} USD and the exchange rate is {2:4.2f} USD to 1 EUR'.format('Apple', 1299, 1.235235245)

print (message)

#------------format() Example 2-----------------

print("\n\nformat() Example 2")
print("---------------------")

message = 'The price of this {} laptop is {} USD and the exchange rate is {} USD to 1 EUR'.format('Apple', 1299, 1.235235245)

print (message)

#------------format() Example 3-----------------

print("\n\nformat() Example 3")
print("---------------------")

message1 = '{0} is easier than {1}'.format('Python', 'Java')
message2 = '{1} is easier than {0}'.format('Python', 'Java')
message3 = '{:10.2f} and {:d}'.format(1.234234234, 12)
message4 = '{}'.format(1.234234234)

print (message1)
#You’ll get 'Python is easier than Java'

print (message2)
#You’ll get 'Java is easier than Python'

print (message3)
#You’ll get '      1.23 and 12'
#You do not need to indicate the positions of the arguments.

print (message4)
#You’ll get '1.234234234'. No formatting is done.

#------------List Example-----------------

print("\n\nList Example")
print("---------------------")

#declaring the list, list elements can be of different data types
myList = [1, 2, 3, 4, 5, "Hello"]	

#print the entire list. 
print(myList)					
#You’ll get [1, 2, 3, 4, 5, "Hello"]

#print the third item (recall: Index starts from zero). 
print(myList[2])				
#You’ll get 3

#print the last item. 
print(myList[-1])	
#You’ll get "Hello"

#assign myList (from index 1 to 4) to myList2 and print myList2
myList2 = myList[1:5]
print (myList2)
#You’ll get [2, 3, 4, 5]

#modify the second item in myList and print the updated list
myList[1] = 20
print(myList)					
#You’ll get [1, 20, 3, 4, 5, 'Hello']
			
#append a new item to myList and print the updated list
myList.append("How are you")		
print(myList)					
#You’ll get [1, 20, 3, 4, 5, 'Hello', 'How are you']

#remove the sixth item from myList and print the updated list
del myList[5]					
print(myList)		
#You’ll get [1, 20, 3, 4, 5, 'How are you']

#------------Dictionary Example-----------------

print("\n\nDictionary Example")
print("---------------------")

#declaring the dictionary, dictionary keys and data can be of different data types
myDict = {"One":1.35, 2.5:"Two Point Five", 3:"+", 7.9:2}

#print the entire dictionary
print(myDict)					
#You’ll get {'One': 1.35, 2.5: 'Two Point Five', 3: '+', 7.9: 2}
#Items may be displayed in a different order
#Items in a dictionary are not necessarily stored in the same order as the way you declared them.

#print the item with key = "One".
print(myDict["One"])				
#You’ll get 1.35

#print the item with key = 7.9. 
print(myDict[7.9])	
#You’ll get 2

#modify the item with key = 2.5 and print the updated dictionary
myDict[2.5] = "Two and a Half"
print(myDict)					
#You’ll get {'One': 1.35, 2.5: 'Two and a Half', 3: '+', 7.9: 2}
			
#add a new item and print the updated dictionary
myDict["New item"] = "I’m new"		
print(myDict)					
#You’ll get {'One': 1.35, 2.5: 'Two and a Half', 3: '+', 7.9: 2, 'New item': 'I’m new'}

#remove the item with key = "One" and print the updated dictionary
del myDict["One"]					
print(myDict)	
#You’ll get {2.5: 'Two and a Half', 3: '+', 7.9: 2, 'New item': 'I’m new'}
