# Brute-forces all possibilities to check if/when primes can be reused in covering systems
base = 6
#mod = 18
#prime = 109

def test_it(mod, prime):
    for i in range(2, base):
        for j in range(0, mod):
            if (0 < i * base ** j % prime < i):
                print(str(i * base ** j % prime)+"->"+str(i)+" add "+str(j))

test_it(5, 311)
exit(0)

# Check all primes in a file
file = open("Coverings/base"+str(base)+"_lowmod.txt", "r").read().split("<")[1:]
for coveringSet in file:
    splitSet = coveringSet.split(">\n")
    splitSet = [i.split(" ") for i in splitSet[1].split("\n")]
    gcf = 1
    for i in splitSet:
        if len(i) == 3:
            print("Testing mod "+i[1]+" p="+i[2])
            test_it(int(i[1]), int(i[2]))