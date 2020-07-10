% 3. domácí úloha
%
% Vyberte si jednu úlohu a vyřešte ji. Pokud odevzdáte obě, druhá se počítá
% jako bonus.
%
% a) Misionáři a lidojedi (prohledávání stavového prostoru)
%
% Na jednom břehu řeky stojí tři misionáři a tři kanibalové, k dispozici mají
% loďku pro dvě osoby. Přepravte je na druhý břeh tak aby:
%   1. v loďce vždy byla alespoň jedna osoba (tj. není možné poslat prázdnou
%      loďku na druhý břeh)
%   2. lidojedi nesnědli misionáře (což se stane, pokud je na jednom břehu
%      alespoň jeden misionář a ostře více lidojedů než misionářů)
%
% Navrhěte řešení zobecněného problému pro M misionářů, L lidojedů a R řek.
% Každá řeka má jednu loďku. Loďku nelze mezi řekami přenášet. Pro jednoduchost
% můžete předpokládat, že současně lze použít nejvýše jedna loďka.
%
% solve(+M, +L, +R, ?Path).
%
% M, L, R jsou vstupní čísla. Path je nalezená cesta (seznam stavů od
% počátečního ke koncovému).

solve(M, L, R, Path) :-
    M >= 0, L >= 0, R >= 1,
    R2 is R + 1,
    getStartingList(M, R2, Men),
    getStartingList(L, R2, Eaters),
    getStartingListBoats(R, Boats),
    step(Men, Eaters, Boats, [(Men, Eaters, Boats)], Path2),
    reverse(Path2, Path).


step([M|MS], [E|ES], _, Akum, Akum) :-
    getAmount([M|MS], 0, MenAmount),
    getAmount([E|ES], 0, EatersAmount),
    allTransported([M|MS], [E|ES], MenAmount, EatersAmount), !.
step([M|MS], [E|ES], [B|BS], Akum, R) :-
    (transport2([M|MS], [E|ES], [B|BS], RMen, REaters, RBoatPos);
        transport1([M|MS], [E|ES], [B|BS], RMen, REaters, RBoatPos)),
    isValid(RMen, REaters),
    notMember((RMen, REaters, RBoatPos), Akum),
    RAkum = [(RMen, REaters, RBoatPos)|Akum],
    step(RMen, REaters, RBoatPos, RAkum, R), !.

%transport1([M], [E], [B], [M], [E], [B]).
transport1([M,MS|MSS], [E,ES|ESS], [left|BS], [M,MS|MSS], REaters, RBoats) :-
    E >= 1,
    E2 is E - 1, E3 is ES + 1,
    REaters = [E2,E3|ESS], RBoats = [right|BS].
transport1([M,MS|MSS], [E,ES|ESS], [left|BS], RMen, [E,ES|ESS], RBoats) :-
    M >= 1,
    M2 is M - 1, M3 is MS + 1,
    RMen = [M2,M3|MSS], RBoats = [right|BS].
transport1([M,MS|MSS], [E,ES|ESS], [right|BS], [M,MS|MSS], REaters, RBoats) :-
    ES >= 1,
    E2 is E + 1, E3 is ES - 1,
    REaters = [E2,E3|ESS], RBoats = [left|BS].
transport1([M,MS|MSS], [E,ES|ESS], [right|BS],  RMen, [E,ES|ESS], RBoats) :-
    MS >= 1,
    M2 is M + 1, M3 is MS - 1,
    RMen = [M2,M3|MSS], RBoats = [left|BS].
transport1([M,MS|MSS], [E,ES|ESS], [B|BS], [M|RMen], [E|REaters], [B|RBoats]) :-
    transport1([MS|MSS], [ES|ESS], BS, RMen, REaters, RBoats).

transport2([M,MS|MSS], [E,ES|ESS], [left|BS], RMen, REaters, RBoats) :-
    E >= 1, M >= 1,
    E2 is E - 1, E3 is ES + 1, REaters = [E2,E3|ESS],
    M2 is M - 1, M3 is MS + 1, RMen = [M2,M3|MSS],
    RBoats = [right|BS].
transport2([M,MS|MSS], [E,ES|ESS], [right|BS], RMen, REaters, RBoats) :-
    ES >= 1, MS >= 1,
    E2 is E + 1, E3 is ES - 1, REaters = [E2,E3|ESS],
    M2 is M + 1, M3 is MS - 1, RMen = [M2,M3|MSS],
    RBoats = [left|BS].
transport2([M,MS|MSS], [E,ES|ESS], [left|BS], RMen, [E,ES|ESS], RBoats) :-
    M >= 2,
    M2 is M - 2, M3 is MS + 2,
    RMen = [M2,M3|MSS], RBoats = [right|BS].
