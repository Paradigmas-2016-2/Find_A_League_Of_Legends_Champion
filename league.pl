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
  write('How experienced are you with league of legends?'), nl,
  write('1 - Beginner, 2 - Average, 3 - Experienced'), nl,
  read(Alternative),
  profile:set(1, [experience(Alternative)]), nl, nl, nl,
  next_step_type(1).

%----------------------%
% next_step_exp(1) :- write('What is your type of game?'), nl,
%                     write('1 - Damagier, 2 - Helper, 3 - Tank'), nl,
%                     read(Alternative),
%                     next_step_type(1).

%----------------------%

next_step_type(1) :- write('And how you would like to face your enemies?'), nl,
                     write('1 - Physical damage, 2 - Magical damage, 3 - Mixed damage'), nl,
                     read(Alternative),
                     profile:set(1, [damage_type(Alternative)]), nl, nl, nl,
                     analyze_profile(1).


%----------------------%




% Exemplo de como achar um champion baseado nas respostas
analyze_profile(1) :- profile(1, experience(A)),
                    profile(1, damage_type(B)),
                    find_champion(A, B).

find_champion(A, B) :- champion_by_type_of_damage(X,A,B),
                       length(X, X_Length),
                       write_champion(X_Length, X).

write_champion(0, _) :- write('Sorry :/, we could not find a champion for you').
write_champion(_, List) :- write('These champions fit rigth for you'), nl,
                           write(List).

champion_by_type_of_damage(Champions_Found, A, 1) :- findall(X,champion(X, _, physical, A, _), Champions_Found).
champion_by_type_of_damage(Champions_Found, A, 2) :- findall(X,champion(X, _, magic, A, _), Champions_Found).
champion_by_type_of_damage(Champions_Found, A, 3) :- findall(X,champion(X, _, mixed, A, _), Champions_Found).


% usa habilidades
% EstiloDano 0 - 100, sendo 0 um campeão que só usa ataque básico e 100 que só
% campeao(Nome, Primario, Tipo, Dificuldade, Honra)

champion(ashe, marksman, physical, 1, justice).
champion(corki, marksman, mixed, 2, justice).
champion(kalista, marksman, physical, 3, strength).

champion(amumu, vanguard, magic, 1, neutral).
champion(shaco, assassin, physical, 2, strength).
champion('lee sin', diver, physical, 3, justice).

champion(janna, enchanter, magic, 1, justice).
champion(lulu, enchanter, magic, 2, neutral).
champion(thresh, warden, magic, 3, strength).

% Vanguard: starter, ex: Malphite
% Warden: protect ex: Shen
tank(X) :- champion(X, vanguard, _, _, _);
           champion(X, warden, _, _, _).

% Juggernaut: more tank than damage ex: Nasus
% Diver: more damage than tank ex: Xin Zhao
fighter(X) :- champion(X, juggernaut, _, _, _);
              champion(X, diver, _, _, _).

% Assassin: have high mobility, escape and burst damage ex: Zed
% Skirmisher: don't have escape but have burst damage ex: Fiora
slayer(X) :- champion(X, assassins, _, _, _);
             champion(X, skirmisher, _, _, _).

% Burst: have only burst damage ex: Veigar
% Battle: have some tons of damage, and have a average resistence ex: Vladimir
% Artillery: have so much damage in poke ex: Ziggs
mage(X) :- champion(X, burst, _, _, _);
           champion(X, battle, _, _, _);
           champion(X, artillery, _, _, _).

% Enchanter: controllers that amplify allies ex: lulu
% Disruptor: controllers that snared enemies ex: Zyra
controller(X) :- champion(X, enchanter, _, _, _);
                 champion(X, disruptor, _, _, _).

% Marksman: Champions that have a lot of damaged, and have so much range ex: Ashe
marksman(X) :- champion(X, marksman, _, _, _).

% Type of Honor
strength(X) :-  champion(X, _, _, _, strength).
justice(X) :- champion(X, _, _, _, justice).
neutral(X) :- champion(X, _, _, _, neutral).
