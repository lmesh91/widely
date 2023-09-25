\\ Global vars
wdBase = 2
filename = concat(concat("Coverings\\base",wdBase),".txt")
printIncrement = 100

\\Modes:
\\0 - Search for WDDelicate
\\1 - Search for WDUnstable
\\2 - Search for WDImmutable
\\3 - Optimize WDDelicate (Not implemented)
\\4 - Optimize WDUnstable (Not implemented)
\\5 - Optimize WDImmutable (Not implemented)
\\-1 - Search a range
mode = 2


\\ Check if a prime is digitally delicate
is_delicate(n, base) = {
    \\ Get the digits of n in the base
    v = digits(n, base);
    \\ Loop through each position and digit
    for (k=1, #v, w = v;
        for (j=0, base-1,
            if (j != v[k], w[k] = j;
                \\ Plugs the digits back into the base 
                ntest = subst(Pol(w), x, base);
                if (ispseudoprime(ntest), return(0)); 
            ); 
        ); 
    ); 
    return (1);
}

\\ Check if a prime is digitally delicate (only lower digits, as the rest would be covered)
is_delicate_w(n, base) = {
    \\ Get the digits of n in the base
    v = digits(n, base);
    \\ Loop through each position and digit
    for (k=1, #v, w = v;
        for (j=0, base-1,
            if (j < v[k], w[k] = j;
                \\ Plugs the digits back into the base 
                ntest = subst(Pol(w), x, base);
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
    \\ Loop through each position and digit
    for (k=1, 1+#v, w = v;
        for (j=0, base-1,
            \\ Why all this weird syntactical jargon? Because for some reason I have to convert between a list and a vector here...
            if (j+k!=1, l=List(w); listinsert(~l,j,k);
                \\ Plugs the digits back into the base 
                ntest = subst(Pol(Vec(l)), x, base);
                if (ispseudoprime(ntest), return(0)); 
            ); 
        ); 
    ); 
    return (1);
}

\\Check if a prime is digitally immutable
is_immutable(n, base) = {
    if(is_unstable(n, base) && is_delicate(n, base), return(1););
    return(0);
}

\\Check if a prime is digitally immutable (only lower digits for delicates)
is_immutable_w(n, base) = {
    if(is_unstable(n, base) && is_delicate_w(n, base), return(1););
    return(0);
}

print("Starting program...");

\\Read covering file
coveringFile = fileopen(filename);
covering = List([])
while (l = filereadstr(coveringFile),\
    v = Vec(l);\
    if (v[1] == "<",\
        listput(covering, List([]));\
        listIdx = eval(v[2]);\
        congruence = strsplit(filereadstr(coveringFile), " ");\
        while (length(congruence) == 3,\
            listput(covering[listIdx], [Mod(eval(congruence[1]),eval(congruence[2])),eval(congruence[3])]);\
            res = filereadstr(coveringFile);\
            if (res != 0, congruence = strsplit(res, " "), congruence = []);\
        ),\
    )\
);

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
print(wdCongruence);

\\Search for WDD primes
if (mode == 0,\
wdFound = 0;\
n = lift(wdCongruence);\
inc = wdCongruence.mod;\
while (wdFound == 0,\
    if (ceil(n/inc)%printIncrement == 0, print(concat("*",ceil(n/inc))));\
    if (ispseudoprime(n),\
        if (is_delicate_w(n, wdBase),\
            print(n);\
            print(concat("*",ceil(n/inc)));\
            quit;\
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
        if (is_unstable(n, wdBase),\
            print(n);\
            print(concat("*",ceil(n/inc)));\
            quit;\
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
        if (is_immutable_w(n, wdBase),\
            print(n);\
            print(concat("*",ceil(n/inc)));\
            quit;\
        );\
    );\
    n = n+inc;\
););\

\\forprime(p = 2, 10000000, if(is_immutable(p,6),print(p);quit;));