transport2([M,MS|MSS], [E,ES|ESS], [left|BS], [M,MS|MSS], REaters, RBoats) :-
    E >= 2,
    E2 is E - 2, E3 is ES + 2,
    REaters = [E2,E3|ESS], RBoats = [right|BS].
transport2([M,MS|MSS], [E,ES|ESS], [right|BS], RMen, [E,ES|ESS], RBoats) :-
    MS >= 2,
    M2 is M + 2, M3 is MS - 2,
    RMen = [M2,M3|MSS], RBoats = [left|BS].
transport2([M,MS|MSS], [E,ES|ESS], [right|BS], [M,MS|MSS], REaters, RBoats) :-
    ES >= 2,
    E2 is E + 2, E3 is ES - 2,
    REaters = [E2,E3|ESS], RBoats = [left|BS].
transport2([M,MS|MSS], [E,ES|ESS], [B|BS], [M|RMen], [E|REaters], [B|RBoats]) :-
    transport2([MS|MSS], [ES|ESS], BS, RMen, REaters, RBoats).

isValid([0], [_]).
isValid([M], [E]) :- M > 0, E =< M, !.
isValid([0|MS], [_|ES]) :-
    isValid(MS, ES).
isValid([M|MS], [E|ES]) :-
    M > 0, E =< M,
    isValid(MS, ES).

notMember(_, []) :- !.
notMember(Item, [X|XS]) :-
    Item \= X,
    notMember(Item, XS).

allTransported([M], [E], MenAmount, EatersAmount) :-
    M =:= MenAmount, E =:= EatersAmount, !.
allTransported([M|MS], [E|ES], MenAmount, EatersAmount) :-
    M =:= 0, E =:= 0, !,
    allTransported(MS, ES, MenAmount, EatersAmount).

getAmount([], Akum, Akum) :- !.
getAmount([M|MS], Akum, RAmount) :-
    Akum2 is Akum + M,
    getAmount(MS, Akum2, RAmount).

getStartingList(0, 0, []) :- !.
getStartingList(Amount, Length, R) :-
    Amount >= 0, Length > 0,
    Length2 is Length - 1,
    getStartingList(0, Length2, R2),
    R = [Amount| R2], !.

getStartingListBoats(0, []) :- !.
getStartingListBoats(Amount, Boats) :-
    Amount >= 1,
    Amount2 is Amount - 1,
    getStartingListBoats(Amount2, Boats2),
    Boats = [left|Boats2], !.

% Dejte si pozor na cykly ve stavovém grafu.
%
% b) Regulární výrazy
%
% Implementuje následující predikát:
%
% find(+Pattern, +Text, ?PosStart, ?PosEnd)
%
% Pattern je regulární výraz, viz níže
% Text je seznam atomů, např. [h,e,l,l,o]
% PosStart a PosEnd určují, kde se nachází výskyt nalezeného vzoru.
%
% Regulární výraz je definován induktivně:
%   1. X je regulární výraz, pokud atom(X)
%   2. X je regulární výraz, pokud X je seznam atomů.
%   3. pokud jsou X, Y reg. výrazy, pak je také X .: Y
%   4. pokud jsou X, Y reg. výrazy, pak je také X .+ Y
%   5. pokud je X reg. výraz, pak je také X .*
%
% Sémantika:
%   1. x matchuje pouze znak x
%   2. [x,y,z] matchuje znaky x, y nebo z
%   3. X .: Y matchuje X a potom Y
%   4. X .+ Y matchuje X nebo Y
%   5. X .* matchuje X libovolně mnohokrát
%
% Př.
% find(([a,b] .: c) .*, [a,c,b,c], S, E).
% S = E, E = 0 ; % prádzný řetězec na pozici 0
% S = 0, E = 2 ; % řetězec ac na pozici 0
% S = 0, E = 4 ; % řetězec acbc na pozici 0
% S = E, E = 1 ; % prázdný řetězec na pozici 1
% S = E, E = 2 ; % prázdný řetězec na pozici 2
% S = 2, E = 4 ; % řetězec bc na pozici 2
% S = E, E = 3 ; % prázdný řetězec na pozici 3
% S = E, E = 4 ; % prázdný řetězec na pozici 4
% false.
%
% Dejte si pozor, abyste správně ošetřili vnořené výskyty .*:
% find(a .* .*, [a], S, E).
% S = E, E = 0 ;
% S = 0, E = 1 ;
% S = E, E = 1 ;
% false.

:- op(150, yf,  .*).
:- op(200, xfy, .:).
:- op(250, xfy, .+).