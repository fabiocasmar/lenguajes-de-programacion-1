%   Nombre del archivo:  nfl.pro
%   Realizado por:    Fabio    Castro     10-10132
%                     Patricia Reinoso    11-10851
%   Universidad Simón Bolívar
%   Proyecto: Programación Lógica - Lenguajes de Programación I
%   Versión: v0.5.0

% El problema es calcular y mostrar calendarios balanceados para la temporada
% regular 2016 de la NFL.

% CONFERENCIA AMERICANA (afc).
% Equipos de la División Este.
standings(afc,east,1,patriots).
standings(afc,east,2,jets).
%standings(afc,east,3,bills).
%standings(afc,east,4,dolphins).

% Equipos de la División Norte.
standings(afc,north,1,bengals).
standings(afc,north,2,steelers).
%standings(afc,north,3,ravens).
%standings(afc,north,4,browns).

% Equipos de la División Sur.
standings(afc,south,1,texans).
standings(afc,south,2,colts).
%standings(afc,south,3,jaguars).
%standings(afc,south,4,titans).

% Equipos de la División Oeste.
standings(afc,west,1,broncos).
standings(afc,west,2,chiefs).
%standings(afc,west,3,raiders).
%standings(afc,west,4,chargers).

% CONFERENCIA NACIONAL (nfc).
% Equipos de la División Este.
standings(nfc,east,1,redskins).
standings(nfc,east,2,eagles).
%standings(nfc,east,3,giants).
%standings(nfc,east,4,cowboys).

% Equipos de la División Norte.
standings(nfc,north,1,vikings).
standings(nfc,north,2,packers).
%standings(nfc,north,3,lions).
%standings(nfc,north,4,bears).

% Equipos de la División Sur.
standings(nfc,south,1,panthers).
standings(nfc,south,2,falcons).
%standings(nfc,south,3,saints).
%standings(nfc,south,4,buccaneers).

% Equipos de la División Oeste.
standings(nfc,west,1,cardinals).
standings(nfc,west,2,seahawks).
%standings(nfc,west,3,rams).
%standings(nfc,west,4,fortynineers).

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

% Predicado que genera una lista de 2 elementos que representan los partidos 
% divisionales.
divisionales(Partido) :- Partido = [T1, T2], standings(C,D,_,T1), 
						 standings(C,D,_,T2), T1 \= T2.

% Predicado que genera una lista de 2 elementos que representan los partidos 
% intra-conferencia.
intra-conf(Partido):- Partido=[T1,T2], intra(D1,D2), standings(C,D1,_,T1), 
					  standings(C,D2,_,T2), T1 \= T2.

% Predicado que genera una lista de 2 elementos que representan los partidos 
%inter-conferencia.
inter-conf(Partido):- Partido = [T1,T2], inter(D1,D2), standings(afc,D1,_,T1), 
					  standings(nfc,D2,_,T2).

% Predicado que genera una lista de 2 elementos que representan los partidos 
% contra equipos que quedaron en la posisión p de su misma conferencia.
position(Partido) :- Partido = [T1,T2], intra(north,D5), standings(C,north,P,T1), 
				standings(C,D2,P,T2), T1\= T2, D2 \= D5.
position(Partido) :- Partido = [T1,T2], intra(D5,east), standings(C,east,P,T1), 
				standings(C,D2,P,T2), T1\= T2, D2 \= D5.

% Predicado que genera listas de 2 elementos que representan todos los partidos.
%games(Partido) :- divisionales(Partido).
games(Partido) :- intra-conf(Partido).
games(Partido) :- inter-conf(Partido).
%games(Partido) :- position(Partido).

% Predicado que genera la lista de todos los partidos.
agr(Partido) :- findall(X,games(X),Partido).

% Predicado que seleciona N elementos de una lista L y los coloca en un conjunto S.
selectN(0,_,[]) :- !.
selectN(N,L,[X|S]) :- N > 0, el(X,L,R), N1 is N-1, selectN(N1,R,S).

el(X,[X|L],L).
el(X,[_|L],R) :- el(X,L,R).

% Predicado que elimina de un conjuntos, los elementos en una lista.
subtract([], _, []).
subtract([Head|Tail], L2, L3) :- memberchk(Head, L2),!,subtract(Tail, L2, L3).
subtract([Head|Tail1], L2, [Head|Tail3]) :- subtract(Tail1, L2, Tail3).

% Predicado que distribuye los elementos de una lista en subconjuntos.
group([],[],[]).
group(G,[N1|Ns],[G1|Gs]) :- selectN(N1,G,G1), subtract(G,G1,R), group(R,Ns,Gs).

% Predicado que seleciona N elementos de una lista L y los coloca en un conjunto S.
selectN2(0,_,[]) :- !.
selectN2(N,L,[X|S]) :- N > 0, el2(X,L,R), N1 is N-1, selectN2(N1,R,S), 
						\+common_team(S,X).

