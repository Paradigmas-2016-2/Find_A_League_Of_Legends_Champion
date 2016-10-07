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
champion("kog'maw", marksman, mixed, 2, strength).
champion(graves, marksman, physical, 2, strength).
champion(jhin, marksman, physical, 2, strength).
champion(jinx, marksman, physical, 2, strength).
champion(caitlyin, marksman, physical, 1, justice).
champion(ashe, marksman, physical, 1, justice).
champion(corki, marksman, mixed, 2, justice).
champion(kalista, marksman, physical, 3, strength).
champion(draven, marksman, physical, 3, strength).
champion(ezreal, marksman, mixed, 1, justice).
champion(sivir, marksman, physical, 2, justice).

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
champion(skarner, vanguard, mixed, 1, neutral).
champion(shyvana, juggernaut, physical, 1, justice).
champion(sejuani, vanguard, magic, 2, justice).
champion(rengar, assassin, physical, 2, strength).
champion("kha'zix", assassin, physical, 2, strength).

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
champion(alistar, warden, magic, 1, justice).
champion(diana, diver, magic, 1, strength).
champion(hecarim, diver, physical, 2, strength).
champion(gragas, vanguard, magic, 2, justice).
champion(morgana, 'disrupt(controller)', magic, 1, strength).
champion(zyra, 'disrupt(controller)', magic, 2, strength).

% mid
champion(kayle, marksman, mixed, 2, justice).
champion(ahri, burst, magic, 2, justice).
champion(anivia, disrupt, magic, 3, justice).
champion(ziggs, artillary, magic, 2, strength).
champion(annie, burst, magic, 1, neutral).
champion(katarina, assassin, magic, 1, strength).
champion(veigar, burst, magic, 2, strength).
champion(swain, battlemage, magic, 2, strength).
champion(yasuo, assassin, physical, 3, justice).
champion(ryze, battlemage, magic, 2, justice).
champion(lulu, enchanter, magic, 2, neutral).
champion(akali, assassin, mixed, 2, justice).
champion(malzahar, battlemage, magic, 1, strength).
champion(lux, burst, magic, 1, justice).
champion(orianna, disrupt, magic, 2, justice).
champion(karthus, battlemage, magic, 2, strength).
champion(heimerdinger, disrupt, magic, 2, neutral).

%top
champion(garen, juggernaut, physical, 1, justice).
champion(jax, skimisher, mixed, 2, strength).
champion('dr. mundo', juggernaut, mixed, 2, strength).
champion(tryndamere, skimisher, physical, 1, justice).
champion(yorick, juggernaut, mixed, 2, strength).
champion(illaoi, juggernaut, physical, 2, strength).
champion(riven, skimisher, physical, 2, justice).
champion(shen, 'warden(top)', mixed, 2, justice).
champion(malphite, 'vanguard(top)', magic, 1, justice).
champion(maokai, 'warden(top)', magic, 1, justice).
champion(sion, 'vanguard(top)', physical, 1, strength).
champion(aatrox, diver, mixed, 2, strength).
champion(renekton, diver, physical, 1, strength).
champion(jayce, skimisher, physical, 2, neutral).
champion(irellia, diver, physical, 2, justice).






play :- write('Welcome to summoner\'s rift '), nl, nl, nl,
  write('We\'ll try to find the perfect champion for you.'), nl,
  write('First,\nHow experienced are you with league of legends?'), nl,
  write('1 - Beginner\n2 - Average\n3 - Experienced'), nl,
  read(Alternative),
  profile:set(1, [experience(Alternative)]), nl, nl, nl,
  next_step_honor(1).

%----------------------%
% next_step_exp(1) :- write('What is your type of game?'), nl,
%                     write('1 - Damagier, 2 - Helper, 3 - Tank'), nl,
%                     read(Alternative),
%                     next_step_type(1).

%----------------------%

next_step_honor(1) :- write('What kind of honor you prefer?'), nl,
                   write('1 - Justice\n2 - Strength\n3 - Neutral'), nl,
                   read(Alternative),
                   profile:set(1, [honor_type(Alternative)]), nl, nl, nl,
                   next_step_type_champion(1).


 next_step_type_champion(1) :- write('What kind of style game you prefer?'), nl,
                    write('1 - Damage(responsible for providing the majority damage)\n2 - Control(responsible for suport all team)\n3 - Tank(responsible for receiving the majority damage)'), nl,
                    read(Alternative),
                    profile:set(1, [champion_type(Alternative)]), nl, nl, nl,
                    champion_type_selected(Alternative).

