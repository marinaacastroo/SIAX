/* Initial beliefs */

yo(Me) :- .my_name(Me).

/* Initial goals */

!start.

/* Plans */

+!start <-
    .println("Hola, soy ", Me).

/* Agent */

+!start <-
    .print("Hola, soy ", yo);
    .println("").