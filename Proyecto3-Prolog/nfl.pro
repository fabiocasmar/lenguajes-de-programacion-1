%   Nombre del archivo:  nfl.pro
%   Realizado por:    Fabio    Castro     10-10132
%                     Patricia Reinoso    11-10851
%   Universidad Simón Bolívar
%   Proyecto: Programación Lógica - Lenguajes de Programación I
%   Versión: v0.3.0

% El problema es calcular y mostrar calendarios balanceados para la temporada
% regular 2016 de la NFL.

% Los standings representan los resultados de la temporada 2015-2016.

% standings(Conferencia,División,Posición,Nombre del equipo).
% Conferencia puede ser americana (afc) o nacional (nfc),
% División representa la distribución geográfica (north, east, south o west)
% Posición es un valor P entre 0 y 4 que representa la posición del equipo
% dentro de su conferencia y división.

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

% Predicado que genera los partidos divisionales.
% @param Partido lista de 2 elementos que representa un partido divisional.
divisionales(Partido) :- Partido = [T1, T2], 
						standings(C,D,_,T1), 
						standings(C,D,_,T2), 
						T1 \= T2.

% Predicado los partidos intra-conferencia.
% @param Partido lista de 2 elementos que representa un partido intraconferencia.
intra-conf(Partido):- Partido=[T1,T2], 
					intra(D1,D2), 
					standings(C,D1,_,T1), 
					standings(C,D2,_,T2), 
					T1 \= T2.

% Predicado que genera los partidos inter-conferencia.
% @param Partido lista de 2 elementos que representa un partido interconferencia.
inter-conf(Partido):- Partido = [T1,T2], 
					inter(D1,D2), 
					standings(afc,D1,_,T1), 
					standings(nfc,D2,_,T2).

% Predicado que genera los partidos contra equipos que quedaron en la posisión p 
% de su misma conferencia.
% @param Partido lista de 2 elementos que representa un partido contra equipos
% que quedaron en la misma posición.
position(Partido) :- Partido = [T1,T2], 
					intra(north,D5), 
					standings(C,north,P,T1), 
					standings(C,D2,P,T2), 
					T1\= T2, D2 \= D5.
position(Partido) :- Partido = [T1,T2], 
					intra(D5,east), 
					standings(C,east,P,T1), 
					standings(C,D2,P,T2), T1\= T2, D2 \= D5.

% Predicado que genera todos los partidos.
% @param Partido lista de 2 elementos que representa un partido.
games(Partido) :- divisionales(Partido).
games(Partido) :- intra-conf(Partido).
games(Partido) :- inter-conf(Partido).
games(Partido) :- position(Partido).

% Predicado que triunfa si en una lista Games de juegos hay equipos en común con
% una lista Teams de equipos.
% @param Games lista de juegos.
% @param Teams lista de equipos.
common_team(Games,Teams) :- member(G,Games), 
							member(T,G), 
							member(T,Teams),!.

% Predicado que seleciona N elementos de una lista L y los coloca en un conjunto S.
% @param N 		número de elementos a seleccionar.
% @param L 		lista de la cual se toman los elementos.
% @param [X|S] 	conjunto donde se colocará el elemento.
selectN(0,_,[]) :- !.
selectN(N,L,[X|S]) :- N > 0, element(X,L,R), 
					N1 is N-1, 
					selectN(N1,R,S), 
					\+common_team(S,X).

% Predicado que toma elementos de una lista y devuelte el resto.
% @param X elemento a tomar la lista.
% @param [X|L] lista del que se selecciona el elemento.
% @param R lista sin el elemento seleccionado.
element(X,[X|L],L).
element(X,[_|L],R) :- element(X,L,R).

% Predicado que elimina de la primera lista, todos los elementos de la segunda
% lista y retorna el resultado el tercera lista.
subtract([], _, []).
subtract([Head|Tail],L2,L3) :- memberchk(Head, L2), !,
								subtract(Tail, L2, L3).
