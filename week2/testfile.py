python3
import this

2 + 2 # Summation; note that comments still start with #
2 * 2 # Multiplication
2 / 2 # division
2//2
2 > 3 # logical operation
2 >= 2 # another one

#Python Variables
a = 2 #integer
type(a)

a = 2. #Float
type(a)

a = "Two" #String
type(a)

a = True #Boolean
type(a)

#Assigning and manipulating variables
2 == 2
2 != 2
3 / 2
3 // 2
'hola, ' + 'me llamo Samraat' #why not learn two human languages at the same time?! 
x = 5
x + 3

y = 2
x + y

x = 'My string'
x + ' now has more stuff'

x + y #Doesn't Work
x + str(y) #convert from one to another

z = '88'
x + z

y + int(z)

# Python data structures
#Lists
MyList = [3,2.44,'green',True]
MyList[1]
MyList[0]
# Note that python “indexing” starts at 0, not 1!
#MyList[4] #Error as expected

MyList[2] = 'blue'
MyList

MyList.append('a new item')
#Note .append. This is an operation (a “method”) that can be applied to any “object” with the “class” list. You can check the type of any object:
%whos
type(MyList)
print(type(MyList))
MyList
del MyList[2]
MyList

#Tuples
MyTuple = ("a", "b", "c")
print(MyTuple)

type(MyTuple)

MyTuple[0]

FoodWeb=[('a','b'),('a','c'),('b','c'),('c','c')]
FoodWeb
FoodWeb[0]
FoodWeb[0][0]
FoodWeb[0][0] = "bbb" #Error  tuples are “immutable”!

FoodWeb[0] = ("bbb","ccc") 
FoodWeb[0]

a = (1, 2, []) 
a
a[2].append(1000)
a
a[2].append(1000)
a
a[2].append((100,10))
a

a = (1, 2, 3)
b = a + (4, 5, 6)
b
c = b[1:]
c
b = b[1:]
b

a = ("1", 2, True)
a

# Sets
a = [5,6,7,7,7,8,9,9]
b = set(a)
b

c = set([3,4,5,6])
b & c # intersection
b | c # union