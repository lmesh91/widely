# Sample input
input_str = "[List([[Mod(0, 1), 3]]), List([[Mod(3, 6), 7], [Mod(0, 2), 11], [Mod(1, 16), 17], [Mod(3, 16), 5882353], [Mod(5, 32), 353], [Mod(21, 32), 449], [Mod(7, 32), 641], [Mod(23, 32), 1409], [Mod(9, 32), 69857], [Mod(25, 64), 19841], [Mod(57, 64), 976193], [Mod(11, 64), 6187457], [Mod(27, 64), 834427406578561], [Mod(43, 128), 1265011073], [Mod(107, 128), 15343168188889137818369], [Mod(59, 256), 257], [Mod(123, 256), 15361], [Mod(187, 256), 453377], [Mod(251, 512), 10753], [Mod(507, 512), 8253953], [Mod(13, 80), 5070721], [Mod(29, 80), 1676321], [Mod(45, 160), 1634881], [Mod(125, 160), 18453761], [Mod(61, 160), 947147262401], [Mod(141, 160), 5964848081], [Mod(77, 240), 1132716961], [Mod(157, 240), 19721061166646717498359681], [Mod(237, 240), 39526741], [Mod(15, 96), 66554101249], [Mod(31, 96), 75118313082913], [Mod(47, 192), 193], [Mod(143, 192), 769], [Mod(63, 192), 1253224535459902849], [Mod(159, 192), 53763491189967221358575546107279034709697], [Mod(79, 1152), 1153], [Mod(367, 1152), 23041], [Mod(655, 2304), 25597441], [Mod(1807, 2304), 260241409], [Mod(943, 3456), 1554750721], [Mod(2095, 3456), 5079461695489], [Mod(3247, 3456), 6123088911854233729], [Mod(175, 864), 196482241], [Mod(463, 864), 3199044596370769], [Mod(751, 864), 433], [Mod(271, 576), 577], [Mod(559, 576), 317752351489], [Mod(95, 384), 3457], [Mod(191, 384), 12289], [Mod(287, 384), 418725889], [Mod(383, 768), 434689], [Mod(767, 768), 859393]]), List([[Mod(0, 7), 239], [Mod(1, 7), 4649], [Mod(2, 14), 909091], [Mod(9, 28), 121499449], [Mod(23, 28), 29], [Mod(3, 21), 1933], [Mod(10, 21), 43], [Mod(17, 21), 10838689], [Mod(4, 28), 281], [Mod(11, 56), 7841], [Mod(39, 56), 127522001020150503761], [Mod(18, 84), 226549], [Mod(46, 84), 4458192223320340849], [Mod(74, 168), 11189053009], [Mod(158, 336), 337], [Mod(326, 672), 1454209], [Mod(662, 672), 9396577], [Mod(25, 140), 421], [Mod(53, 140), 3471301], [Mod(81, 140), 13489841], [Mod(109, 140), 60368344121], [Mod(137, 140), 848654483879497562821], [Mod(5, 35), 71], [Mod(12, 35), 123551], [Mod(19, 35), 102598800232111471], [Mod(26, 70), 4147571], [Mod(61, 70), 265212793249617641], [Mod(33, 105), 30703738801], [Mod(68, 105), 625437743071], [Mod(103, 105), 57802050308786191965409441], [Mod(4, 6), 7], [Mod(6, 42), 127], [Mod(13, 42), 2689], [Mod(27, 42), 459691], [Mod(20, 63), 10837], [Mod(41, 63), 23311], [Mod(62, 63), 45613]]), List([[Mod(0, 1), 3]]), List([[Mod(0, 5), 41], [Mod(1, 5), 271], [Mod(2, 10), 9091], [Mod(7, 20), 3541], [Mod(17, 20), 27961], [Mod(3, 15), 2906161], [Mod(8, 15), 31], [Mod(13, 45), 238681], [Mod(28, 45), 4185502830133110721], [Mod(43, 135), 1577071], [Mod(88, 135), 16357951], [Mod(133, 135), 310362841], [Mod(4, 25), 25601], [Mod(9, 25), 182521213001], [Mod(14, 25), 21401], [Mod(19, 50), 251], [Mod(44, 50), 5051], [Mod(24, 50), 78875943472201], [Mod(49, 100), 60101], [Mod(99, 100), 7019801]]), List([[Mod(0, 3), 37], [Mod(2, 6), 7], [Mod(4, 6), 13], [Mod(1, 30), 241], [Mod(7, 30), 211], [Mod(13, 30), 2161], [Mod(19, 60), 61], [Mod(49, 60), 4188901], [Mod(25, 90), 29611], [Mod(55, 90), 3762091], [Mod(85, 90), 8985695684401], [Mod(5, 36), 999999000001], [Mod(11, 72), 3169], [Mod(47, 72), 98641], [Mod(17, 108), 109], [Mod(53, 108), 757], [Mod(89, 108), 153469], [Mod(23, 144), 8929], [Mod(59, 144), 111994624258035614290513943330720125433979169], [Mod(95, 288), 13249], [Mod(239, 288), 1067329], [Mod(131, 432), 70541929], [Mod(275, 432), 14175966169], [Mod(419, 432), 440334654777631], [Mod(29, 180), 181], [Mod(65, 180), 4999437541453012143121], [Mod(101, 180), 1105097795002994798105101], [Mod(137, 360), 265183201], [Mod(317, 360), 100009999999899989999000000010001], [Mod(173, 540), 541], [Mod(353, 540), 329941], [Mod(533, 540), 49229101], [Mod(35, 252), 1009], [Mod(71, 252), 43266855241], [Mod(107, 252), 45121231], [Mod(143, 252), 5274739], [Mod(179, 252), 189772422673235585874485732659], [Mod(215, 504), 41593295521], [Mod(467, 504), 603812429055411913], [Mod(251, 252), 1921436048294281]]), List([[Mod(0, 1), 3]]), List([[Mod(1, 3), 37], [Mod(5, 6), 7], [Mod(3, 6), 13], [Mod(0, 18), 333667], [Mod(6, 18), 19], [Mod(12, 18), 52579], [Mod(2, 12), 9901], [Mod(8, 24), 99990001], [Mod(20, 96), 97], [Mod(68, 96), 206209], [Mod(44, 48), 9999999900000001]]), List([[Mod(1, 2), 11], [Mod(0, 4), 101], [Mod(2, 8), 73], [Mod(6, 8), 137]])]"

