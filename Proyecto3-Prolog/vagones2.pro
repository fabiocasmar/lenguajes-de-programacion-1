%   Nombre del archivo:  vagones.pro
%   Realizado por:    Fabio    Castro     10-10132
%                     Patricia Reinoso    11-10851
%   Organización: Universidad Simón Bolívar
%   Proyecto: Programación Lógica - Lenguajes de Programación I
%   Versión: v0.3.0

vagones(INI,FIN,OPE) :- permutation(INI,FIN), mover(FIN,[],[],INI,OPE).

mover(S,[],[],S,[]).
mover(C,A,B,S,E) :-    
	H = pop(below,X), append(C1,Y,C), append(Y,A,A1), 
	length(Y,X), X > 0, mover(C1,A1,B,S,T), E = [H|T].

mover(C,A,B,S,E) :-    
	H = pop(above,X), append(C1,Y,C), append(Y,B,B1), 
	length(Y,X), X > 0, mover(C1,A,B1,S,T), E = [H|T].

mover(C,A,B,S,E) :-   
	H = push(below,X), append(C,Y,C1), append(Y,A1,A), 
	length(Y,X), X > 0, mover(C1,A1,B,S,T), E = [H|T].

mover(C,A,B,S,E) :-     
	H = push(above,X), append(C,Y,C1), append(Y,B1,B), 
	length(Y,X), X > 0, mover(C1,A,B1,S,T), E = [H|T].