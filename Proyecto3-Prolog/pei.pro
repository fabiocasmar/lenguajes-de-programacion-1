%   Nombre del archivo:  pei.pro
%   @author    Fabio Castro (10-10132) & Patricia Reinoso (11-10851)
%   Organización: Universidad Simón Bolívar
%   Proyecto: Programación Lógica - Lenguajes de Programación I
%   Versión: v0.3.0
%   @license GPL


%% pei_aux(X,Y,Z).
%
% Devuelve de dos en dos los número entre X y Y.
% @param X el valor del minimo.
% @param Y el valor máximo.
% @param Z el valor a devoler.
%

pei_aux(X,_,X).

pei_aux(X,Y,Z) :- X1 is X+2, X < Y-1, pei_aux(X1,Y,Z).

%% pei_aux(X,Y,Z).
%
% Realiza la multiplicación con las restricciones,
%     haciendo uso de la función auxiliar pei_aux.
pei :-
    pei_aux(1, 9, I1),
    pei_aux(0, 9, I2),
    pei_aux(0, 9, I3),
    pei_aux(2, 9, J1),
    pei_aux(0, 9, J2),
    pei_aux(2, 9, K1),
    pei_aux(1, 9, K2),
    pei_aux(0, 9, K3),
    pei_aux(0, 9, K4),
    (K1*1000 + K2*100 + K3*10 + K4) =:=  ((I1*100 + I2*10 + I3)*J2),
    pei_aux(2, 9, L1),
    pei_aux(1, 9, L2),
    pei_aux(0, 9, L3),
    (L1*100 + L2*10 + L3) =:= ((I1*100 + I2*10 +I3)*J1),
    pei_aux(1, 9, M1),
    pei_aux(1, 9, M2),
    pei_aux(0, 9, M3),
    pei_aux(0, 9, M4),
    ((K1*1000 + K2*100 + K3*10 + K4) + (L1*1000 + L2*100 + L3*10))
        =:= (M1*1000 + M2*100 + M3*10 + M4),
    write(' '),
    write(' '),
    write(I1),
    write(' '),
    write(I2),
    write(' '),
    write(I3),
    write(' '),
    write('*'),
    nl,
    write(' '),
    write(' '),
    write(' '),
    write(' '),
    write(J1),
    write(' '),
    write(J2),
    write(' '),
    write(' '),
    nl,
    write('-'),
    write('-'),
    write('-'),
    write('-'),
    write('-'),
    write('-'),
    write('-'),
    write(' '),
    write(' '),
    nl,
    write(K1),
    write(' '),
    write(K2),
    write(' '),
    write(K3),
    write(' '),
    write(K4),
    write(' '),
    write('+'),
    nl,
    write(L1),
    write(' '),
    write(L2),
    write(' '),
    write(L3),
    write(' '),
    write(' '),
    write(' '),
    write(' '),
    nl,
    write('-'),
    write('-'),
    write('-'),
    write('-'),
    write('-'),
    write('-'),
    write('-'),
    write(' '),
    write(' '),
    nl,
    write(M1),
    write(' '),
    write(M2),
    write(' '),
    write(M3),
    write(' '),
    write(M4),
    write(' '),
    write(' '),
    !.
