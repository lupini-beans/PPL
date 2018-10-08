% male and female
hermaphradite(ymir).
group(giants).

% all the men of Norse Mythology
man(farbauti).
man(aegir).
man(loki).
man(heimdal).
man(tyr).
man(mimir).
man(burr).
man(buri).
man(fjorgynn).
man(vili).
man(ve).
man(hoenir).
man(odin).
man(baldr).
man(hodr).
man(bragi).
man(forseti).
man(thor).
man(njord).
man(ullr).
man(modi).
man(magni).
man(freyr).
man(odr).

% all the woman of Norse Mythology
woman(laufey).
woman(ran).
woman(himinglaeva).
woman(dufa).
woman(blodughadda).
woman(hefring).
woman(udr).
woman(hronn).
woman(bylgja).
woman(drofn).
woman(kolga).
woman(angrboda).
woman(bestla).
woman(frigg).
woman(jord).
woman(nanna).
woman(idunn).
woman(sif).
woman(jarnsaxa).
woman(skadi).
woman(thrud).
woman(gerdr).
woman(freya).

% all the animals...
% it's Norse Mythology, there's definitely some weird stuff
animal(horse).
animal(wolf).
animal(snake).
animal(many_legged_horse).
animal(cow).


% the names of the above animals
woman(svadilfari).    % horse
man(fenrir).          % wolf
man(jormungand).      % snake
man(sleipnir).        % many_legged_horse
woman(audumbla).      % cow

% animal and name relationships
is_a(svadilfari, horse).
is_a(fenrir, wolf).
is_a(jormungand, snake).
is_a(sleipnir, many_legged_horse).
is_a(audumbla, cow).

% all of the parent facts
parent(ymir, giants).
parent(giants, farbauti).
parent(giants, aegir).
parent(giants, ran).
parent(giants, angrboda).
parent(farbauti, loki).
parent(laufey, loki).
parent(aegir, himinglaeva).
parent(aegir, dufa).
parent(aegir, blodughadda).
parent(aegir, hefring).
parent(aegir, udr).
parent(aegir, hronn).
parent(aegir, bylgja).
parent(aegir, drofn).
parent(aegir, kolga).
parent(ran, himinglaeva).
parent(ran, dufa).
parent(ran, blodughadda).
parent(ran, hefring).
parent(ran, udr).
parent(ran, hronn).
parent(ran, bylgja).
parent(ran, drofn).
parent(ran, kolga).
parent(himinglaeva, heimdal).
parent(dufa, heimdal).
parent(blodughadda, heimdal).
parent(hefring, heimdal).
parent(udr, heimdal).
parent(hronn, heimdal).
parent(bylgja, heimdal).
parent(drofn, heimdal).
parent(kolga, heimdal).
parent(loki, fenrir).
parent(loki, jormungand).
parent(loki, hel).
parent(loki, sleipnir).
parent(angrboda, fenrir).
parent(angrboda, jormungand).
parent(angrboda, hel).
parent(svadilfari, sleipnir).
parent(audumbla, buri).
parent(buri, burr).
parent(burr, vili).
parent(burr, ve).
parent(burr, hoenir).
parent(burr, odin).
parent(bestla, vili).
parent(bestla, ve).
parent(bestla, hoenir).
parent(bestla, odin).
parent(fjorgynn, frigg).
parent(frigg, hodr).
parent(frigg, baldr).
parent(odin, baldr).
parent(odin, hodr).
parent(frigg, bragi).
parent(odin, bragi).
parent(odin, ullr).
parent(sif, ullr).
parent(nanna, forseti).
parent(baldr, forseti).
parent(odin, thor).
parent(jord, thor).
parent(sif, modi).
parent(sif, thrud).
parent(thor, modi).
parent(thor, thrud).
parent(jarnsaxa, magni).
parent(thor, magni).
parent(skadi, freyr).
parent(skadi, freya).
parent(njord, freyr).
parent(njord, freya).

