% setrid(+Xs,-Ys) :- Ys je seznam přirozených čísel ze seznamu Xs setříděný vzestupně
%% setrid(Xs,Ys) :- append(A,[H1,H2|B],Xs), H1 > H2, !, append(A,[H2,H1|B],Xs1), setrid(Xs1,Ys).

muz(peter).
muz(jan).
muz(marek).
zena(eva).

rodic(peter,jan).
rodic(peter,marek).
rodic(eva,jan).
rodic(eva,marek).
brat(jan, marek).

otec(X,Y) :- muz(X), rodic(X,Y).
mama(X,Y) :- zena(X), rodic(X,Y).

% merge sort
merge(X, [], X) :- !.
merge([], Y, Y) :- !.
merge([X|XS], [Y|YS], X|RS) :-
    X < Y,
    !,
    merge(XS, [Y|YS], RS).
merge([X|XS], [Y|YS], Y|RS) :-
    !,
    merge([X|XS], YS, RS).
