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
champion(kayle, marksman, mixed, 2, justice).
champion(ahri, burst, magical, 2, justice).
champion(anivia, disruptor, magical, 3, justice).
champion(annie, burst, magical, 1, neutral).
champion(katarina, assassin, magical, 1, strength).
champion(veigar, burst, magical, 2, strength).
champion(swain, battlemage, magical, 2, strength).
champion(yasuo, assassin, physical, 3, justice).
champion(ryze, battlemage, magical, 2, justice).
champion(lulu, enchanter, magical, 2, neutral).




play :- write('Welcome to summoner\'s rift '), nl, nl, nl,
  write('We\'ll try to find the perfect champion for you.'), nl,
  write('First,'), nl,
  write('How experienced are you with league of legends?'), nl,
  write('1 - Beginner, 2 - Average, 3 - Experienced'), nl,
  read(Alternative),
  profile:set(1, [experience(Alternative)]), nl, nl, nl,
  next_step_honor(1).

%----------------------%
% next_step_exp(1) :- write('What is your type of game?'), nl,
%                     write('1 - Damagier, 2 - Helper, 3 - Tank'), nl,
%                     read(Alternative),
%                     next_step_type(1).

%----------------------%

next_step_honor(1) :- write('And what kind of honor you prefer?'), nl,
                   write('1 - Justice, 2 - Strength, 3 - Neutral'), nl,
                   read(Alternative),
                   profile:set(1, [honor_type(Alternative)]), nl, nl, nl,
                   next_step_type(1).


next_step_type(1) :- write('And how you would like to face your enemies?'), nl,
                     write('1 - Physical damage, 2 - Magical damage, 3 - Mixed damage'), nl,
                     read(Alternative),
                     profile:set(1, [damage_type(Alternative)]), nl, nl, nl,
                     choice_damage(Alternative).


choice_damage(1) :- next_step_physical_resistence(1).
choice_damage(2) :- next_step_magical_resistence(1).
choice_damage(3) :- next_step_mixed_resistence(1).

next_step_physical_resistence(1) :- write('And how would you prefer?'), nl,
                     write('1 - Physical damage with resistence , 2 - Physical damage squishy'), nl,
                     read(Alternative),
                     choice_resistence(Alternative).

choice_resistence(1) :- profile:set(1, [champion_class(0)]), nl, nl, nl,
                        analyze_profile(1).
choice_resistence(2) :- next_step_range(1).


next_step_range(1) :- write('And how would prefer?'), nl,
                     write('1 - Melee , 2 - Long Distance'), nl,
                     read(Alternative),
                     choice_range(Alternative).

choice_range(1) :- next_step_escape(1).
choice_range(2) :- profile:set(1, [champion_class(3)]), nl, nl, nl,
                          analyze_profile(1).


next_step_escape(1) :- write('And how would prefer?'), nl,
                     write('1 - Melee without escape, and high durability in fight , 2 - Melee with escape, but one focus'), nl,
                     read(Alternative),
                     profile:set(1, [champion_class(Alternative)]), nl, nl, nl,
                     analyze_profile(1).


%-----------------------%


next_step_mixed_resistence(1) :- write('And how would you prefer?'), nl,
                     write('1 - Mixed damage with resistence , 2 - Mixed damage squishy'), nl,
                     read(Alternative),
                     choice_resistence(Alternative).


%----------------------%

%-----------------------%


next_step_magical_resistence(1) :- write('And how would you prefer?'), nl,
                     write('1 - Magical damage with resistence , 2 - Magical damage squishy'), nl,
                     read(Alternative),
                     choice_resistence(Alternative).


%----------------------%




% Exemplo de como achar um champion baseado nas respostas
analyze_profile(1) :- profile(1, experience(Experience)),
                      profile(1, damage_type(Damage_Type)),
                      profile(1, honor_type(Honor_Type)),
                      profile(1, champion_class(Champion_Class)),
                      find_champion_physical(Experience, Damage_Type, Honor_Type, Champion_Class).

find_champion_option(Experience, 1, Honor_Type, Champion_Class) :- find_champion_physical(Experience, 1, Honor_Type, Champion_Class).
find_champion_option(Experience, 3, Honor_Type, Champion_Class) :- find_champion_mixed(Experience, 3, Honor_Type, Champion_Class).

find_champion_physical(Experience, Damage_Type, Honor_Type, Champion_Class) :- 
																											champion_honor(Honor, Honor_Type),
                                                      champion_damage(Damage, Damage_Type),
																											champion_physical_class(Class, Champion_Class),
                                                      champion_by_profile(Champions_Found, Experience, Damage, Honor, Class),
                                                      length(Champions_Found, Champions_Found_Length),
                                                      write_champion(Champions_Found_Length, Champions_Found).


find_champion_mixed(Experience, Damage_Type, Honor_Type, Champion_Class) :- 
                                                      champion_honor(Honor, Honor_Type),
                                                      champion_damage(Damage, Damage_Type),
                                                      champion_mixed_class(Class, Champion_Class),
                                                      champion_by_profile(Champions_Found, Experience, Damage, Honor, Class),
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

% Damage 1 - physical , 2 - magic, 3 - mixed
damage_types(physical, magic, mixed).
champion_damage(Damage_Selected, 1) :- damage_types(Damage_Selected, _, _).
champion_damage(Damage_Selected, 2) :- damage_types(_, Damage_Selected, _).
champion_damage(Damage_Selected, 3) :- damage_types(_, _, Damage_Selected).

% Physical Class  0- diver , 1- skimisher, 2- assassin, 3- marksman
physical_class(diver , skimisher, assassin, marksman).
champion_physical_class(Class_Selected, 0) :- physical_class(Class_Selected, _, _, _).
champion_physical_class(Class_Selected, 1) :- physical_class(_, Class_Selected, _, _).
champion_physical_class(Class_Selected, 2) :- physical_class(_, _, Class_Selected, _).
champion_physical_class(Class_Selected, 3) :- physical_class(_, _, _, Class_Selected).

% Mixed Class  0- diver , 1- skimisher, 2- assassin, 3- marksman
mixed_class(diver , skimisher, assassin, marksman).
champion_mixed_class(Class_Selected, 0) :- mixed_class(Class_Selected, _, _, _).
champion_mixed_class(Class_Selected, 1) :- mixed_class(_, Class_Selected, _, _).
champion_mixed_class(Class_Selected, 2) :- mixed_class(_, _, Class_Selected, _).
champion_mixed_class(Class_Selected, 3) :- mixed_class(_, _, _, Class_Selected).

champion_by_profile(Champions_Found, Experience, Damage_Type, Honor, Class) :- findall(
                                                                                  X,
                                                                                  champion(X, Class, Damage_Type, Experience, Honor),
                                                                                  Champions_Found
                                                                                ).