% marriage facts
married(farbauti, laufey).
married(aegir, ran).
married(burr, bestla).
married(odin, frigg).
married(baldr, nanna).
married(thor, sif).
married(njord, skadi).
married(freyr, gredr).
married(odr, freya).

% father rule
father(F,C):-
  man(F),parent(F,C)
  ; hermaphradite(F), parent(F,C)
  ; group(F), parent(F,C).

% mother rule
mother(M,C):-
  woman(M),parent(M,C)
  ; hermaphradite(M), parent(M,C)
  ; group(M), parent(M,C).


% full siblings rule
sibling(X,S):-
  setof((X,S), P^(father(M,X), father(M,S), mother(F,X), mother(F,S), \+X=S), Sibs),
  member((X,S), Sibs),
  \+ (S@<X, member((S,X), Sibs)).

% half sibling rule
halfsib(X,H):-
  setof((X,H), P^((
  (father(M,X), father(M,H),   % same father
  (mother(F,X), not(mother(F,H))))
  ;       % same mother
  (mother(F,X), mother(F,H),
  (father(M,X), not(father(M,H))))),
  \+X=H), HalfSibs),
  member((X,H), HalfSibs),
  \+ (H@<X, member((H,X), HalfSibs)).

% sister rule
sister(X,S):-
  setof((X,S), P^(woman(S), sibling(X,S), \+X=S), Sisters),
  member((X,S), Sisters),
  \+ (S@<X, member((S,X), Sisters)).

% half-sister rule
halfsis(X,S):-
  setof((X,S), P^(woman(S), halfsib(X,S), \+X=S), HalfSis),
  member((X,S), HalfSis),
  \+ (S@<X, member((S,X), HalfSis)).

% brother rule
brother(X,B):-
  setof((X,B), P^(man(B), sibling(X,B), \+X=B), Brothers),
  member((X,B), Brothers),
  \+ (B@<X, member((B,X), Brothers)).

% half-brother rule
halfbro(X,B):-
  setof((X,B), P^(man(B), halfsib(X,B), \+X=B), HalfBro),
  member((X,B), HalfBro),
  \+ (B@<X, member((B,X), HalfBro)).

% sister in-law rule
sisterinlaw(X,S):-
  (woman(S), married(H,S), sibling(X,H), not(sibling(X,S)), X\=S),
  (woman(S), married(X,W), sibling(W,S), not(sibling(X,S)), X\=S).

% brother in-law rule
brotherinlaw(X,B):-
  (man(B), married(B,W), sibling(X,W), not(sibling(X,B)), X\=B);
  (man(B), married(H,X), sibling(H,B), not(sibling(X,B)), X\=B).

% Uncle rule
uncle(U, N):-
  setof((U,N), P^(parent(P,N), brother(U,P), not(parent(U,N))), Uncles),
  member((U,N), Uncles),
  \+ (N@<U, member((N,U), Uncles)).

% Aunt rule -
aunt(A, N):-
  setof((A,N), P^((parent(P,N), sister(P,A), not(parent(A,N)));
  (parent(P,N), sisterinlaw(P,A), not(parent(A,N)))), Aunts),
  member((A,N), Aunts),
  \+ (N@<A, member((N,A), Aunts)).

% Grandfather rule
grandfather(G, C):-
  (father(F,C), father(G,F), mother(M,C), M\=F, not(father(G,M)));
  (mother(M,C), father(G,M), father(F,C), M\=F, not(father(G,F)));
  (father(F,C), father(G,F), mother(M,C), M\=F, father(G,M)).

% Grandmother rule
grandmother(G, C):-
  (mother(M,C), mother(G,M), father(F,C), F\=M, not(mother(G,F)));
  (father(F,C), mother(G,F), mother(M,C), F\=M, not(mother(G,M)));
  (mother(M,C), mother(G,M), father(F,C), F\=M, mother(G,F)).
