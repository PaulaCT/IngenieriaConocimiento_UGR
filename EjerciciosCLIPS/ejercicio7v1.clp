;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;; EJERCICIO 7 V 1 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  Crea un trozo de código que calcule el máximo de los valores del campo Altura de los hechos del    ;
;  template Jugadores y que obtenga el nombre del jugador más alto.                                   ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  V 1 ) Para ello se crea un template JugadorMasAlto que irá actualizandose según se vayan           ;
;  añadiendo nuevos jugadores.                                                                        ;
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
;  (JugadorMasAlto <nombre> <altura>) almacena el nombre y la altura del jugador más alto.            ;
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

(deftemplate JugadorMasAlto
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
)

;;;;;;;;;; Hecho para comparar todos los jugadores ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(deftemplate Comparar
  (slot c
    (type SYMBOL)
    (allowed-symbols s n)
  )
  (slot nombre
    (type SYMBOL)
  )
  (slot altura
    (type INTEGER)
    (range 100 300)
    (default ?DERIVE)
  )
)

;;;;;;;;;; Inicialización ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(deffacts Inicio 
  (Continuar (s s))
  (JugadorMasAlto (nombre A) (altura 100))
  (Comparar (c s) (nombre A) (altura 100))
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;; Reglas del ejercicio 7 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  Reglas para añadir nuevos hecho y para mantener actualizados los hechos NumeroHechos.              ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;; Regla para añadir nuevos hechos ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule nuevo_jugador
  (declare (salience 0))
  ?f <- (Continuar (s s))
  ?g <- (Comparar (c s)(nombre ?)(altura ?))
  =>
  (retract ?f ?g)
  (printout t "Para salir introduzca null como nombre" crlf)
  (printout t "Nombre:            ")
  (bind ?n (read))
  (printout t "Altura en metros:  ")
  (bind ?a (read))
  (assert (Jugador (nombre ?n) (altura ?a)) (Continuar (s s)) 
  (Comparar (c n) (nombre ?n) (altura ?a)))
)

;;;;;;;;;; Reglas para ver si el nuevo jugador es el más alto ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule comparar_jugador_true
  (declare (salience 5))
  (not (Jugador (nombre null) (altura ?)))
  ?f <- (Continuar (s s))
  ?g <- (Comparar (c n)(nombre ?nc)(altura ?ac))
  ?h <- (JugadorMasAlto (nombre ?n) (altura ?a))
  (test (< ?ac ?a))
  =>
  (retract ?f ?g ?h)
  (assert (JugadorMasAlto (nombre ?n) (altura ?a)) (Continuar (s s)) (Comparar (c s) (nombre ?nc) (altura ?ac)))
)

(defrule comparar_jugador_false
  (declare (salience 5))
  (not (Jugador (nombre null) (altura ?)))
  ?f <- (Continuar (s s))
  ?g <- (Comparar (c n)(nombre ?nc)(altura ?ac))
  ?h <- (JugadorMasAlto (nombre ?n) (altura ?a))
  (test (> ?ac ?a))
  =>
  (retract ?f ?g ?h)
  (assert (JugadorMasAlto (nombre ?nc) (altura ?ac)) (Continuar (s s)) (Comparar (c s) (nombre ?nc) (altura ?ac)))
)

;;;;;;;;;; Reglas para salir ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule salir_voluntariamente
  (declare (salience 6))
  ?f <- (Continuar (s s))
  ?g <- (Jugador (nombre null) (altura ?))
  =>
  (retract ?f ?g)
  (printout t " "  crlf)
  (printout t "Buscando jugador mas alto..." crlf)
  (assert (Continuar (s n)))
)

;;;;;;;;;; Regla para buscar al jugador mas alto ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule jugador_mas_alto
  (declare (salience 6))
  ?f <- (Continuar (s n))
  (JugadorMasAlto (nombre ?n) (altura ?h))
  => 
  (retract ?f)
  (printout t "El jugador mas alto es " ?n " midiendo " ?h  crlf)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;