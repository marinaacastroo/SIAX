// Agent me in project family.jcm  --  familia6 adaptado con aprendizaje

/* Reglas genericas de parentesco */

es_hermano_de(X,Y) :-
    es_padre_de(Z,X)
    & es_padre_de(Z,Y)
    & es_madre_de(W,X)
    & not es_madre_de(W,Y)
    & not X=Y.

es_hermano_de(X,Y) :-
    es_madre_de(Z,X)
    & es_madre_de(Z,Y)
    & es_padre_de(W,X)
    & not es_padre_de(W,Y)
    & not X=Y.

es_hermano_de(X,Y) :- 
    es_padre_de(Z,X)
    & es_padre_de(Z,Y)
    & es_madre_de(W,X)
    & es_madre_de(W,Y)
    & not X=Y.

/* Metas iniciales */
!start.

/* Planes */

// 1. Inicialización y registro de padres directos
+!start : .my_name(Me)
    <-  +yo(Me);
        // Cada agente registra a sus padres directos como sus primeros antepasados
        for ( es_padre_de(P, Me) ) { +antepasado_conocido(P) };
        for ( es_madre_de(M, Me) ) { +antepasado_conocido(M) };
        
        // Consultar únicamente a los progenitores directos
        !preguntar_progenitores;
        
        // Tiempo prudencial para que todos reciban y propaguen la información
        .wait(3000);
        !mostrar_resumen.

// 2. Protocolo de consulta selectiva hacia arriba (progenitores)
+!preguntar_progenitores : yo(Me)
    <-  for ( (es_padre_de(P, Me) | es_madre_de(P, Me)) ) {
            !consultar(P);
        }.

// Si ya fue consultado, se evita enviar mensajes redundantes
+!consultar(P) : ya_consultado(P)
    <-  .println("Evitando consulta redundante a: ", P).

// Si no ha sido consultado aún, se envía una petición para que pase sus antepasados
+!consultar(P) : yo(Me)
    <-  +ya_consultado(P);
        .println("Consultando antepasados a mi progenitor directo: ", P);
        .send(P, achieve, pasar_antepasados(Me)).

+!consultar(_).

// 3. Respuesta ante la petición de un descendiente
+!pasar_antepasados(Hijo) : yo(Me)
    <-  // El propio progenitor es un antepasado directo del solicitante
        .send(Hijo, tell, nuevo_antepasado(Me));
        // Y le transmite todos los antepasados que conozca en ese momento
        for ( antepasado_conocido(A) ) {
            .send(Hijo, tell, nuevo_antepasado(A))
        }.

// 4. APRENDIZAJE Y PROPAGACIÓN REACTIVA:
// Cuando se aprende un antepasado nuevo, se memoriza y se notifica a los hijos directos
+nuevo_antepasado(A)[source(S)] : yo(Me) & not antepasado_conocido(A) & A \== Me
    <-  +antepasado_conocido(A);
        .println("He aprendido un nuevo antepasado: ", A, " (gracias a ", S, ")");
        // Propagación hacia abajo: notificar a los hijos para que ellos también aprendan
        for ( (es_padre_de(Me, Hijo) | es_madre_de(Me, Hijo)) ) {
            .send(Hijo, tell, nuevo_antepasado(A));
        }.

// Descartar antepasados ya conocidos o a uno mismo
+nuevo_antepasado(_)
    <-  true.

// 5. Informe final
+!mostrar_resumen : yo(Me)
    <-  .setof(A, antepasado_conocido(A), Lista);
        .println(">>> RESUMEN [", Me, "] -> Antepasados conocidos: ", Lista).