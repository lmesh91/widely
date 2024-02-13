\\ Global vars
wdBase = 10
filename = concat(concat("Coverings/base",wdBase),".txt")
printIncrement = 1000

\\Modes:
\\0 - Search for WDDelicate
\\1 - Search for WDUnstable
\\2 - Search for WDImmutable
\\3 - Optimize WDDelicate
\\4 - Optimize WDUnstable
\\5 - Optimize WDImmutable
\\-1 - Search a range (Not implemented)
mode = -1

\\Includes 1 mod 2, to discard even candidates
\\Only enable for covering sets that don't have this factor
\\Not recommended for -1
include1mod2 = 0

\\Optimization/Searching options
\\Search uses startSeed and maxSeed
startSeed = 0
seedsPerThread = 10000 \\number of seeds run in parallel each time
maxSeed = 999999
maxNum = oo
searchRounds = oo
stopOnOutput = 1
printScore = 1
writeScore = 3

\\Shows progress of how close primes are to being widely digitally ___
showProgress = 1
progressThreshold = 0

\\ Check if a prime is digitally delicate
is_delicate(n, base) = {
    \\ Get the digits of n in the base
    v = digits(n, base);
    maxNumTests = 9*#v;
    numTests = 0;
    \\ Loop through each position and digit
    for (k=1, #v, w = v;
        for (j=0, base-1,
            if (j != v[k], w[k] = j;
                \\ Plugs the digits back into the base 
                ntest = subst(Pol(w), x, base);
                if (ispseudoprime(ntest), return(-1*numTests/maxNumTests)); 
                numTests += 1;
            ); 
        ); 
    ); 
    return (1);
}