% Predicado que toma elementos de una lista y devuelte el resto.
el2(X,[X|L],L).
el2(X,[_|L],R) :- el2(X,L,R).

% Predicado que elimina de un conjuntos, los elementos en una lista.
subtract2([], _, []).
subtract2([Head|Tail], L2, L3) :- memberchk(Head, L2),!,subtract2(Tail, L2, L3).
subtract2([Head|Tail1], L2, [Head|Tail3]) :- subtract2(Tail1, L2, Tail3).

% Predicado que distribuye los elementos de una lista en subconjuntos.
group2([],[],[]).
group2(G,[N1|Ns],[G1|Gs]) :- selectN2(N1,G,G1), subtract2(G,G1,R), group2(R,Ns,Gs).

% Predicado que genera un Calendario con la lista de partidos por semana y una 
% lista Byes con los equipos que descansan por semana.
calendario(Cal,Bye) :- findall(X,games(X), Games),
				%Teams = [patriots,jets,bills,dolphins,bengals,steelers,ravens,
				%     browns,texans,colts,jaguars,titans,broncos,chiefs,raiders,
				%     chargers,redskins,eagles,giants,cowboys,vikings,packers,
				%     lions,bears,panthers,falcons,saints,buccaneers,cardinals,
				%     seahawks,rams,fortynineers],

				%Games = [[bears,patriots],[bengals,jets],[steelers,redskins],[panthers,jets],
				%		[vikings,redskins],[lions,eagles],[packers,fortynineers],[colts,bears],
				%		[texans,broncos],[browns,chiefs],[colts,redskins],[vikings,saints],
				%		[panthers,cardinals],[texans,seahawks],[bills,buccaneers],[jets,lions]],
				Teams = [patriots,jets,bengals,steelers,texans,colts,broncos,chiefs,
						redskins,eagles,vikings,packers,panthers,falcons,
						cardinals,seahawks],

				%group2(Games,[14,14,14,14,14,14,14,14,16,16,16,16,16,16,16,16,16],Cal),
				%group2(Games,[6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,2],Cal),
				group2(Games,[7,7,7,7,4],Cal),
				%only_play_once(Cal),
				%group(Teams,[4,4,4,4,4,4,4,4],Bye).
				%take(8,Cal,CalBye),
				%generate(CalBye,Teams,Bye).
				group(Teams,[4,4,4,4],Bye).
				%not_repeated(Cal,Bye).

% Predicado que toma los primero N elementos de una lista.
take(1,[L|_],[L]):-!.
take(N,[L|List],[L|Taken]):- N1 is N-1, take(N1,List,Taken).

% Predicado que genera la lista de byes basado en el calendario.
generate([],_,Bye).
generate([W|Cal],Teams,[B|Byes]):- juegan(W,Teams,B),
								generate(Cal,Teams,Byes).

% Predicados que verifica qué equipos juegan una semana y los elimina.
juegan([],Teams,Teams):- !.
juegan([[X,Y]|Week],Teams,Lista):- select(X,Teams,Nueva1),
								select(Y,Nueva1,Nueva2),
								juegan(Week,Nueva2,Lista).

% Predicado que triunfa si en una semana, los equipos que están descansando
% no tienen partido.
not_repeated(W,[]) :- true.
not_repeated([W|Weeks],[B|Byes]) :- \+common_team(W,B), not_repeated(Weeks,Byes).

% Predicado que triunfa si en una lista de juegos hay equipos en común.
common_team(Games,Teams) :- member(G,Games), member(T,G), member(T,Teams),!.

% Predicado que calcula y muestra calendarios balanceados para la temporada 
% regular 2016 de la NFL.
schedule :- calendario(Cal,Bye),
			nl,
			print_week(Cal,Bye,1).

% Predicado que imprime el calendario semana por semana.
print_week([],_,_).
print_week([W|Cal],[],N) :- write('Week '), write(N), nl,
							write('------'), nl,
							print_game(W),
							N1 is N + 1,
							print_week(Cal,[],N1).
print_week([W|Cal],[B|Bye],N) :- write('Week '), write(N), nl,
								write('------'), nl,
								print_game(W),
								write('Bye: '),
								print_bye(B),nl,
								N1 is N + 1,
								print_week(Cal,Bye,N1).

% Predicado que imprime los partidos de una semana.
print_game([]) :- nl.
print_game([[T1,T2]|Game]) :- write(T1), write(' at '), write(T2), nl,
								print_game(Game).

% Predicado que imprime la lista de equipos que descansan.
print_bye([]):- nl.
print_bye([B]):- write(B), write('.'), nl.
print_bye([B|Bye]) :- write(B),write(', '), print_bye(Bye).

