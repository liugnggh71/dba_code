'''
import sys

if 'C:\\MyPythonModules' not in sys.path:
    sys.path.append('C:\\MyPythonModules')
'''

import prime
answer = prime.checkIfPrime(13)
print (answer)
