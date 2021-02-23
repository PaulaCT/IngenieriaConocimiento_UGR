;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;; EJERCICIO 7 V 2 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  Crea un trozo de código que calcule el máximo de los valores del campo Altura de los hechos del    ;
;  template Jugadores y que obtenga el nombre del jugador más alto.                                   ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  V 2 ) Para ello, una vez se han añadido todos los jugadores, se realiza una regla de las 5         ;
;  definidas para comparar las alturas de los jugadores. En esta versión solo se aceptan 5 jugadores. ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  REALIZADO POR: Paula Cumbreras Torrente                                                            ;
;  GRUPO: Prácticas Lunes (17:30 a 19:30)                                                             ;
;  GII UGR                                                                                            ;
;  CURSO 19-20                                                                                        ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(clear)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;; Hechos para la representación del ejercicio 7 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  (Jugador <nombre> <altura>) almacena el nombre y la altura de un jugador.                          ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(deftemplate Jugador
  (slot nombre
    (type SYMBOL)
  )
  (slot altura
    (type INTEGER)
    (range 100 300)
    (default ?DERIVE)
  )
)

;;;;;;;;;; Hecho para seguir añadiendo jugadores ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(deftemplate Continuar
  (slot s
    (type SYMBOL)
    (allowed-symbols s n)
  )
  (slot n
    (type INTEGER)
    (default 0)
    (range 0 5)
  )
)

;;;;;;;;;; Inicialización ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(deffacts Inicio 
  (Continuar (s s) (n 0))
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;; Reglas del ejercicio 7 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  Reglas para añadir un máximo de 5 jugadores y para devolver los datos de aquel con mayor altura    ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;; Regla para añadir nuevos jugadores ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule nuevo_jugador
  (declare (salience 0))
  ?f <- (Continuar (s s) (n ?j))
  =>
  (retract ?f)
  (printout t "Para salir introduzca null como nombre" crlf)
  (printout t "Nombre:        ")
  (bind ?n (read))
  (printout t "Altura en cm:  ")
  (bind ?a (read))
  (assert (Jugador (nombre ?n) (altura ?a)) (Continuar (s s) (n (+ ?j 1))))
)

;;;;;;;;;; Reglas para salir ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule salir_voluntariamente
  (declare (salience 5))
  ?f <- (Continuar (s s) (n ?n))
  ?g <- (Jugador (nombre null) (altura ?))
  =>
  (retract ?f ?g)
  (printout t " "  crlf)
  (printout t "Buscando jugador mas alto..." crlf)
  (assert (Continuar (s n) (n (- ?n 1))))
)

(defrule salir
  (declare (salience 5))
  ?f <- (Continuar (s s) (n 5))
  =>
  (retract ?f)
  (printout t " "  crlf)
  (printout t "Buscando jugador mas alto..." crlf)
  (assert (Continuar (s n) (n 5)))
)


;;;;;;;;;; Regla para buscar al jugador mas alto ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule un_jugador
  (declare (salience 6))
  ?f <- (Continuar (s n) (n 1))
  (Jugador (nombre ?n) (altura ?h))
  => 
  (retract ?f)
  (printout t "El jugador mas alto es " ?n " midiendo " ?h  crlf)
)

(defrule dos_jugadores
  (declare (salience 6))
  ?f <- (Continuar (s n) (n 2))
  (Jugador (nombre ?n) (altura ?h))
  (Jugador (nombre ?) (altura ?h2))
  (test (> ?h ?h2))
  => 
  (retract ?f)
  (printout t "El jugador mas alto es " ?n " midiendo " ?h  crlf)
)

(defrule tres_jugadores
  (declare (salience 6))
  ?f <- (Continuar (s n) (n 3))
  (Jugador (nombre ?n) (altura ?h))
  (Jugador (nombre ?) (altura ?h2))
  (Jugador (nombre ?) (altura ?h3))
  (test (neq ?h2 ?h3))
  (test (> ?h ?h2))
  (test (> ?h ?h3))
  => 
  (retract ?f)
  (printout t "El jugador mas alto es " ?n " midiendo " ?h  crlf)
)

(defrule cuatro_jugadores
  (declare (salience 6))
  ?f <- (Continuar (s n) (n 4))
  (Jugador (nombre ?n) (altura ?h))
  (Jugador (nombre ?) (altura ?h2))
  (Jugador (nombre ?) (altura ?h3))
  (Jugador (nombre ?) (altura ?h4))
  (test (neq ?h2 ?h3))
  (test (neq ?h2 ?h4))
  (test (> ?h ?h2))
  (test (> ?h3 ?h4))
  (test (> ?h ?h3))
  => 
  (retract ?f)
  (printout t "El jugador mas alto es " ?n " midiendo " ?h  crlf)
)

(defrule cinco_jugadores
  (declare (salience 6))
  ?f <- (Continuar (s n) (n 5))
  (Jugador (nombre ?n) (altura ?h))
  (Jugador (nombre ?) (altura ?h2))
  (Jugador (nombre ?) (altura ?h3))
  (Jugador (nombre ?) (altura ?h4))
  (Jugador (nombre ?) (altura ?h5))
  (test (neq ?h2 ?h3))
  (test (neq ?h2 ?h4))
  (test (neq ?h2 ?h5))
  (test (> ?h ?h2))
  (test (> ?h3 ?h4))
  (test (> ?h5 ?h3))
  (test (> ?h ?h5))
  => 
  (retract ?f)
  (printout t "El jugador mas alto es " ?n " midiendo " ?h  crlf)
)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;