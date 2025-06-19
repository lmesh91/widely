from collections import defaultdict
import sympy, primefac
from sympy import primefactors

# Brute-forces all possibilities to check if/when primes can be reused in covering systems
base = 10
max_phi = 1000
k_smooth = 7
max_prime = 10000

def test_it(mod, prime):
    # Map: start -> list of (next, add)
    transitions = defaultdict(list)

    for i in range(2, base):
        for j in range(0, mod):
            val = i * base ** j % prime
            if 0 < val < i:
                transitions[val].append((i, j))

    # Now, try to chain relationships
    # For each start, follow the chain as far as possible
    visited = set()
    if len(transitions) > 0:
        print("Transitions mod", mod, "p =", prime)
    for start in transitions:
        if start in visited:
            continue
        chain = [start]
        adds = []
        current = start
        while True:
            nexts = transitions.get(current)
            if not nexts:
                break
            # Take the first transition for simplicity
            next_val, add_val = nexts[0]
            if next_val in chain:
                break  # avoid cycles
            chain.append(next_val)
            adds.append(add_val)
            visited.add(current)
            current = next_val
        if len(chain) > 1:
            print("->".join(map(str, chain)) + " add " + ",".join(map(str, adds)))

def cyclo(n, i):
    """
    Computes the i-th cyclotomic polynomial for n.
    The sympy implementation uses its polynomial representation first, which makes it slow.
    This evaluates the polynomial directly using the formula:
    phi(n) = product_{d|n} (x^d - 1)^{mu(n/d)}
    where mu is the Möbius function.
    """
    x = sympy.Integer(i)  # ensure exact integer arithmetic
    numerators = []
    denominators = []
    for d in sympy.divisors(n):
        mu = sympy.mobius(n // d)
        if mu == 1:
            numerators.append(x**d - 1)
        elif mu == -1:
            denominators.append(x**d - 1)

    result = sympy.Integer(1)
    for term in numerators:
        result *= term
    for term in reversed(denominators):
        if term == 0:
            continue
        result //= term  # safe exact division
    return result

def trialfac(n, phi, limit=None):
    '''
    Small trial factorization for cyclotomic polynomials.
    '''
    if n <= 3:
        return []
    if primefac.isprime(n):
        return [n]
    if not limit:
        limit = max_prime
    
    facs = []
    # Trial division
    nroot = primefac.isqrt(n)
    for i in range(1, limit):
        if phi * i + 1 > nroot:
            break
        if primefac.isprime(int(phi * i + 1)) and n % (phi * i + 1) == 0:
            facs.append(int(phi * i + 1))
    return facs

# Check all primes in a range
def is_n_smooth(n, k):
    return all(p <= k for p in primefactors(n))

for phi in range(1, max_phi + 1):
    if not is_n_smooth(phi, k_smooth):
        continue
    n = int(cyclo(phi, base))
    for f in trialfac(n, phi):
        test_it(phi, f)


exit(0)

# Check all primes in a special file
file = open("coverings.txt").read()
splitSet = [i.split(" ") for i in file.split("\n")]
for i in splitSet:
    if len(i) == 2:
        #print("Testing mod "+i[0]+" p="+i[1])
        test_it(int(i[0]), int(i[1]))

exit(0)

# Check all primes in a file
file = open("Coverings/base"+str(base)+"_lowmod.txt", "r").read().split("<")[1:]
for coveringSet in file:
    splitSet = coveringSet.split(">\n")
    splitSet = [i.split(" ") for i in splitSet[1].split("\n")]
    gcf = 1
    for i in splitSet:
        if len(i) == 3:
            #print("Testing mod "+i[1]+" p="+i[2])
            test_it(int(i[1]), int(i[2]))