
/** <module> TicTacToe
 *
 *  Ce module permet de jouer au jeu de Tic-Tac-Toe
 *
 *  @author Mano Brabant
 */
:- module(jeu, []).


:- consult('../moteurJ2J/outils.pl').


%% initJeu
%
%  Ce prédicat permet d'initialiser la taille de la grille.
initJeu :-
  moteur:init(3, c).


%% profondeurMinMax(?Val:int)
%
% Ce predicat est satisfait quand la valeur Val correspond à la profondeur jusqu'à laquelle peut aller
% un algorithme minmax pour ce jeu.
profondeurMinMax(6).


%% leCoupEstValide(+Colonne:char, +Ligne:int, +Grille:Grille)
%
% Cette méthode permet de savoir si on peut jouer dans une case dans une grille donnée
%
% @param Colonne La colonne de la case à vérifier
% @param Ligne La ligne de la case à vérifier
% @param Grille La grille dans laquelle on vérifie la case
leCoupEstValide(_,C,L,G) :- moteur:caseVide(Cv), moteur:caseDeGrille(C,L,G,Cv).



%% leCoupEstValide(+Grille:Grille, +Case:Case)
%
% Cette méthode permet de savoir si on peut jouer dans une case dans une grille donnée
%
% @param Grille La grille dans laquelle on vérifié la case
% @param Case La case à vérifier
% @see [[leCoupEstValide/4]]
leCoupEstValide(_, G, CL) :- outils:coordonneesOuListe(Col, Lig, CL), leCoupEstValide(_, Col, Lig, G).



%% partieGagnee(+Val:char, +Grille:Grille)
%
% Cette méthode permet de savoir si une grille est gagnante pour un joueur
%
% @param Val La valeur à vérifier
% @param Grille La grille à vérifier
partieGagnee(Val, G) :- outils:grilleAvecLigneDeN(G, Val, 3, 3).



%% toutesLesCasesDepart(?ListeCases:list)
%
% Cette méthode permet de récupérer toutes les cases de départ
%
% @param ListeCases La liste des cases où l'on peut jouer
toutesLesCasesDepart(_, N) :- outils:listeNumLigne(L), outils:listeNomColonne(C), outils:combineListe(C, L, N).



%% grilleDeDepart(?Grille:Grille)
%
% Cette méthode permet de récupérer la grille de départ du jeu
%
% @param Grille La grille de départ
grilleDeDepart(G) :- moteur:size(SL, SCA), moteur:equiv(SCA, SC), moteur:caseVide(Cv),
	outils:replicate(Cv, SC, L), outils:replicate(L, SL, G).





%% terminal(+Joueur:any, +Grille:grille)
%
% Ce prédicat est satisfait si la Grille est une grille "terminale" pour le Joueur
%
% Un grille terminale est une grille dans laquelle un joueur spécifique ne peut pas jouer
%
% @param Joueur Le joueur que l'on vérifie pour la Grille
% @param Grille la grille que l'on vérifie pour le Joueur 
terminal(J, G) :- moteur:toutesLesCasesValides(J, G, LC), length(LC, L), L == 0.
terminal(_, G) :- partieGagnee(x, G).
terminal(_, G) :- partieGagnee(o, G).


%% eval(+Grille:grille, +Joueur:any, ?Eval:int)
%
% Ce prédicat permet d'évaluer une grille pour un joueur
%
% L'évaluation représente si le Joueur donnée à l'avantage ou non dans la Grille
%
% Plus la valeur Eval est grande plus la Grille est intéréssante pour le Joueur
%
% On utilise ce prédicat pour la fonction minmax
%
% @param Grille La grille à évaluer
% @param Joueur Le joueur pour lequelle on va évaluer la grille
% @param Eval Une valeur représentative de l'avantage du Joueur dans la Grille
%eval(G, J, _) :- moteur:afficheGrille(G), nl, write(J), nl, fail.
eval(G, J, -1000) :- moteur:campAdverse(J, J1), partieGagnee(J1, G), !.
eval(G, J, 1000) :- partieGagnee(J, G), !.

eval(G, J, -100) :- moteur:campAdverse(J, J1), outils:grilleAvecLigneDeN(G, J1, 3, 2), outils:grilleAvecLigneDeN(G, J, 3, 2).
eval(G, J, -200) :- moteur:campAdverse(J, J1), outils:grilleAvecLigneDeN(G, J1, 3, 2).
eval(G, J, 200) :- outils:grilleAvecLigneDeN(G, J, 3, 2).

eval(_,_,5) :- !.




%% consequencesCoupDansGrille(+Colonne:char, +Ligne:int, +Camp:any, +GrilleDep:grille, ?GrilleArr:grille)
%
% Ce prédicat est satisfait quand la GrilleArr est égale à la GrilleDep avec
% les conséquences d'avoir joué dans la case [Colonne, Ligne]
%
% Il n'y a pas de conséquences quand on joue un coup au Tic-Tac-Toe
%
% @param Colonne Le nom de la colonne dans laquelle on a joué
% @param Ligne Le numéro de la ligne dans laquelle on a joué
% @param Camp Le joueur qui a joué dans la grille
% @param GrilleDep La grille de jeu sans les conséquences du coup dans la case [Colonne, Ligne]
% @param GrilleArr La grille de jeu avec les conséquences du coup dans la case [Colonne, Ligne]
consequencesCoupDansGrille(_, _, _, GrilleArr, GrilleArr).


