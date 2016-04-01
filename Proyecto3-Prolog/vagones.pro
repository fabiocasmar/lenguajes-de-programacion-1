%   Nombre del archivo:  vagones.pro
%   Realizado por:    Fabio    Castro     10-10132
%                     Patricia Reinoso    11-10851
%   Organización: Universidad Simón Bolívar
%   Proyecto: Programación Lógica - Lenguajes de Programación I
%   Versión: v0.3.0

vagones(I,F,L) :- permutation(I,F), mover(F,[],[],I,L0), L0 = L.

meter_arriba(C,X,A,C1,A1) :- append(C1,Y,C), append(Y,A,A1), length(Y,X).

meter_abajo(C,X,B,C1,B1)  :- append(C1,Y,C), append(Y,B,B1), length(Y,X).

sacar_arriba(C,X,A,C1,A1) :- append(C,Y,C1), append(Y,A1,A), length(Y,X).

sacar_abajo(C,X,B,C1,B1)  :- append(C,Y,C1), append(Y,B1,B), length(Y,X).

mover(S,[],[],S,[]).
mover(C,A,B,S,L) :- reverse(L,L0), [H|T] = L0, 
	H = pop(below,X), meter_arriba(C,X,A,C1,A1), X > 0,
	reverse(T,T0), mover(C1,A1,B,S,T0).
mover(C,A,B,S,L) :- reverse(L,L0), [H|T] = L0,
	H = pop(above,X), meter_abajo(C,X,B,C1,B1), X > 0,
	reverse(T,T0), mover(C1,A,B1,S,T0).
mover(C,A,B,S,L) :- reverse(L,L0), [H|T] = L0,
	H = push(below,X), sacar_arriba(C,X,A,C1,A1), X > 0,
	reverse(T,T0), mover(C1,A1,B,S,T0).
mover(C,A,B,S,L) :- reverse(L,L0), [H|T] = L0,
	H = push(above,X), sacar_abajo(C,X,B,C1,B1), X > 0,
	reverse(T,T0), mover(C1,A,B1,S,T0).