subtract([Head|Tail1],L2,[Head|Tail3]) :- subtract(Tail1, L2, Tail3).

% Predicado que distribuye los elementos de una lista en subconjuntos.
% Problema 27 de los 99 problemas de Prolog.
% @param G 		 lista que será dividida en subconjuntos.
% @param [N1|Ns] lista de enteros que representa el tamaño de cada subconjunto.
% @param [G1|Gs] lista de subconjuntos
group([],[],[]).
group(G,[N1|Ns],[G1|Gs]) :- selectN(N1,G,G1), 
							subtract(G,G1,R), 
							group(R,Ns,Gs).

% Predicado que toma los primero N elementos de una lista L y los retorna en una
% nueva lista.
take(1,[L|_],[L]):-!.
take(N,[L|List],[L|Taken]):- N1 is N-1, take(N1,List,Taken).

% Predicados que verifica qué equipos juegan una semana, los elimina y retorna 
% en resultado en una nueva lista Lista.
play([],Teams,Teams):- !.
play([[X,Y]|Week],Teams,Lista):- select(X,Teams,Nueva1),
								select(Y,Nueva1,Nueva2),
								play(Week,Nueva2,Lista).

% Predicado que genera la lista de byes basado en el calendario.
% @param [W|Cal] lista con la lista de partidos de cada semana (calendario).
% @param Teams   lista de todos los equipos de la NFL.
% @param Bye 	 lista de byes generada.
generate([],_,Bye).
generate([W|Cal],Teams,[B|Byes]):- play(W,Teams,B),
								generate(Cal,Teams,Byes).

% Predicado que genera un calendario Cal con la lista de partidos por semana y 
% una lista Byes con los equipos que descansan por semana.
% @param Cal lista de listas con los partidos por cada semana (calendario).
% @param Bye lista de Bye.
calendario(Cal,Bye) :- findall(X,games(X), Games),
				
				Teams = [fortynineers,rams,seahawks,cardinals,buccaneers,saints,
						falcons,panthers,bears,lions,packers,vikings,cowboys,
						giants,eagles,redskins,chargers,raiders,chiefs,broncos,
						titans,jaguars,colts,texans,browns,ravens,steelers,
						bengals,dolphins,bills,jets,patriots],

				group(Games,[14,14,14,14,14,14,14,14,16,16,16,16,16,16,16,16,16],Cal),
				take(8,Cal,CalBye),
				generate(CalBye,Teams,Bye).

% Predicado que imprime la lista de equipos que descansan.
% @param [B|Bye] lista de byes a imprimir.
print_bye([]):- nl.
print_bye([B]):- write(B), write('.'), nl.
print_bye([B|Bye]) :- write(B),write(', '), print_bye(Bye).

% Predicado que imprime los partidos de una semana.
% @param [[T1,T2]|Game] lista de partidos a imprimir.
print_game([]) :- nl.
print_game([[T1,T2]|Game]) :- write(T1), 
							write(' at '), 
							write(T2), 
							nl,
							print_game(Game).

% Predicado que imprime el calendario semana por semana.
% @param [W|Cal] calendario.
% @param [B|Bye] lista de Byes.
% @param N número de semana.
print_week([],_,_).
print_week([W|Cal],[],N) :- write('Week '), 
							write(N), 
							nl,
							write('------'), 
							nl,
							print_game(W),
							N1 is N + 1,
							print_week(Cal,[],N1).
print_week([W|Cal],[B|Bye],N) :- write('Week '), 
								write(N), 
								nl,
								write('------'), 
								nl,
								print_game(W),
								write('Bye: '),
								print_bye(B),
								nl,
								N1 is N + 1,
								print_week(Cal,Bye,N1).

% Predicado que calcula y muestra calendarios balanceados para la temporada 
% regular 2016 de la NFL.
schedule :- calendario(Cal,Bye),
			nl,
			print_week(Cal,Bye,1).
