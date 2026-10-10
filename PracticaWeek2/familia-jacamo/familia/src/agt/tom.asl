// Agent tom

/* Conocimiento de Tom */

yo(tom).

// Progenitores de Tom
es_progenitor_genetico_de(fred,tom).
es_progenitor_legal_de(liz,tom).

// Tom conoce que John es progenitor de Fred
es_progenitor_genetico_de(john,fred).

/* Reglas de progenitor */

es_progenitor_de(X,Y) :-
    es_progenitor_genetico_de(X,Y).

es_progenitor_de(X,Y) :-
    es_progenitor_legal_de(X,Y).

/* Hermanos */

es_hermano_de(X,Y) :-
    es_progenitor_de(Z,X)
    & es_progenitor_de(Z,Y)
    & not X=Y.

/* Antepasados */

es_antepasado_directo_de(X,Y) :-
    es_progenitor_de(X,Y).

es_antepasado_de(X,Y) :-
    es_antepasado_directo_de(X,Y).

es_antepasado_de(X,Y) :-
    es_progenitor_de(X,Z)
    & es_antepasado_de(Z,Y).

/* Descendientes */

es_descendiente_de(X,Y) :-
    es_antepasado_de(Y,X).

/* Parientes */

es_pariente_de(X,Y) :-
    es_hermano_de(X,Y)
    & not X=Y.

es_pariente_de(X,Y) :-
    es_antepasado_de(X,Y)
    & not X=Y.

es_pariente_de(X,Y) :-
    es_descendiente_de(X,Y)
    & not X=Y.

/* Objetivo inicial */

!start.

/* Plan inicial */

+!start <-
    .println("Hola, soy ", tom);
    .findall(X, es_progenitor_de(X,tom), L);
    .println("Mis progenitores son: ", L);
    .findall(X, es_hermano_de(X,tom), H);
    .println("Mis hermanos son: ", H);
    .findall(X, es_antepasado_de(X,tom), A);
    .println("Mis antepasados son: ", A);
    .findall(X, es_descendiente_de(X,fred), D);
    .println("Descendientes de Fred: ", D);
    .findall(X, es_pariente_de(X,tom), P);
    .println("Mis parientes son: ", P);
    .send(erik,tell,pregunta_tom).

/* Respuesta recibida de Erik */

+progenitores_erik(L)[source(Erik)] <-
    .println("Tom ha recibido de ", Erik, " los progenitores de Erik: ", L);
    +progenitores_conocidos(Erik,L);
    .println("Hermanos descubiertos mediante comunicacion: ", Erik).