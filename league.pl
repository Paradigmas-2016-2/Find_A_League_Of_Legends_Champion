% Cria um perfil de usuario
:- dynamic profile/2.

set(ID, X) :- profile(ID, X), !.
set(ID, X) :- X =.. [Attr, _],
              E =.. [Attr, _],
              retractall(profile(ID,E)),
              assertz(profile(ID,X)).

set(_, []) :- !.
set(ID, [X|Rest]) :- set(ID, X), set(ID, Rest).
get(ID, R) :- findall(X, profile(ID, X), R).
drop(ID) :- retractall(profile(ID, _)).

play :-	write('Welcome to summoner\'s rift '), nl, nl, nl,
  write('We\'ll try to find the perfect champion for you.'), nl,
  write('First,'), nl,
  write('How experienced are you in league of legends?'), nl,
  write('1 - Beginner, 2 - Average, 3 - Experienced'), nl,
  read(Alternative),
  profile:set(1, [experience(Alternative)]), nl, nl, nl,
  next_step_exp(Alternative).

% Exemplo de como achar um champion baseado nas respostas
% find_champion(a) :- profile(1, experience(R)), find_champion(R) .
% find_champion(R) :- champion(X,_,_,_,_,_,R), write(X).


% campeao(Nome, Primario, Dano, Resistencia, Controle, EstiloDano, Dificuldade)
% usa habilidades
% EstiloDano 0 - 100, sendo 0 um campeão que só usa ataque básico e 100 que só

champion(ashe, marksman, 2, 1, 3, 20, 1).
champion(corki, marksman, 3, 0, 1, 45, 2).
champion(kalista, marksman, 3, 0, 1, 10, 3).

champion(amumu, vanguard, 2, 3, 3, 90, 1).
champion(shaco, assassin, 3, 0, 2, 45, 2).
champion('lee sin', diver, 3, 2, 2, 55, 3).

champion(janna, enchanter, 1, 0 , 3, 100, 1).
champion(lulu, enchanter, 2, 0, 2, 80, 2).
champion(thresh, warden, 1, 2, 3, 75, 3).

% Malphite, Shen
tank(X) :- champion(X, vanguard, _, _, _, _, _);
           champion(X, warden, _, _, _, _, _).

% Nasus, Xin Zhao
fighter(X) :- champion(X, juggernaut, _, _, _, _, _);
              champion(X, diver, _, _, _, _, _).

% Zed, Fiora
slayer(X) :- champion(X, assassins, _, _, _, _, _);
             champion(X, skirmisher, _, _, _, _, _).

% Veigar, Vladimir, Ziggs
mage(X) :- champion(X, burst, _, _, _, _, _);
           champion(X, battle, _, _, _, _, _);
           champion(X, artillery, _, _, _, _, _).

% lulu, Zyra
controller(X) :- champion(X, enchanter, _, _, _, _, _);
                 champion(X, disruptor, _, _, _, _, _).

% Ashe
marksman(X) :- champion(X, marksman, _, _, _, _, _).


% Precisa adicionar o atributo cidade em todos os lugares onde tem champion
% para poder usuar
% strength(X) :-  champion(_, _, _, _, _, _, _, bilgewater),
%                 champion(_, _, _, _, _, _, _, noxus),
%                 champion(_, _, _, _, _, _, _, shurima),
%                 champion(_, _, _, _, _, _, _, zaun).
%
% justice(X) :- champion(_, _, _, _, _, _, _, demacia)
%               champion(_, _, _, _, _, _, _, 'bundle city')
%               champion(_, _, _, _, _, _, _, freljord)
%               champion(_, _, _, _, _, _, _, piltover).
%
% neutral(X) :- champion(_, _, _, _, _, _, _, ionia),
%               champion(_, _, _, _, _, _, _, 'mount targon'),
%               champion(_, _, _, _, _, _, _, 'shadow isles').