champion_type_selected(1) :- next_step_type_damage(1).
champion_type_selected(2) :- next_step_controler_style(1).
champion_type_selected(3) :- next_step_tank_style(1).

%----------- damage section -----------%
next_step_type_damage(1) :- write('How would you like to face your enemies?'), nl,
                     write('1 - Physical damage\n2 - Magical damage\n3 - Mixed damage'), nl,
                     read(Alternative),
                     profile:set(1, [damage_type(Alternative)]), nl, nl, nl,
                     choice_damage(Alternative).


choice_damage(1) :- next_step_physical_resistence(1).
choice_damage(2) :- next_step_magical_resistence(1).
choice_damage(3) :- next_step_mixed_resistence(1).

next_step_physical_resistence(1) :- write('How would you prefer?'), nl,
                     write('1 - Physical damage with resistence\n2 - Physical damage squishy'), nl,
                     read(Alternative),
                     choice_resistence(Alternative).

choice_resistence(1) :- profile:set(1, [champion_class(0)]), nl, nl, nl,
                        analyze_profile_damagier(1).
choice_resistence(2) :- next_step_range(1).


next_step_range(1) :- write('How would prefer?'), nl,
                     write('1 - Melee\n2 - Long Distance'), nl,
                     read(Alternative),
                     choice_range(Alternative).

choice_range(1) :- next_step_escape(1).
choice_range(2) :- profile:set(1, [champion_class(3)]), nl, nl, nl,
                          analyze_profile_damagier(1).


next_step_escape(1) :- write('How would prefer?'), nl,
                     write('1 - Melee without escape, and high durability in fight\n2 - Melee with escape, but one focus'), nl,
                     read(Alternative),
                     profile:set(1, [champion_class(Alternative)]), nl, nl, nl,
                     analyze_profile_damagier(1).



next_step_mixed_resistence(1) :- write('And how would you prefer?'), nl,
                     write('1 - Mixed damage with resistence\n2 - Mixed damage squishy'), nl,
                     read(Alternative),
                     choice_resistence(Alternative).



next_step_magical_resistence(1) :- write('And how would you prefer?'), nl,
                           write('1 - Magical damage with resistence\n2 - Magical damage squishy'), nl,
                           read(Alternative),
                           choice_resistence_magical(Alternative).

choice_resistence_magical(1) :- profile:set(1, [champion_class(0)]), nl, nl, nl,
                              analyze_profile_damagier(1).
choice_resistence_magical(2) :- next_step_magical_style(1).

next_step_magical_style(1) :- write('And how would you prefer?'), nl,
                       write('1 - High damage in shortly time\n2 - Medium damage that weakens the enemy gradually\n3 - High damage and high mobility, but in one target\n4 - High damage but no mobility, only in safe mode'), nl,
                       read(Alternative),
                       profile:set(1, [champion_class(Alternative)]), nl, nl, nl,
                       analyze_profile_damagier(1).

%----------- damage section -----------%




%----------- control section -----------%

next_step_controler_style(1) :- write('Ohh! You are a rare player in League of Legends!'), nl,
                     write('How would you like to play the game?'), nl,
                     write('1 - Stay behind of the allies\n2 - Stay in front of the allies'), nl,
                     read(Alternative),
                     profile:set(1, [controller_style(Alternative)]), nl, nl, nl,
                     next_step_controller_type(Alternative).


next_step_controller_type(1) :- write('How would you like your support be?'), nl,
                    write('1 - Amplifying allies\n2 - Stop enemies attacks, and apply damage to enemies'), nl,
                    read(Alternative),
                    profile:set(1, [champion_class(Alternative)]), nl, nl, nl,
                    analyze_profile_controller(1).

next_step_controller_type(2) :- write('How would you like your support be?'), nl,
                    write('1 - Protecting the team\n2 - Starting the fight'), nl,
                    read(Alternative),
                    profile:set(1, [champion_class(Alternative)]), nl, nl, nl,
                    analyze_profile_controller(1).
%----------- control section -----------%


%------------- tank section ------------%

next_step_tank_style(1) :- write('How would you like to play the game?'), nl,
                     write('1 - High health, and resistence, but low damage\n2 - Medium health, and medium resistence, but medium damage'), nl,
                     read(Alternative),
                     profile:set(1, [controller_style(Alternative)]), nl, nl, nl,
                     next_step_tank_type(Alternative).



