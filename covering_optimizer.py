# Analyzes and verifies covering system
# Updated to compare to factordb stuff
import math
import sys
import re
sys.set_int_max_str_digits(5000) # Increased to work for Southwick's base 10 covering
base = 10
file = open("Coverings/base"+str(base)+".txt", "r").read().split("<")[1:]
commonFac = 1 # The common factor of the primes in the covering system; the A in An+B
moduli = 0 # Number of congruences used
globalModDict = {} # Dict for storing all primes used in the set
localModList = [] # List of primes used in each local set
verifyRepeats = True # Verifies that repeated primes are used properly
verifyPrimes = True # Verifies each prime divides into covering set
verifyCovering = True # Verifies covering sets cover every possible number
compositeCheck = True # Verifies that no congruences force a number to be composite
congruenceUsageCheck = False # Checks the usage of each congruence across the LCM
for coveringSet in file:
    splitSet = coveringSet.split(">\n")
    coverNum = splitSet[0]
    print("Covering for A+"+coverNum+"*"+str(base)+"^n")
    splitSet = [i.split(" ") for i in splitSet[1].split("\n")]
    lcm = 1
    localModList = []
    for i in splitSet:
        if len(i) == 3:
            moduli += 1
            moduland = (-1 * int(coverNum) * base ** int(i[0])) % int(i[2])
            print(i[0]+" mod "+i[1]+" ("+i[2]+") -> " + str(moduland) + " mod " + i[2])
            if compositeCheck and moduland == 0 and int(i[2]) > 1:
                print("Results in composite numbers!")
                exit(0)
            if verifyPrimes:
                if (base ** int(i[1]) - 1) % int(i[2]) != 0:
                    print("Invalid prime: " + i[2] + " does not divide into " + str(base) + "^" + i[1] + "-1")
                    exit(0)
            if i[2] in globalModDict:
                if globalModDict[i[2]] != moduland and verifyRepeats:
                    print("Mismatch in reused prime "+i[2]+":")
                    print(str(globalModDict[i[2]]) + ", " + str(moduland))
                    exit(0)
            else:
                globalModDict[i[2]] = moduland
            localModList.append((int(i[0]), int(i[1])))
            lcm = math.lcm(lcm, int(i[1]))
            commonFac = math.lcm(commonFac, int(i[2]))
    print("LCM: "+str(lcm))
    if congruenceUsageCheck:
        for c in localModList:
            copyModList = [x for x in localModList]
            copyModList.remove(c)
            uncovered = []
            for i in range(lcm):
                covered = False
                idx = 0
                while not covered:
                    if idx >= len(copyModList):
                        uncovered.append(i)
                        covered = True
                    elif i % copyModList[idx][1] == copyModList[idx][0]:
                        covered = True
                    idx += 1
            print(str(c[0]) + " mod " + str(c[1]) + " needed " + str(len(uncovered)) + " time(s)")
            if len(uncovered) <= 20:
                print(uncovered)
            if len(uncovered) == 0:
                print("Delete this one!")
                exit(0)

    if verifyCovering:
        for i in range(lcm):
            covered = False
            idx = 0
            while not covered:
                if idx >= len(localModList):
                    print("Incomplete covering set: " + str(i) + " mod " + str(lcm) + " not covered")
                    exit(0)
                if i % localModList[idx][1] == localModList[idx][0]:
                    covered = True
                idx += 1
print("Common Factor: "+str(commonFac)+" ("+str(len(str(commonFac)))+" digits)")
print(str(moduli)+" sets")
if verifyCovering and verifyPrimes and verifyRepeats and compositeCheck:
    print("All required tests performed - this covering set is valid!")
fac = re.sub('<[^>]+>', '', input("Enter FactorDB Data: ")).split(" · ")
print("Unused factors:")
for f in fac:
    if f not in globalModDict.keys():
        print(f)
# It's important to note that when finding a widely digitally delicate prime, the covering set should be verified for the prime.