\\ Check if a prime is digitally delicate (only lower digits, as the rest would be covered)
is_delicate_w(n, base) = {
    \\ Get the digits of n in the base
    my(v = digits(n, base));
    my(maxNumTests = 9*#v);
    my(numTests = 0);
    \\ Loop through each position and digit
    for (k=1, #v, my(w = v);
        for (j=0, base-1,
            if (j < v[k], w[k] = j;
                \\ Plugs the digits back into the base 
                my(ntest = subst(Pol(w), x, base));
                if (ispseudoprime(ntest), return(-1*(numTests+j)/maxNumTests)); 
            );
        );
        numTests += 9; 
    ); 
    return (1);
}

\\ Check if a prime is digitally delicate (only lower digits, as the rest would be covered) - does not compute info on % complete
is_delicate_w_fast(n, base) = {
    \\ Get the digits of n in the base
    my(v = digits(n, base));
    \\ Loop through each position and digit
    for (k=1, #v, my(w = v);
        for (j=0, base-1,
            if (j < v[k], w[k] = j;
                \\ Plugs the digits back into the base 
                my(ntest = subst(Pol(w), x, base));
                if (ispseudoprime(ntest), return(0)); 
            );
        );
    ); 
    return (1);
}

\\ Check if a prime is digitally unstable
is_unstable(n, base) = {
    \\ Get the digits of n in the base
    v = digits(n, base);
    maxNumTests = 9*#v+8;
    numTests = 0;
    \\ Loop through each position and digit
    for (k=1, 1+#v, w = v;
        for (j=0, base-1,
            \\ Why all this weird syntactical jargon? Because for some reason I have to convert between a list and a vector here...
            if (j+k!=1, l=List(w); listinsert(~l,j,k);
                \\ Plugs the digits back into the base 
                ntest = subst(Pol(Vec(l)), x, base);
                if (ispseudoprime(ntest), return(-1*numTests/maxNumTests)); 
                numTests++;
            ); 
        ); 
    ); 
    return (1);
}

\\ Check if a prime is digitally unstable - does not compute info on % complete
is_unstable_fast(n, base) = {
    \\ Get the digits of n in the base
    my(v = digits(n, base));
    \\ Loop through each position and digit
    for (k=1, 1+#v, my(w = v);
        for (j=0, base-1,
            \\ Why all this weird syntactical jargon? Because for some reason I have to convert between a list and a vector here...
            if (j+k!=1, my(l=List(w)); listinsert(~l,j,k);
                \\ Plugs the digits back into the base 
                my(ntest = subst(Pol(Vec(l)), x, base));
                if (ispseudoprime(ntest), return(0)); 
            ); 
        ); 
    ); 
    return (1);
}

\\Check if a prime is digitally immutable
is_immutable(n, base) = {
    isUns = is_unstable(n, base);
    if (isUns < 0, return(isUns));
    isDel = is_delicate(n, base);
    if (isDel < 0, return(-1+isDel));
    return(1);
}

\\Check if a prime is digitally immutable (only lower digits for delicates)
is_immutable_w(n, base) = {
    isUns = is_unstable(n, base);
    if (isUns < 0, return(isUns));
    isDel = is_delicate_w(n, base);
    if (isDel < 0, return(-1+isDel));
    return(1);
}

\\Check if a prime is digitally immutable (only lower digits for delicates) - does not compute info on % complete
is_immutable_w_fast(n, base) = {
    if (is_unstable_fast(n, base) && is_delicate_w_fast(n, base), return (1));
    return(0);
}

\\Remove all occurrences of all entries that appear multiple times from a List
remove_dups(l) = {
    listsort(l);
    goodNums = List([]);
    justRemoved = 0;
    for (i = 1, #l-1,\
        if (#l > i,\
        if (l[i]==l[i+1],\
            if (#l > i+1,\
                if (l[i]!=l[i+2],listpop(l,i+1)),\
                listpop(l,i+1);\
            );\
            listpop(l,i);\
            i = i - 1;\
            justRemoved = 1,\
            listput(goodNums,l[i]);\
            justRemoved = 0;\
        ););\
    );
    if (justRemoved == 0, listput(goodNums,l[#l]));
    return (goodNums);
}

print("Starting program...");

\\Read covering file
coveringFile = fileopen(filename);
covering = List([])
usedMods = Map()
while (l = filereadstr(coveringFile),\
    v = Vec(l);\
    if (v[1] == "<",\
        listput(covering, List([]));\
        listIdx = eval(v[2]);\
        congruence = strsplit(filereadstr(coveringFile), " ");\
        while (length(congruence) == 3,\
            listput(covering[listIdx], [Mod(eval(congruence[1]),eval(congruence[2])),eval(congruence[3])]);\
            if (mapisdefined(usedMods,eval(congruence[2])),\
                usedModList = mapget(usedMods,eval(congruence[2]));\
                listput(usedModList,eval(congruence[3]));\
                mapput(usedMods,eval(congruence[2]),usedModList),\
                mapput(usedMods,eval(congruence[2]),List([eval(congruence[3])])));\
            res = filereadstr(coveringFile);\
            if (res != 0, congruence = strsplit(res, " "), congruence = []);\
        ),\
    )\
);

\\Get all groups of non-reused primes with same order
usedModKeys = Vec(usedMods);
for (i = 1, #usedModKeys,\
  usedModList = remove_dups(mapget(usedMods,usedModKeys[i]));\
  if (#usedModList<2,\
      mapdelete(usedMods,usedModKeys[i]),\
      mapput(usedMods,usedModKeys[i],usedModList);\
  );\
);

\\Get position of each used entry
usedModKeys = Vec(usedMods);
\\Quickly print info on number of permutations
print("Number of permutations for optimization:");
print(floor(prod(i = 1, #usedModKeys, factorial(#(mapget(usedMods,usedModKeys[i]))))));
print("");
for (i = 1, #usedModKeys,\
    usedModList = mapget(usedMods,usedModKeys[i]);\
    usedModLocations = List([]);\
    for (m = 1, #usedModList,\
        for (n = 1, #covering,\
            for (c = 1, #covering[n],\
                if (covering[n][c][2] == usedModList[m],\
                    if (covering[n][c][1].mod == usedModKeys[i], listput(usedModLocations,[n,c]));\
    ););););\
    mapput(usedMods,usedModKeys[i],[usedModList,usedModLocations]);\
);

\\Function to create a covering set with a given seed
construct_covering(seed) = {
    my(covering_mod = covering);
    for (i = 1, #usedModKeys,\
        my(usedModList = mapget(usedMods,usedModKeys[i]));\
        my(seedForMod = floor(seed % factorial(#usedModList[1])));
        seed = seed \ factorial(#usedModList[1]);
        my(perm = numtoperm(#usedModList[1], seedForMod));
        for (p = 1, #perm,\
            covering_mod[usedModList[2][p][1]][usedModList[2][p][2]][2] = usedModList[1][perm[p]];\
        );\
    );\
    return ([seed,covering_mod]);
}

\\Function to create a WD candidate from a seed
construct_widely_candidate(seed) = {
    my(covering_info = construct_covering(seed));
    if (covering_info[1] >= searchRounds, quit);

    \\Create a list of moduli that need to be satisfied
    my(moduli = List([]));\
    for (i = 1, wdBase-1,\
        for(j = 1, length(covering_info[2][i]),\
        listput(moduli, Mod((-1 * i * wdBase ^ lift(covering_info[2][i][j][1])) % covering_info[2][i][j][2], covering_info[2][i][j][2]));\
        );\
    );

    \\Convert to a single congruence
    my(wdCongruence = moduli[1]);
    for (i = 2, length(moduli), wdCongruence = chinese(wdCongruence, moduli[i]));
    if (include1mod2 == 1, wdCongruence = chinese(wdCongruence, Mod(1, 2)));

    return (lift(wdCongruence)+wdCongruence.mod*covering_info[1]);
}

\\Wrapper function for digitally delicate multithreading
is_delicate_w_mt(seed) = {
   if (seed%printIncrement == 0, print(concat("*",seed)));\
   my(n = construct_widely_candidate(seed));\
   if (n < maxNum,\
   if (ispseudoprime(n),\
   if (is_delicate_w_fast(n, wdBase)==1,\
       print(construct_covering(seed));
       return(n);
   );););\
   return(0);\
}


\\Wrapper function for digitally unstable multithreading
is_unstable_mt(seed) = {
   if (seed%printIncrement == 0, print(concat("*",seed)));\
   my(n = construct_widely_candidate(seed));\
   if (n < maxNum,\
   if (ispseudoprime(n),\
   if (is_unstable_fast(n, wdBase)==1,\
       return(n);
   );););\
   return(0);\
}


\\Wrapper function for digitally immutable multithreading
is_immutable_w_mt(seed) = {
   if (seed%printIncrement == 0, print(concat("*",seed)));\
   my(n = construct_widely_candidate(seed));\
   if (n < maxNum,\
   if (ispseudoprime(n),\
   if (is_immutable_w_fast(n, wdBase)==1,\
       return(n);
   );););\
   return(0);\
}

\\Searching function
search_mt(n) = {
    if (!ispseudoprime(n),return(0));
    my(result = 1);
    if (is_delicate_w_fast(n,wdBase)==1,result = result+2);
    if (is_unstable_fast(n,wdBase)==1,result = result+4);
    return(result);
}

\\Create a list of moduli that need to be satisfied
moduli = List([])
for (i = 1, wdBase-1,\
    for(j = 1, length(covering[i]),\
        listput(moduli, Mod((-1 * i * wdBase ^ lift(covering[i][j][1])) % covering[i][j][2], covering[i][j][2]));\
    );\
);

\\Convert to a single congruence
wdCongruence = moduli[1];
for (i = 2, length(moduli), wdCongruence = chinese(wdCongruence, moduli[i]));
if (include1mod2 == 1, wdCongruence = chinese(wdCongruence, Mod(1, 2)));
if (mode < 3, print(wdCongruence));

\\Search for WDD primes
if (mode == 0,\
wdFound = 0;\
n = lift(wdCongruence);\
inc = wdCongruence.mod;\
while (wdFound == 0,\
    if (ceil(n/inc)%printIncrement == 0, print(concat("*",ceil(n/inc))));\
    if (ispseudoprime(n),\
       result = is_delicate_w(n, wdBase);\
       if (result==1,\
           print(n);\
           print(concat("*",ceil(n/inc)));\
           quit;\
       );\
       if (showProgress && result<progressThreshold,\
           print(result);\
           progressThreshold = result;\
       );\
    );\
    n = n+inc;\
););\


\\Search for WDU primes
if (mode == 1,\
wdFound = 0;\
n = lift(wdCongruence);\
inc = wdCongruence.mod;\
while (wdFound == 0,\
    if (ceil(n/inc)%printIncrement == 0, print(concat("*",ceil(n/inc))));\
    if (ispseudoprime(n),\
       result = is_unstable(n, wdBase);\
       if (result==1,\
           print(n);\
           print(concat("*",ceil(n/inc)));\
           quit;\
       );\
       if (showProgress && result<progressThreshold,\
           print(result);\
           progressThreshold = result;\
       );\
    );\
    n = n+inc;\
););\


\\Search for WDI primes
if (mode == 2,\
wdFound = 0;\
n = lift(wdCongruence);\
inc = wdCongruence.mod;\
while (wdFound == 0,\
    if (ceil(n/inc)%printIncrement == 0, print(concat("*",ceil(n/inc))));\
    if (ispseudoprime(n),\
       result = is_immutable_w(n, wdBase);\
       if (result==1,\
           print(n);\
           print(concat("*",ceil(n/inc)));\
           quit;\
       );\
       if (showProgress && result<progressThreshold,\
           print(result);\
           progressThreshold = result;\
       );\
    );\
    n = n+inc;\
););\

exportall()

\\Optimize WDD primes
if (mode == 3,\
forstep (startThreadSeed = startSeed, maxSeed, seedsPerThread,\
parfor (seed = startThreadSeed, startThreadSeed + seedsPerThread - 1, is_delicate_w_mt(seed), result,\
    if (result!=0,\
        print(result);\
        print(concat("*",seed));\
        if (result < maxNum, maxNum = result);\
        if (stopOnOutput==1, quit);\
    );\
);\
export(maxNum);\
);\
);\

\\Optimize WDU primes
if (mode == 4,\
forstep (startThreadSeed = startSeed, maxSeed, seedsPerThread,\
parfor (seed = startThreadSeed, startThreadSeed + seedsPerThread - 1, is_unstable_mt(seed), result,\
    if (result!=0,\
        print(result);\
        print(concat("*",seed));\
        if (result < maxNum, maxNum = result);\
        if (stopOnOutput==1, quit);\
    );\
);\
export(maxNum);\
);\
);\


\\Optimize WDI primes
if (mode == 5,\
forstep (startThreadSeed = startSeed, maxSeed, seedsPerThread,\
parfor (seed = startThreadSeed, startThreadSeed + seedsPerThread - 1, is_immutable_w_mt(seed), result,\
    if (result!=0,\
        print(result);\
        print(concat("*",seed));\
        if (result < maxNum, maxNum = result);\
        if (stopOnOutput==1, quit);\
    );\
);\
export(maxNum);\
);\
);\

\\Search a range for all types of primes
if (mode == -1,\
n = lift(wdCongruence);\
inc = wdCongruence.mod;\
numPrimes = 0;\
numWDD = 0;\
numWDU = 0;\
numWDI = 0;\
export(n);\
export(inc);\
forstep (startThreadSeed = startSeed, maxSeed, seedsPerThread,\
parfor (seed = startThreadSeed, min(maxSeed,startThreadSeed + seedsPerThread - 1), search_mt(n+inc*seed), result,\
    if (result>0,\
    if(result>=printScore,print(concat(concat(concat(n+inc*seed," ("),result),")")));\
    numPrimes+=1;\
    if (result%4==3,numWDD+=1);\
    if (result>4,numWDU+=1);\
    if (result==7,numWDI+=1);\
    if(result>=printScore,print(concat("*",seed));\
    if (result>=writeScore,write("results.txt",concat(concat(concat(n+inc*seed," ("),result),")")));\
    );\
);\
););\
print(concat("Primes: ",numPrimes));\
print(concat("WDD:    ",numWDD));\
print(concat("WDU:    ",numWDU));\
print(concat("WDI:    ",numWDI));\
);\
quit;