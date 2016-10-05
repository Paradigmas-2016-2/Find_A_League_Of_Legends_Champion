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


% usa habilidades
% EstiloDano 0 - 100, sendo 0 um campeão que só usa ataque básico e 100 que só
% campeao(Nome, Primario, Dano, Resistencia, Controle, EstiloDano, Dificuldade, Honra)

champion(ashe, marksman, 2, 1, 3, 20, 1, justice).
champion(corki, marksman, 3, 0, 1, 45, 2, justice).
champion(kalista, marksman, 3, 0, 1, 10, 3, strength).

champion(amumu, vanguard, 2, 3, 3, 90, 1, neutral).
champion(shaco, assassin, 3, 0, 2, 45, 2, strength).
champion('lee sin', diver, 3, 2, 2, 55, 3, justice).

champion(janna, enchanter, 1, 0 , 3, 100, 1, justice).
champion(lulu, enchanter, 2, 0, 2, 80, 2, neutral).
champion(thresh, warden, 1, 2, 3, 75, 3, strength).

% Vanguard: starter, ex: Malphite
% Warden: protect ex: Shen

tank(X) :- champion(X, vanguard, _, _, _, _, _,_);
           champion(X, warden, _, _, _, _, _,_).

% Juggernaut: more tank than damage ex: Nasus
% Diver: more damage than tank ex: Xin Zhao

fighter(X) :- champion(X, juggernaut, _, _, _, _, _,_);
              champion(X, diver, _, _, _, _, _,_).

% Assassin: have high mobility, escape and burst damage ex: Zed
% Skirmisher: don't have escape but have burst damage ex: Fiora

slayer(X) :- champion(X, assassins, _, _, _, _, _,_);
             champion(X, skirmisher, _, _, _, _, _,_).

% Burst: have only burst damage ex: Veigar
% Battle: have some tons of damage, and have a average resistence ex: Vladimir
% Artillery: have so much damage in poke ex: Ziggs

mage(X) :- champion(X, burst, _, _, _, _, _,_);
           champion(X, battle, _, _, _, _, _,_);
           champion(X, artillery, _, _, _, _, _,_).

% Enchanter: controllers that amplify allies ex: lulu
% Disruptor: controllers that snared enemies ex: Zyra
controller(X) :- champion(X, enchanter, _, _, _, _, _,_);
                 champion(X, disruptor, _, _, _, _, _,_).

% Marksman: Champions that have a lot of damaged, and have so much range ex: Ashe

marksman(X) :- champion(X, marksman, _, _, _, _, _,_).

% Type of Honor

strength(X) :-  champion(X, _, _, _, _, _, _, strength).
justice(X) :- champion(X, _, _, _, _, _, _, justice).
neutral(X) :- champion(X, _, _, _, _, _, _, neutral).
