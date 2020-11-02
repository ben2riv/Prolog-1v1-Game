:- consult('../moteurJ2J/moteur.pl'), consult('../moteurJ2J/outils.pl').

%%%%%%%%%%%%%%%%% Coups autorisés %%%%%%%%%%%%%%%%%

% Predicat : leCoupEstValide/3
leCoupEstValide(C,L,G) :- caseVide(Cv), caseDeGrille(C,L,G,Cv), succNum(L, L2), caseDeGrille(C,L2,G,Cv2), \+ caseVide(Cv2).
leCoupEstValide(C,L,G) :- caseVide(Cv), caseDeGrille(C,L,G,Cv), \+ succNum(L, _).


% Predicat : leCoupEstValide/2
leCoupEstValide(G, CL) :- 	coordonneesOuListe(Col, Lig, CL), leCoupEstValide(Col, Lig, G).

%%%%%%%%%%%%%%%%% Moteur et règles %%%%%%%%%%%%%%%%%


% Predicat : ligneFaite/2
ligneDeN(Val, [Val|_], 0) :- !.
ligneDeN(Val, [Val|R], N) :- N1 is N - 1, ligneDeN(Val, R, N1).

ligneDe4(_, []).
ligneDe4(Val, L) :- ligneDeN(Val, L, 4).
ligneDe4(Val, [Val|R]) :- ligneDe4(Val, R).


% Predicat : ligneGagnante/3
% ?- ligneGagnante(x,[[x,-,x],[x,x,x],[-,o,-]],V).
% V = 2 ;

ligneGagnante(Val, [L1|_]) :- ligneDe4(Val, L1), !.



% Predicat : ligneFaite/2
colonneFaite(Val, [[Val|_]]) :- !.
colonneFaite(Val, [[Val|_]| R]) :- colonneFaite(Val, R).

% Predicat : colonneGagnante/3
colonneGagnante(Val, L) :- transpose(L, L1), ligneGagnante(Val, L1).


% Predicats diagonaleDG/2 et diagonaleGD/2
diagonale([], 0, []).
diagonale([L|LS], N, [V|R]) :- diagonale(LS, N1, R), N is N1 + 1, nth1(N, L, V).

diagonaleGagnante(Val, L) :- diagonale(L, _, D), ligneFaite(Val, D).
diagonaleGagnante(Val, L) :- reverse(L, L1), diagonale(L1, _, D), ligneFaite(Val, D).


% Predicat partieGagnee/2
partieGagnee(Val, G) :- ligneGagnante(Val, G).
partieGagnee(Val, G) :- colonneGagnante(Val, G).
partieGagnee(Val, G) :- diagonaleGagnante(Val, G).






toutesLesCasesDepart(N) :- listeColonne(C), combine(C, [6], N).

listeLigne2([NL], NL) :- sizeLine(NL), !.
listeLigne2([N|L], N) :- succNum(N, V), listeLigne2(L, V).

listeLigne(L) :- listeLigne2(L, 1).


listeColonne2([NL], NL) :- sizeColumn(NL), !.
listeColonne2([N|L], N) :- succAlpha(N, V), listeColonne2(L, V).

listeColonne(L) :- listeColonne2(L, a).


grilleDeDepart(G) :- size(SL, SCA), equiv(SCA, SC), replicate(-, SC, L), replicate(L, SL, G).




% toutesLesCasesValides(Grille, LC1, C, LC2).
% Se verifie si l'on peut jouer dans la case C de Grille et que la liste
% LC1 est une liste composee de toutes les cases de LC2 et de C.
% Permet de dire si la case C est une case ou l'on peut jouer, en evitant
% de jouer deux fois dans la meme case.
%toutesLesCasesValides(Grille, LC1, C, LC2) :-
%	coordonneesOuListe(Col, Lig, C),
%	leCoupEstValide(Col, Lig, Grille),
%	duneListeALautre(LC1, C, LC2).


% toutesLesCasesValides(Grille, LC1, C, LC2).
% Se verifie si l'on peut jouer dans la case C de Grille et que la liste
% LC1 est une liste composee de toutes les cases de LC2 et de C.
% Permet de dire si la case C est une case ou l'on peut jouer, en evitant
% de jouer deux fois dans la meme case.
toutesLesCasesValides(Grille, _, _, LC2) :-
	listeLigne(L), listeColonne(C), combine(C, L, N),
  include(leCoupEstValide(Grille), N, LC2).





saisieUnCoup(NomCol,NumLig) :-
	writeln("entrez le nom de la colonne a jouer (a,b,c) :"),
	read(NomCol), nl,
	writeln("entrez le numero de ligne a jouer (1, 2 ou 3) :"),
	read(NumLig),nl.


%% lanceJeu()
%  lanceJeu permet de lancer une partie de tic tac toe.
lanceJeu:-
  init(6, g),                          %spécifique
  grilleDeDepart(G),                   %spécifique
	toutesLesCasesDepart(ListeCoups),    %spécifique
	afficheGrille(G),nl,                 %général
   writeln("L ordinateur est les x et vous etes les o."),
   writeln("Quel camp doit debuter la partie ? "),read(Camp),
	moteur(G,ListeCoups,Camp).           %général
