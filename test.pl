test([X|Y]).


find(A,B,I,C,D, [A,B,I,C,D|XS], R) :- 
    A2 is A-1, 
    B2 is B-1,
    I2 = r,
    C2 is C+1,
    D2 is D+1,
    R = [A2, B2, I2, C2, D2|XS].
find(A,B,I,C,D, [X|XS], R) :-
    find(A,B,I,C,D, XS,R2),
    R = [X|R2].

change(0, [X|XS],R) :- 
    X2 is X+1, 
    R = [X2|XS], !.
change(N, [X|XS], R) :-
    N > 0,
    N2 is N-1, 
    change(N2, XS, R2),
    R = [X|R2].

maxint(R, R).
maxint(A, R) :- 
    A2 is A + 1,
    maxint(A2, R).