next_step_tank_type(1) :- write('How would you like your tank be?'), nl,
                    write('1 - Protecting the team\n2 - Starting the fight'), nl,
                    read(Alternative),
                    profile:set(1, [champion_class(Alternative)]), nl, nl, nl,
                    analyze_profile_tank(1).

next_step_tank_type(2) :- profile:set(1, [champion_class(0)]), nl, nl, nl,
                    analyze_profile_tank(1).
%------------- tank section ------------%


% Exemplo de como achar um champion baseado nas respostas


%----------- damagier champions search section -----------%

analyze_profile_damagier(1) :- profile(1, experience(Experience)),
                            profile(1, damage_type(Damage_Type)),
                            profile(1, honor_type(Honor_Type)),
                            profile(1, champion_class(Champion_Class)),
                            find_champion_option_damagier(Experience, Damage_Type, Honor_Type, Champion_Class).

find_champion_option_damagier(Experience, 1, Honor_Type, Champion_Class) :- find_champion_physical(Experience, 1, Honor_Type, Champion_Class).
find_champion_option_damagier(Experience, 2, Honor_Type, Champion_Class) :- find_champion_magical(Experience, 2, Honor_Type, Champion_Class).
find_champion_option_damagier(Experience, 3, Honor_Type, Champion_Class) :- find_champion_mixed(Experience, 3, Honor_Type, Champion_Class).
find_champion_physical(Experience, Damage_Type, Honor_Type, Champion_Class) :-
																											champion_honor(Honor, Honor_Type),
                                                      champion_damage(Damage, Damage_Type),
																											champion_physical_class(Class, Champion_Class),
                                                      champion_by_profile_damage(Champions_Found, Experience, Damage, Honor, Class),
                                                      length(Champions_Found, Champions_Found_Length),
                                                      write_champion(Champions_Found_Length, Champions_Found).


find_champion_mixed(Experience, Damage_Type, Honor_Type, Champion_Class) :-
                                                      champion_honor(Honor, Honor_Type),
                                                      champion_damage(Damage, Damage_Type),
                                                      champion_mixed_class(Class, Champion_Class),
                                                      champion_by_profile_damage(Champions_Found, Experience, Damage, Honor, Class),
                                                      length(Champions_Found, Champions_Found_Length),
                                                      write_champion(Champions_Found_Length, Champions_Found).



find_champion_magical(Experience, Damage_Type, Honor_Type, Champion_Class) :-
                                                      champion_honor(Honor, Honor_Type),
                                                      champion_damage(Damage, Damage_Type),
                                                      champion_magical_class(Class, Champion_Class),
                                                      champion_by_profile_damage(Champions_Found, Experience, Damage, Honor, Class),
                                                      length(Champions_Found, Champions_Found_Length),
                                                      write_champion(Champions_Found_Length, Champions_Found).

%----------- damagier champions search section -----------%



%---------- controller champions search section ----------%
analyze_profile_controller(1) :- profile(1, experience(Experience)),
                            profile(1, honor_type(Honor_Type)),
                              profile(1, controller_style(Controller_Style)),
                            profile(1, champion_class(Champion_Class)),
                            find_champion_option_controller(Experience, Honor_Type, Controller_Style, Champion_Class).

find_champion_option_controller(Experience, Honor_Type, 1, 1) :- find_champion_controller_behind(Experience, Honor_Type, 1).
find_champion_option_controller(Experience, Honor_Type, 1, 2) :- find_champion_controller_behind(Experience, Honor_Type, 2).
find_champion_option_controller(Experience, Honor_Type, 2, 1) :- find_champion_controller_front(Experience, Honor_Type, 1).
find_champion_option_controller(Experience, Honor_Type, 2, 2) :- find_champion_controller_front(Experience, Honor_Type, 2).

find_champion_controller_behind(Experience, Honor_Type, Champion_Class) :-
                                                      champion_honor(Honor, Honor_Type),
                                                      champion_behind_controller(Class, Champion_Class),
                                                      champion_by_profile_controller(Champions_Found, Experience, Honor, Class),
                                                      length(Champions_Found, Champions_Found_Length),
                                                      write_champion(Champions_Found_Length, Champions_Found).

find_champion_controller_front(Experience, Honor_Type, Champion_Class) :-
                                                      champion_honor(Honor, Honor_Type),
                                                      champion_front_controller(Class, Champion_Class),
                                                      champion_by_profile_controller(Champions_Found, Experience, Honor, Class),
                                                      length(Champions_Found, Champions_Found_Length),
                                                      write_champion(Champions_Found_Length, Champions_Found).