input_str = input_str.replace("List(", "");
input_str = input_str.replace("Mod(", "");
input_str = input_str.replace(")", "");
exec("input = "+input_str)
print(input)

# Analyzes and verifies covering system
import math
import sys
sys.set_int_max_str_digits(5000) # Increased to work for Southwick's base 10 covering
base = 10
commonFac = 1 # The common factor of the primes in the covering system; the A in An+B
moduli = 0 # Number of congruences used
globalModDict = {} # Dict for storing all primes used in the set
localModList = [] # List of primes used in each local set
verifyRepeats = True # Verifies that repeated primes are used properly
verifyPrimes = True # Verifies each prime divides into covering set
verifyCovering = True # Verifies covering sets cover every possible number
compositeCheck = True # Verifies that no congruences force a number to be composite
congruenceUsageCheck = False # Checks the usage of each congruence across the LCM
for q in range(len(input)):
    print("Covering for A+"+str(q+1)+"*"+str(base)+"^n")
    splitSet = input[q]
    lcm = 1
    localModList = []
    for i in splitSet:
        if len(i) == 3:
            moduli += 1
            moduland = (-1 * int(q+1) * base ** int(i[0])) % int(i[2])
            print(str(i[0])+" mod "+str(i[1])+" ("+str(i[2])+") -> " + str(moduland) + " mod " + str(i[2]))
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
# It's important to note that when finding a widely digitally delicate prime, the covering set should be verified for the prime.