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


% usa habilidades
% campeao(Nome, Primario, Tipo, Dificuldade, Honra)

% adcarries ranged
champion(lucian, marksman, physical, 2, justice).
champion(kogmaw, marksman, mixed, 2, strength).
champion(graves, marksman, physical, 2, strength).
champion(jhin, marksman, physical, 2, strength).
champion(jinx, marksman, physical, 2, strength).
champion(caitlyin, marksman, physical, 1, justice).
champion(ashe, marksman, physical, 1, justice).
champion(corki, marksman, mixed, 2, justice).
champion(kalista, marksman, physical, 3, strength).
champion(draven, marksman, physical, 3, strength).

% junglers
champion(kindred, marksman, physical, 2, justice).
champion(amumu, vanguard, magic, 1, neutral).
champion(shaco, assassin, physical, 2, strength).
champion('lee sin', diver, physical, 3, justice).
champion('jarvan IV', diver, physical, 1, justice).
champion(elise, diver, magic, 3, strength).
champion(evelynn, diver, magic, 2, strength).
champion(nocturne, diver, physical, 1, strength).
champion(warwick, diver, mixed, 1, strength).
champion(vi, diver, physical, 1, justice).

% controllers
champion(janna, enchanter, magic, 1, justice).
champion(karma, enchanter, magic, 1, justice).
champion(bardo, enchanter, magic, 3, justice).
champion(soraka, enchanter, magic, 1, justice).
champion(sona, enchanter, magic, 1, justice).
champion(nami, enchanter, magic, 2, neutral).
champion(taric, enchanter, magic, 2, justice).
champion(leona, vanguard, magic, 1, justice).
champion(lulu, enchanter, magic, 2, neutral).
champion(thresh, warden, magic, 3, strength).

% mid
% champion(kayle, marksman, mixed, 2, justice).


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
                     next_step_honor(1).


%----------------------%


%----------------------%

next_step_honor(1) :- write('And what kind of honor you prefer?'), nl,
                   write('1 - Justice, 2 - Strength, 3 - Neutral'), nl,
                   read(Alternative),
                   profile:set(1, [honor_type(Alternative)]), nl, nl, nl,
                   analyze_profile(1).


%----------------------%



% Exemplo de como achar um champion baseado nas respostas
analyze_profile(1) :- profile(1, experience(Experience)),
                      profile(1, damage_type(Damage_Type)),
                      profile(1, honor_type(Honor_Type)),
                      find_champion(Experience, Damage_Type, Honor_Type).

find_champion(Experience, Damage_Type, Honor_Type) :- champion_honor(Honor, Honor_Type),
                                                      champion_damage(Damage, Damage_Type),
                                                      champion_by_profile(Champions_Found, Experience, Damage, Honor),
                                                      length(Champions_Found, Champions_Found_Length),
                                                      write_champion(Champions_Found_Length, Champions_Found).


write_champion(0, _) :- write('Sorry :/, we could not find a champion for you').
write_champion(_, List) :- write('These champions fit rigth for you'), nl,
                           write(List).

% Honor 1 - justice, 2 - strength, 3 - neutral
honor_types(justice, strength, neutral).
champion_honor(Honor_Selected, 1) :- honor_types(Honor_Selected, _, _).
champion_honor(Honor_Selected, 2) :- honor_types(_, Honor_Selected, _).
champion_honor(Honor_Selected, 3) :- honor_types(_, _, Honor_Selected).

% Damage 1 - justice, 2 - strength, 3 - neutral
damage_types(physical, magic, mixed).
champion_damage(Damage_Selected, 1) :- damage_types(Damage_Selected, _, _).
champion_damage(Damage_Selected, 2) :- damage_types(_, Damage_Selected, _).
champion_damage(Damage_Selected, 3) :- damage_types(_, _, Damage_Selected).

champion_by_profile(Champions_Found, Experience, Damage_Type, Honor) :- findall(
                                                                                  X,
                                                                                  champion(X, _, Damage_Type, Experience, Honor),
                                                                                  Champions_Found
                                                                                ).
