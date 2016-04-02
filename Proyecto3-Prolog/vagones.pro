%   Nombre del archivo:  vagones.pro
%   @author    Fabio Castro (10-10132) & Patricia Reinoso (11-10851)
%   Organización: Universidad Simón Bolívar
%   Proyecto: Programación Lógica - Lenguajes de Programación I
%   Versión: v0.6.0
%   @license GPL


%% vagones(L,L1,L2,L3,L4).
%
% Revisa si L1 es una permutacion de L y ejecuta la llamada a movement_list.
% @param L  estado inicial del vagon
% @param L1 estado inicial del anden above
% @param L2 estado inicial del anden below
%

vagones(L,L1,L2) :- permutation(L,L1), movement_list(L1,[],[],L,L2).


%% movement_list(L,L1,L2,L3,L4).
%
% Hace uso de las listas L1 y L2, y devuelve la serie de pasos necesarios para
%   que L sea igual a L3.
%
% @param L  estado inicial del vagon
% @param L1 estado inicial del anden above
% @param L2 estado inicial del anden below
% @param L3 estado final de la solucion
% @param L4 lista de operaciones a realizar
%

movement_list(L,[],[],L,[]).

movement_list(L,L1,L2,L3,L4) :-
    reverse(L4,L5),
    [A|L6] = L5,
    A = pop(below,N),
    append(L7,L8,L),
    append(L8,L1,L9),
    length(L8,N),
    N > 0,
    reverse(L6,L10),
    movement_list(L7,L9,L2,L3,L10).

movement_list(L,L1,L2,L3,L4) :-
    reverse(L4,L5),
    [A|L6] = L5,
    A = pop(above,N),
    append(L7,L8,L),
    append(L8,L2,L9),
    length(L8,N),
    N > 0,
    reverse(L6,L10),
    movement_list(L7,L1,L9,L3,L10).

movement_list(L,L1,L2,L3,L4) :-
    reverse(L4,L5),
    [A|L6] = L5,
    A = push(below,N),
    append(L,L8,L7),
    append(L8,L9,L1),
    length(L8,N), N > 0,
    reverse(L6,L10),
    movement_list(L7,L9,L2,L3,L10).

movement_list(L,L1,L2,L3,L4) :-
    reverse(L4,L5),
    [A|L6] = L5,
    A = push(above,N),
    append(L,L8,L7),
    append(L8,L9,L2),
    length(L8,N),
    N > 0,
    reverse(L6,L10),
    movement_list(L7,L1,L9,L3,L10).
