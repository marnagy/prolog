% 2. cvičení, 2017-02-27

% Kromě jednoduchých atomů (konstant) můžeme v Prologu také vytvářet složené
% termy.

% Operace na dvojicích.
first(pair(X, Y), X).
second(pair(X, Y), Y).

% first(pair(pair(1, 2), 3), R).
% R = pair(1,2).

% first(pair(pair(1, 2), 3), X), first(X,Y).

% Unárně reprezentovaná čísla.

% nat(X)
% X je přirozené číslo
nat(0).
nat(s(X)) :- nat(X). % naslednik je taky prirozene cislo

% Jak Prolog vyhodnocuje dotazy? Unifikace a backtracking!
%
% Když se Prolog snaží splnit nějaký dotaz a má na výběr více možností
% (predikát definovaný pomocí více než jedné klauzule), zkusí postupně
% ty klauzule, jejichž hlava pasuje na dotaz.
%
% Hlava klauzule pasuje na dotaz, pokud je lze unifikovat, tj. najít hodnoty
% proměnných tž. po dosazení jsou hlava a dotaz stejné. Prolog vždy hledá
% neobecnější unifikaci, která neobsahuje žádné zbytečné vazby.
%
% X = X. % explicitni unifikace
% p(X) = Y.
% f(X, Y) = g(X). % false.
% f(X, b) = f(a, Y). % X = a, Y = b.

vertical(line(point(X, Y), point(X, Z))).
% vertical(line(point(0, 3), X)).
horizontal(line(point(X, Y), point(Z, Y))).

% V těle klauzule se také může objevit predikát, který právě definujeme.
% Jsou tedy možné rekurzivní definice.
%
% Klauzule se zkoušejí v pořadí, v jakém jsou zapsané v programu. Stejně tak
% se vyhodnocuje tělo klauzule.
%
% Pokud nějaký poddotaz skončí neúspěchem, Prolog se vrátí na poslední místo,
% kde existuje nějaká volba a zkusí jinou možnost.

% Méně nebo rovno
leq(0, Y) :- nat(Y).
leq(s(X), s(Y)) :- leq(X, Y).
% leq(s(s(0)), s(s(s(0)))).
% leq(s(s(s(0))), s(s(0))).

% Alternativní definice
leq2(X, X) :- nat(X).
leq2(X, s(Y)) :- leq2(X, Y).
% leq(X, s(s(0))). vs leq2(X, s(s(0))).

% Méně než.
lt(0, s(Y)) :- nat(Y).
lt(s(X), s(Y)) :- lt(X, Y).

% Sčítání.
add(0, Y, Y) :- nat(Y).
add(s(X), Y, s(Z)) :-
  add(X, Y, Z).
% add(X,Y,result)

% Násobení.
mult(0, Y, 0) :- nat(Y).
mult(s(X), Y, R) :-
  mult(X, Y, R2),
  add(R2, Y, R).

% Půlení.
half(0, 0).
half(s(0), 0).
half(s(s(X)), s(R)) :- half(X, R).

% Odčítání pomocí predikátu add/3.
% Takovéto predikáty označujeme jako invertibilní.
% Jestli takhle predikát lze použít záleží na definici. Navíc tento směr nemusí
% být vždy stejně efektivní - vhodné použít dvě specializované definice.
subtract(X, Y, R) :- add(Y, R, X).

% Použití sčítání na rozklad čísla.
weird(X, R) :-
  add(A, B, X),
  mult(A, B, R).

% Odbočka: deklarativní vs procedurální správnost programu
%
% Deklarativní správnost: správná odpověď existuje, program ji nemusí najít   % matematicka
% Procedurální správnost: program navíc správnou odpověď najde
%
% Proč? Pokud se na klauzule díváme jako na logické formule, na pořadí
% nezáleží. Prolog to ale pak v nějakém pořadí musí vyhodnotit a pokud
% vybereme špatné pořadí, nemusíme výsledek najít.
%
% Pozn. deklarativní správnost = částečná správnost
% (pokud najde výsledek, je správně)
%       procedurální správnost = úplná správnost
% (najde správný výsledek)

edge(a,b).
edge(b,c).

path(X, X).
path(X, Y) :- edge(X, Z), path(Z, Y).

path2(X, X).
path2(X, Y) :- path2(X, Z), edge(Z, Y).
% Najde výsledek, pak se zacyklí.

path3(X, Y) :- path3(X, Z), edge(Z, Y).
path3(X, X).
% Zacyklí se.

% Všechny 3 programy jsou ekvivalentní deklarativně, ale pouze path/2 je
% procedurálně správně.

% ukol: div(X,Y,Q,R)  Q nasobek, R zbytek

div(0, Y, 0, 0).
div(s(X),Y,Q,R) :- div(X,Y,Q,B), Y \= s(B), add(B, s(0), R).
div(s(X),Y,Q,R) :- div(X,Y,A,B), add(A,s(0),Q), R = 0.

% div(s(X), X, Q, R) :- div(X,X,A,B), B = s(X), add(A,s(0),Q), R = 0. % zvysenie nasobku a nastavenie zvysku
% div(s(X), X, Q, R) :- div(X,X,Q,Z), add(Z,Q,R). % zvysenie zvysku o 1

% DU na githube v hw1.pl

%###########################################

% Seznamy jsou další rekurzivní strukturou. [] je prázdný seznam, [X|Y] je
% seznam, kde X je první prvek a Y je zbytek seznamu.
%
% Např. seznam čísel 1 až 4:
% [1|[2|[3|[4|[]]]]]
%
% Syntaktická zkratka:
same1 :- [1,2,3,4] = [1|[2|[3|[4|[]]]]].
same2 :- [1,2|R] = [1|[2|R]].

% f([A,B]) :- ...   % Unifikace uspěje pouze pro dvouprvkové seznamy
% f([A,B|R]) :- ... % Unifikace uspěje pro seznamy velikosti alespoň 2.

% Hledání prvku v seznamu. Porovnávání za nás řeší unifikace.
elem(X,[X|_]).
elem(X,[_|S]) :- elem(X, S).

% Přidávání prvku na začátek seznamu.
addFront(X, R, [X|R]).

% A na konec seznamu.
addBack(X, [], [X]).
addBack(X, [Y|Ys], [Y|R]) :- addBack(X, Ys, R).

% Pomocné predikáty.
toNat(N, R) :-
  integer(N),
  toNat_(N, R).

toNat_(N, R) :- N > 0 ->
  (N2 is N - 1, toNat_(N2, R2), R = s(R2));
  R = 0.

fromNat(0, 0).
fromNat(s(N), R) :-
  fromNat(N, R2),
  R is R2 + 1.

% DU part

% FIBONACCI
% exp. version
fibExp(0, s(0)).
fibExp(s(0),s(0)).
fibExp(s(s(X)), Y) :- fibExp(X, A), fibExp(s(X),B), add(A,B,Y).

% lin. version
fibLin(s(0), 0, s(0), s(0)).
fibLin(s(s(X)), s(X), A, B) :- fibLin(s(X),X, C, D), B = C, add(C, D, A).

% for easier usage
fib(0, s(0)).
fib(s(X),V) :- fibLin(s(X),X,V,_).


% LOG2
log2(s(0),0).
log2(s(s(X)),V) :- half(s(s(X)),Y), log2(Y,Z), add(s(0), Z, V).
