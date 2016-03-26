%   Nombre del archivo:  pei.pro
%   Realizado por:    Fabio    Castro     10-10132
%                     Patricia Reinoso    11-10851
%   Organización: Universidad Simón Bolívar
%   Proyecto: Programación Lógica - Lenguajes de Programación I
%   Versión: v0.1.0

% El problema que se quieres resolver es el siguiente, donde el sufijo I
%       indica que es un dígito impar, el sufijo D indica que es un
%       dígito par, A, B, C, D o R, indica el número como tal,
%       y el número la posición en dicho número.
%
%     IA1 PA2 PA3 *
%         PB1 PB2
% ---------------
% PC1 IC2 PC3 PC4 +
% PD1 ID2 PD3
% ---------------
% IR1 IR2 PR3 PR4

% Devuelve de dos en dos los número entre X y Y.
bt(X,_,X).
bt(X,Y,Z) :- X1 is X+2, X < Y-1, bt(X1,Y,Z).

% Comprueba la multiplicación del primer dígito, del número B con el número A.
c1(PC1, IC2, PC3, PC4, IA1, PA2, PA3, PB2) :-
    (PC1*1000 + IC2*100 + PC3*10 + PC4)
        =:=  ((IA1*100 + PA2*10 + PA3)*PB2).

% Comprueba la multiplicación del segundo dígito, del número B con el número A.
c2(PD1, ID2, PD3, IA1, PA2, PA3, PB1) :-
    (PD1*100 + ID2*10 + PD3)
        =:= ((IA1*100 + PA2*10 +PA3)*PB1).

% Comprueba que multiplicación de A con B, de igual a la suma de C y D.
% c3(PC1, IC2, PC3, PC4, PD1, ID2, PD3, IA1, PA2, PA3, PB1, PB2) :-
%    ((PC1*1000 + IC2*100 + PC3*10 + PC4) + (PD1*1000 + ID2*100 + PD3*10))
%        =:=  ((IA1*100 + PA2*10 + PA3) * (PB1*10 + PB2)).

% Comprueba que multiplicación de A con B, de el resultado R.
%c4(IA1, PA2, PA3, PB1, PB2, IR1, IR2, PR3, PR4) :-
%    ((IA1*100 + PA2*10 + PA3) * (PB1*10 + PB2))
%        =:=  (IR1*1000 + IR2*100 + PR3*10 + PR4).

% Comprueba que la suma de C y D, de el resultado R.
c5(PC1, IC2, PC3, PC4, PD1, ID2, PD3, IR1, IR2, PR3, PR4) :-
    ((PC1*1000 + IC2*100 + PC3*10 + PC4) + (PD1*1000 + ID2*100 + PD3*10))
        =:= (IR1*1000 + IR2*100 + PR3*10 + PR4).

% Realiza la multiplicación, haciendo uso de las funciones auxiliares.
pei(PA2,PA3,PB1,PB2,PC1,IC2,PC3,PC4,PD1,ID2,PD3,IR1,IR2,PR3,PR4) :-
    bt(1, 9, IA1),
    bt(0, 9, PA2),
    bt(0, 9, PA3),
    bt(2, 9, PB1),
    bt(0, 9, PB2),
    bt(2, 9, PC1),
    bt(1, 9, IC2),
    bt(0, 9, PC3),
    bt(0, 9, PC4),
    c1(PC1, IC2, PC3, PC4, IA1, PA2, PA3, PB2),
    bt(2, 9, PD1),
    bt(1, 9, ID2),
    bt(0, 9, PD3),
    c2(PD1, ID2, PD3, IA1, PA2, PA3, PB1),
% c3(PC1, IC2, PC3, PC4, PD1, ID2, PD3, IA1, PA2, PA3, PB1, PB2),
    bt(1, 9, IR1),
    bt(1, 9, IR2),
    bt(0, 9, PR3),
    bt(0, 9, PR4),
% c4(IA1, PA2, PA3, PB1, PB2, IR1, IR2, PR3, PR4).
    c5(PC1, IC2, PC3, PC4, PD1, ID2, PD3, IR1, IR2, PR3, PR4), !.