%% determineGagnant(+Grille:grille)
%
% Ce prédicat permet d'afficher qui à gagné dans une grille donnée
%
% @param Grille La grille que l'on vérifie
determineGagnant(G) :- partieGagnee(x, G), write('le camp '), write(x), write(' a gagne').
determineGagnant(G) :- partieGagnee(o, G), write('le camp '), write(o), write(' a gagne').
determineGagnant(_) :- nl, write('egalité').


%% saisieUnCoup(+Grille:Grille, ?NomColonne:char, ?NumLigne:int)
%
% Cette méthode permet de demander à l'utilisateur de saisir un coup
%
% @param Grille La grille dans laquelle le joueur va jouer son coup
% @param NomColonne Le nom de la colonne dans laquelle le joueur va jouer son coup
% @param NumLigne Le numéro de la ligne dans laquelle le joueur va jouer son coup
saisieUnCoup(_, NomCol,NumLig) :-
	write("entrez le nom de la colonne a jouer : "),
  outils:listeNomColonne(LNC),
  writeln(LNC),
	read(NomCol), nl,
	write("entrez le numero de ligne a jouer : "),
  outils:listeNumLigne(LNL),
  writeln(LNL),
	read(NumLig),nl.




% Les fonctions mortes au combat
% @deprecated

%% ligneFaite(+Val:char, +Ligne:list)
% @deprecated
% Ce prédicat est satisfait si toutes les valeur de la liste sont les mêmes
%
% @param Val La valeur dans la liste
% @param Ligne La ligne à vérifier
/*
ligneFaite(Val, [Val]).
ligneFaite(Val, [Val|R]) :- ligneFaite(Val, R).
*/

%% ligneGagnante(+Val:char, +Grille:Grille)
% @deprecated
%
% Cette méthode permet de savoir si une grille contient une ligne gagnante pour un joueur
%
% @param Val La valeur à vérifier
% @param Grille La grille à vérifier

/*
ligneGagnante(Val, [L1|_]) :- ligneFaite(Val, L1), !.
ligneGagnante(Val, [_|R]) :- ligneGagnante(Val, R).
*/

%% colonneGagnante(+Val:char, +Grille:Grille)
% @deprecated
%
% Cette méthode permet de savoir si une grille contient une colonne gagnante pour un joueur
%
% @param Val La valeur à vérifier
% @param Grille La grille à vérifier
/*
colonneGagnante(Val, L) :- outils:transpose(L, L1), ligneGagnante(Val, L1).
*/

%% diagonale(+Grille:Grille, ?NbElement:int, +Ligne:Ligne)
% @deprecated
%
% Cette méthode permet de récupérer une diagonale dans une grille donnée
%
% @param Grille La grille où l'on va récupérer une diagonale
% @param NbElemtn Le nombre d'éléments dans la diagonale
% @param Ligne La diagonale récupérée
/*
diagonale([], 0, []).
diagonale([L|LS], N, [V|R]) :- diagonale(LS, N1, R), N is N1 + 1, nth1(N, L, V).
*/

%% diagonaleGagnante(+Val:char, +Grille:Grille)
% @deprecated
%
% Cette méthode permet de savoir si une grille contient une diagonale gagnante pour un joueur
%
% @param Val La valeur à vérifier
% @param Grille La grille à vérifier
/*
diagonaleGagnante(Val, L) :- 									diagonale(L, _, D), ligneFaite(Val, D).
diagonaleGagnante(Val, L) :- reverse(L, L1), 	diagonale(L1, _, D), ligneFaite(Val, D).
*/


/*
listeLigne2([NL], NL) :- moteur:sizeLine(NL), !.
listeLigne2([N|L], N) :- moteur:succNum(N, V), listeLigne2(L, V).

%% listeLigne(?Lignes:list)
%
% Cette méthode permet de récupérer toutes les lignes du jeu
%
% @param Lignes La liste des numéros de ligne
listeLigne(L) :- listeLigne2(L, 1).



listeColonne2([NL], NL) :- moteur:sizeColumn(NL), !.
listeColonne2([N|L], N) :- moteur:succAlpha(N, V), listeColonne2(L, V).

%% listeColonne(?Colonnes:list)
%
% Cette méthode permet de récupérer toutes les colonnes du jeu
%
% @param Colonnes La liste des noms de colonne
listeColonne(L) :- listeColonne2(L, a).
*/


%% toutesLesCasesValides(+Grille:Grille, +ListeCoups:list, +Case:list, ?NouveauListeCoups:list)
%
% Cette méthode permet de récupérer touts les coups disponibles pour le prochain joueur
%
% @param Grille La grille dans laquelle on joue
% @param ListeCoups L'ancienne liste des coups
% @param Case La case ou l'on veut jouer
% @param NouveauListeCoups La nouvelle liste des coups
/*
toutesLesCasesValides(Grille, _, _, LC2) :-
	listeLigne(L), listeColonne(C), outils:combine(C, L, N),
  include(leCoupEstValide(Grille), N, LC2).
*/
