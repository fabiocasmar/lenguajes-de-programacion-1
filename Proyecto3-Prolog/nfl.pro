standings(afc,east,1,patriots).
standings(afc,east,2,jets).
standings(afc,east,3,bills).
standings(afc,east,4,dolphins).

standings(afc,north,1,bengals).
standings(afc,north,2,steelers).
standings(afc,north,3,ravens).
standings(afc,north,4,browns).

standings(afc,south,1,texans).
standings(afc,south,2,colts).
standings(afc,south,3,jaguars).
standings(afc,south,4,titans).

standings(afc,west,1,broncos).
standings(afc,west,2,chiefs).
standings(afc,west,3,raiders).
standings(afc,west,4,chargers).

standings(nfc,east,1,redskins).
standings(nfc,east,2,eagles).
standings(nfc,east,3,giants).
standings(nfc,east,4,cowboys).

standings(nfc,north,1,vikings).
standings(nfc,north,2,packers).
standings(nfc,north,3,lions).
standings(nfc,north,4,bears).

standings(nfc,south,1,panthers).
standings(nfc,south,2,falcons).
standings(nfc,south,3,saints).
standings(nfc,south,4,buccaneers).

standings(nfc,west,1,cardinals).
standings(nfc,west,2,seahawks).
standings(nfc,west,3,rams).
standings(nfc,west,4,fortynineers).

intra(north,east).
intra(south,west).

% El primer argumento indica la división en la AFC y el segundo argumento indica la división en la NFC
inter(east,west).
inter(north,east).
inter(south,north).
inter(west,south).

% Genera una lista de 2 elementos que representan los partidos divisionales.
divisionales(Partido) :- Partido = [T1, T2], standings(C,D,_,T1), standings(C,D,_,T2), T1 \= T2.

% Genera las combinaciones de equipos para los partidos divisionales.
divisionales1(T1,T2) :- standings(C,D,_,T1), standings(C,D,_,T2), T1 \= T2.

% Genera una lista de 2 elementos que representan los partidos intra-conferencia.
intra-conf(Partido):- Partido=[T1,T2], intra(D1,D2), standings(C,D1,_,T1), standings(C,D2,_,T2), T1 \= T2.

% Genera las combinaciones de equipo para los partidos intra-conferencia.
intra-conf1(T1,T2):- intra(D1,D2), standings(C,D1,_,T1), standings(C,D2,_,T2), T1 \= T2.

% Genera una lista de 2 elementos que representan los partidos inter-conferencia.
inter-conf(Partido):- Partido = [T1,T2], inter(D1,D2), standings(afc,D1,_,T1), standings(nfc,D2,_,T2).

% Genera las combinaciones de equipo para los partidos inter-conferencia.
inter-conf1(T1,T2):- inter(D1,D2), standings(afc,D1,_,T1), standings(nfc,D2,_,T2).
inter-conf(T1,T2):- inter(D1,D2), standings(afc,D1,_,T2), standings(nfc,D2,_,T1).

% Genera las combinaciones de equipo para los partidos segun la posición
pos(T1,T2) :- intra(D1,D5), standings(C,D1,P,T1), standings(C,D2,P,T2), T1\= T2, D2 \= D5.
pos(T1,T2) :- intra(D5,D1), standings(C,D1,P,T1), standings(C,D2,P,T2), T1\= T2, D2 \= D5.