%---------- controller champions search section ----------%


%---------- tank champions search section ----------%

analyze_profile_tank(1) :- profile(1, experience(Experience)),
                            profile(1, honor_type(Honor_Type)),
                            profile(1, champion_class(Champion_Class)),
                            find_champion_option_tank(Experience, Honor_Type, Champion_Class).

find_champion_option_tank(Experience, Honor_Type, 0) :- find_champion_tank_juggernaut(Experience, Honor_Type, 0).
find_champion_option_tank(Experience, Honor_Type, 1) :- find_champion_tank_protect(Experience, Honor_Type, 1).
find_champion_option_tank(Experience, Honor_Type, 2) :- find_champion_tank_starter(Experience, Honor_Type, 2).

find_champion_tank_juggernaut(Experience, Honor_Type, Champion_Class) :-
                                                      champion_honor(Honor, Honor_Type),
                                                      champion_tank_juggernaut_class(Class, Champion_Class),
                                                      champion_by_profile_tank(Champions_Found, Experience, Honor, Class),
                                                      length(Champions_Found, Champions_Found_Length),
                                                      write_champion(Champions_Found_Length, Champions_Found).

find_champion_tank_protect(Experience, Honor_Type, Champion_Class) :-
                                                      champion_honor(Honor, Honor_Type),
                                                      champion_tank_protect_class(Class, Champion_Class),
                                                      champion_by_profile_tank(Champions_Found, Experience, Honor, Class),
                                                      length(Champions_Found, Champions_Found_Length),
                                                      write_champion(Champions_Found_Length, Champions_Found).

find_champion_tank_starter(Experience, Honor_Type, Champion_Class) :-
                                                      champion_honor(Honor, Honor_Type),
                                                      champion_tank_starter_class(Class, Champion_Class),
                                                      champion_by_profile_tank(Champions_Found, Experience, Honor, Class),
                                                      length(Champions_Found, Champions_Found_Length),
                                                      write_champion(Champions_Found_Length, Champions_Found).

%---------- tank champions search section ----------%






write_champion(0, _) :- write('Sorry :/, we could not find a champion for you'),nl,nl,nl,
                     write('We starting again'),nl,nl,nl,nl,
                     play().
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

% Mixed Class  0- diver , 1- skimisher, 2- assassin, 3- marksman
magical_class(battlemage , burst, artillary, assassin, disrupt).
champion_magical_class(Class_Selected, 0) :- magical_class(Class_Selected, _, _, _, _).
champion_magical_class(Class_Selected, 1) :- magical_class(_, Class_Selected, _, _, _).
champion_magical_class(Class_Selected, 2) :- magical_class(_, _, Class_Selected, _, _).
champion_magical_class(Class_Selected, 3) :- magical_class(_, _, _, Class_Selected, _).
champion_magical_class(Class_Selected, 4) :- magical_class(_, _, _, _, Class_Selected).

behind_controller_class(enchanter, 'disrupt(controller)').
front_controller_class(warden, vanguard).
champion_behind_controller(Class_Selected, 1) :- behind_controller_class(Class_Selected, _).
champion_behind_controller(Class_Selected, 2) :- behind_controller_class(_, Class_Selected).
champion_front_controller(Class_Selected, 1) :- front_controller_class(Class_Selected, _).
champion_front_controller(Class_Selected, 2) :- front_controller_class(_, Class_Selected).

tank_class(juggernaut, 'warden(top)', 'vanguard(top)').
champion_tank_juggernaut_class(Class_Selected, 0) :- tank_class(Class_Selected, _, _).
champion_tank_protect_class(Class_Selected, 1) :- tank_class(_, Class_Selected, _).
champion_tank_starter_class(Class_Selected, 2) :- tank_class(_, _, Class_Selected).

champion_by_profile_damage(Champions_Found, Experience, Damage_Type, Honor, Class) :- findall(
                                                                                  X,
                                                                                  champion(X, Class, Damage_Type, Experience, Honor),
                                                                                  Champions_Found
                                                                                ).
champion_by_profile_controller(Champions_Found, Experience, Honor, Class) :- findall(
                                                                                  X,
                                                                                  champion(X, Class, _, Experience, Honor),
                                                                                  Champions_Found
                                                                                ).

champion_by_profile_tank(Champions_Found, Experience, Honor, Class) :- findall(
                                                                                  X,
                                                                                  champion(X, Class, _, Experience, Honor),
                                                                                  Champions_Found
                                                                                ).
