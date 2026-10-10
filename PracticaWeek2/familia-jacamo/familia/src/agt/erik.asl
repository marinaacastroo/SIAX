yo(erik).

es_progenitor_genetico_de(fred,erik).
es_adoptante_de(liz,erik).

// Erik sabe que Fred también es progenitor de Tom
es_progenitor_genetico_de(fred,tom).

es_progenitor_legal_de(X,Y) :-
    es_adoptante_de(X,Y).

es_progenitor_de(X,Y) :-
    es_progenitor_genetico_de(X,Y).

es_progenitor_de(X,Y) :-
    es_progenitor_legal_de(X,Y).

es_hermano_de(X,Y) :-
    es_progenitor_de(Z,X)
    & es_progenitor_de(Z,Y)
    & not X=Y.

!start.

+!start <-
    .println("Hola, soy ", erik);
    .findall(X, es_progenitor_de(X,erik), L);
    .println("Mis progenitores son: ", L);
    .findall(X, es_hermano_de(X,erik), H);
    .println("Mis hermanos son: ", H).

+pregunta_tom[source(Tom)] <-
    .println("Erik ha recibido una pregunta de ", Tom);
    .findall(X, es_progenitor_de(X,erik), L);
    .println("Erik responde a ", Tom, ": ", L);
    .send(Tom,tell,progenitores_erik(L)).