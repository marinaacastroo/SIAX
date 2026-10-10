// Agent eve

/* Conocimiento de Eve */

yo(eve).

// Erik es progenitor genético de Eve
es_progenitor_genetico_de(erik,eve).

// July es la persona gestante de Eve
es_gestante_de(july,eve).

// July también puede ser progenitora legal en este ejemplo
es_progenitor_legal_de(july,eve).

// Los progenitores genéticos y legales forman parte
// de la relación general de progenitor
es_progenitor_de(X,Y) :-
    es_progenitor_genetico_de(X,Y).

es_progenitor_de(X,Y) :-
    es_progenitor_legal_de(X,Y).

/* Objetivo inicial */

!start.

/* Plan */

+!start <-
    .println("Hola, soy ", eve);
    .findall(X, es_progenitor_de(X,eve), L);
    .println("Mis progenitores son: ", L);
    .findall(X, es_gestante_de(X,eve), G);
    .println("Persona gestante: ", G).