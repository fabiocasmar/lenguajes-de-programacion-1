% CONFERENCIA AMERICANA (afc).
% Equipos de la División Este.
standings(afc,east,1,patriots).
standings(afc,east,2,jets).
standings(afc,east,3,bills).
standings(afc,east,4,dolphins).

% Equipos de la División Norte.
standings(afc,north,1,bengals).
standings(afc,north,2,steelers).
standings(afc,north,3,ravens).
standings(afc,north,4,browns).

% Equipos de la División Sur.
standings(afc,south,1,texans).
standings(afc,south,2,colts).
standings(afc,south,3,jaguars).
standings(afc,south,4,titans).

% Equipos de la División Oeste.
standings(afc,west,1,broncos).
standings(afc,west,2,chiefs).
standings(afc,west,3,raiders).
standings(afc,west,4,chargers).

% CONFERENCIA NACIONAL (nfc).
% Equipos de la División Este.
standings(nfc,east,1,redskins).
standings(nfc,east,2,eagles).
standings(nfc,east,3,giants).
standings(nfc,east,4,cowboys).

% Equipos de la División Norte.
standings(nfc,north,1,vikings).
standings(nfc,north,2,packers).
standings(nfc,north,3,lions).
standings(nfc,north,4,bears).

% Equipos de la División Sur.
standings(nfc,south,1,panthers).
standings(nfc,south,2,falcons).
standings(nfc,south,3,saints).
standings(nfc,south,4,buccaneers).

% Equipos de la División Oeste.
standings(nfc,west,1,cardinals).
standings(nfc,west,2,seahawks).
standings(nfc,west,3,rams).
standings(nfc,west,4,fortynineers).

% Divisiones establecidas para los juegos intra-conferencia.
intra(north,east).
intra(south,west).

% Divisiones establecidas para los juegos inter-conferencia.
% El primer argumento indica la división en la AFC y el segundo argumento indica 
% la división en la NFC
inter(east,west).
inter(north,east).
inter(south,north).
inter(west,south).

% Genera una lista de 2 elementos que representan los partidos divisionales.
divisionales(Partido) :- Partido = [T1, T2], standings(C,D,_,T1), 
						 standings(C,D,_,T2), T1 \= T2.

% Genera las combinaciones de equipos para los partidos divisionales.
divisionales1(T1,T2) :- standings(C,D,_,T1), standings(C,D,_,T2), T1 \= T2.
%divisionales1(T1,T2) :- standings(C,D,_,T2), standings(C,D,_,T1), T1 \= T2.

% Genera una lista de 2 elementos que representan los partidos intra-conferencia.
intra-conf(Partido):- Partido=[T1,T2], intra(D1,D2), standings(C,D1,_,T1), 
					  standings(C,D2,_,T2), T1 \= T2.

% Genera las combinaciones de equipo para los partidos intra-conferencia.
intra-conf1(T1,T2):- intra(D1,D2), standings(C,D1,_,T1), standings(C,D2,_,T2), T1 \= T2.
intra-conf1(T1,T2):- intra(D1,D2), standings(C,D1,_,T2), standings(C,D2,_,T1), T1 \= T2.

% Genera una lista de 2 elementos que representan los partidos inter-conferencia.
inter-conf(Partido):- Partido = [T1,T2], inter(D1,D2), standings(afc,D1,_,T1), 
					  standings(nfc,D2,_,T2).

% Genera las combinaciones de equipo para los partidos inter-conferencia.
inter-conf1(T1,T2):- inter(D1,D2), standings(afc,D1,_,T1), standings(nfc,D2,_,T2).
inter-conf1(T1,T2):- inter(D1,D2), standings(afc,D1,_,T2), standings(nfc,D2,_,T1).

pos(Partido) :- Partido = [T1,T2], intra(north,D5), standings(C,north,P,T1), 
				standings(C,D2,P,T2), T1\= T2, D2 \= D5.
pos(Partido) :- Partido = [T1,T2], intra(D5,east), standings(C,east,P,T1), 
				standings(C,D2,P,T2), T1\= T2, D2 \= D5.

% Genera las combinaciones de equipo para los partidos segun la posición
pos1(T1,T2) :- intra(D1,D5), standings(C,D1,P,T1), standings(C,D2,P,T2), T1\= T2, D2 \= D5.
pos1(T1,T2) :- intra(D5,D1), standings(C,D1,P,T1), standings(C,D2,P,T2), T1\= T2, D2 \= D5.

% Genera listas de 2 elementos que representan todos los partidos.
partidos(Partido) :- divisionales(Partido).
partidos(Partido) :- intra-conf(Partido).
partidos(Partido) :- inter-conf(Partido).
partidos(Partido) :- pos(Partido).

% Genera la lista de todos lode partidos.
agr(Partido) :- findall(X,partidos(X),Partido).

% Genera los partidos para un equipo determinado.
partidos1(T1,T2) :- divisionales1(T1,T2). 
partidos1(T1,T2) :- divisionales1(T1,T2).
partidos1(T1,T2) :- intra-conf1(T1,T2).
partidos1(T1,T2) :- inter-conf1(T1,T2).
partidos1(T1,T2) :- pos1(T1,T2).

% Dato un equipo, genera la lista de todos los contrincancantes.
agregar(T1,X) :- findall(T2, partidos1(T1,T2),X).

bye(Lista) :- Lista = [A,B,C,D,E,F,G,H],
			A = [_,_,_,_],
			B = [_,_,_,_],
			C = [_,_,_,_],
			D = [_,_,_,_],
			E = [_,_,_,_],
			F = [_,_,_,_],
			G = [_,_,_,_],
			H = [_,_,_,_],
			%member(X,Lista),
			member(patriots,A),
			member(jets,B),
			member(bills,C),
			member(dolphins,D),
			member(bengals,E),
			member(steelers,F),
			member(ravens,G),
			member(browns,H),
			member(texans,A),
			member(colts,B),
			member(jaguars,C),
			member(titans,D),
			member(broncos,E),
			member(chiefs,F),
			member(raiders,G),
			member(chargers,H),
			member(redskins,A),
			member(eagles,B),
			member(giants,C),
			member(cowboys,D),
			member(vikings,E),
			member(packers,F),
			member(lions,G),
			member(bears,H),
			member(panthers,A),
			member(falcons,B),
			member(saints,C),
			member(buccaneers,D),
			member(cardinals,E),
			member(seahawks,F),
			member(rams,G),
			member(fortynineers,H),
			true.

% Seleciona N elementos de una lista L y los coloca en un conjunto S.
selectN(0,_,[]) :- !.
selectN(N,L,[X|S]) :- N > 0, el(X,L,R), N1 is N-1, selectN(N1,R,S).

el(X,[X|L],L).
el(X,[_|L],R) :- el(X,L,R).

% Elimina de un conjuntos, los elementos en una lista.
subtract([], _, []).
subtract([Head|Tail], L2, L3) :- memberchk(Head, L2),!,subtract(Tail, L2, L3).
subtract([Head|Tail1], L2, [Head|Tail3]) :- subtract(Tail1, L2, Tail3).

% Distribuye los elementos de una lista en subconjuntos.
group([],[],[]).
group(G,[N1|Ns],[G1|Gs]) :- selectN(N1,G,G1), subtract(G,G1,R), group(R,Ns,Gs).

%schedule :- calendario(Cal),
%	Numero is 1,
%	member(Semana,Cal),
%	write('Week '), write(Numero),
%	write('------'),
%	imprimir(Semana),nl,

imprimir([[E1,E2]|Juegos]) :- write(E1), write(' at '), write(E2), nl, imprimir(Juegos).
