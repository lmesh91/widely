# A simple Python script to search for small digitally immutable primes
from sympy import isprime
from itertools import islice
digits = "0123456789"
def is_dd(p):
    s = str(p)
    L = len(s)
    for i in range(L):
        for d in digits:
            if s[i] != d:
                if isprime(int(s[:i]+d+s[i+1:])):
                    return False
    return True
def is_ni(p): #https://oeis.org/A125001
    s = str(p)
    for c in digits:
        for k in range(len(s)+1):
            w = s + c if k == 0 else s[:-k] + c + s[-k:]
            if w[0] != "0" and isprime(int(w)): return False
    return True
min_val = 3874159411
max_val = 4000000000
for i in range(min_val, max_val+1):
    if i % 1000000 == 0:
        print(str(i//1000000)+"M")
    if isprime(i):
        if is_ni(i):
            print("NI prime: "+str(i))
            if is_dd(i):
                print("DIGITALLY IMMUTABLE PRIME: "+str(i))
                exit(0)