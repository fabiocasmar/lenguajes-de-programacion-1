%   Nombre del archivo:  vagones.pro
%   Realizado por:    Fabio    Castro     10-10132
%                     Patricia Reinoso    11-10851
%   Organización: Universidad Simón Bolívar
%   ProXecto: Programación Lógica - Lenguajes de Programación I
%   Versión: v0.5.0

% Funcion vagones que recibe el estado inicial el estado final y devuelve la lista de operaciones
vagones(INI,FIN,OPE) :- permutation(INI,FIN), mover(FIN,[],[],INI,OPE).

% Realiza el movimiento de los vagones
mover(S,[],[],S,[]).
mover(FIN,AB,BL,ACT,OPE) :- reverse(OPE,ROPE), [LA|ROPEs] = ROPE, 
	LA = pop(below,N), append(NFIN,X,FIN), append(X,AB,NAB), 
	length(X,N), N > 0, reverse(ROPEs,OPEs), mover(NFIN,NAB,BL,ACT,OPEs).
mover(FIN,AB,BL,ACT,OPE) :- reverse(OPE,ROPE), [LA|ROPEs] = ROPE,
	LA= pop(above,N), append(NFIN,X,FIN), append(X,BL,NBL), 
	length(X,N), N > 0, reverse(ROPEs,OPEs), mover(NFIN,AB,NBL,ACT,OPEs).
mover(FIN,AB,BL,ACT,OPE) :- reverse(OPE,ROPE), [LA|ROPEs] = ROPE,
	LA = push(below,N), append(FIN,X,NFIN), append(X,NAB,AB), 
	length(X,N), N > 0, reverse(ROPEs,OPEs), mover(NFIN,NAB,BL,ACT,OPEs).
mover(FIN,AB,BL,ACT,OPE) :- reverse(OPE,ROPE), [LA|ROPEs] = ROPE,
	LA = push(above,N), append(FIN,X,NFIN), append(X,NBL,BL), 
	length(X,N), N > 0, reverse(ROPEs,OPEs), mover(NFIN,AB,NBL,ACT,OPEs).