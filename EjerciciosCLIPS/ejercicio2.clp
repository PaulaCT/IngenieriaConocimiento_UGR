;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;; EJERCICIO 2 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  Crear un trozo de código que muestre al usuario un conjunto de opciones y recoja las elecciones    ;
;  del usuario añadiendo el hecho (OpcionElegida XXX), siendo XXX las etiquetas utilizadas para las   ;
;  opciones elegidas. Debe detectar errores en la entrada y volver a solicitar la elección en caso de ;
;  error.                                                                                             ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  REALIZADO POR: Paula Cumbreras Torrente                                                            ;
;  GRUPO: Prácticas Lunes (17:30 a 19:30)                                                             ;
;  GII UGR                                                                                            ;
;  CURSO 19-20                                                                                        ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(clear)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;; Hechos para la representación del ejercicio 2 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  (Menu <fin>) controla el fin de la selección de opciones.                                          ;
;  (OpcionElegida <etiqueta>) representa la opción elegida por el usuario.                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(deftemplate Menu
  (slot fin
    (type SYMBOL)
    (allowed-symbols S N)
  )
  (slot seleccionadas
    (type INTEGER)
    (default 0)
    (allowed-integers 0 1 2 3 4 5 6)
  )
)

(deftemplate OpcionElegida
  (slot etiqueta
    (type NUMBER)
    (default ?DERIVE)
  )
)

;;;;;;;;;; Inicialización ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(deffacts Inicio 
  (Menu (fin N))
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;; Reglas del ejercicio 2 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  Reglas para mostrar y seleccionar opciones, para controlar que no se produzca ningún error y       ;
;  las propias acciones de cada opción                                                                ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;; Reglas para mostrar el menú ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule mostrar_opciones
  (declare (salience 0))
  ?f <- (Menu (fin N) (seleccionadas ?k))
  =>
  (retract ?f)
  (printout t "Elija una opcion:"  crlf)
  (printout t "001 - Decir hola"  crlf)
  (printout t "002 - Decir adios"  crlf)
  (printout t "003 - Decir gracias"  crlf)
  (printout t "004 - Decir perdon"  crlf)
  (printout t "005 - Decir suerte"  crlf)
  (printout t "000 - Salir del menu y realizar acciones"  crlf)
  (assert (OpcionElegida (etiqueta (read))))
  (assert (Menu (fin N) (seleccionadas (+ ?k 1))))
)

;;;;;;;;;; Error: opción no válida ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule opcion_no_valida
  (declare (salience 3))
  ?g <- (Menu (fin N) (seleccionadas ?k))
  ?f <- (OpcionElegida (etiqueta ?n))
	(test (neq ?n 000))
  (test (neq ?n 001)) 
  (test (neq ?n 002)) 
  (test (neq ?n 003)) 
  (test (neq ?n 004)) 
  (test (neq ?n 005))
  =>
  (retract ?f ?g)
  (assert (Menu (fin N) (seleccionadas (- ?k 1))))
  (printout t "La opcion seleccionada no es valida"  crlf)
  (printout t " "  crlf)
)

;;;;;;;;;; Error: ninguna opción seleccionada ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule ninguna_opcion
  (declare (salience 3))
  ?g <- (Menu (fin N) (seleccionadas 1))
  ?f <- (OpcionElegida (etiqueta 000))
  =>
  (retract ?f ?g)
  (assert (Menu (fin N) (seleccionadas 0)))
  (printout t "Has elegido salir del menu pero no habias seleccionado ninguna opcion"  crlf)
  (printout t " "  crlf)
)

;;;;;;;;;; Regla para finalizar la selección ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule salir_menu
  (declare (salience 2))
  ?f <- (Menu (fin N) (seleccionadas ?k))
  (OpcionElegida (etiqueta 000))
  =>
  (retract ?f)
  (assert (Menu (fin S) (seleccionadas ?k)))
)

;;;;;;;;;; Primera opción ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule primera_opcion
  (declare (salience 8))
  (Menu (fin S) (seleccionadas ?))
  ?f <- (OpcionElegida (etiqueta 001))
  =>
  (retract ?f)
  (printout t "Hola"  crlf)
)

;;;;;;;;;; Segunda opción ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule segunda_opcion
  (declare (salience 7))
  (Menu (fin S) (seleccionadas ?))
  ?f <- (OpcionElegida (etiqueta 002))
  =>
  (retract ?f)
  (printout t "Adios"  crlf)
)

;;;;;;;;;; Tercera opción ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule tercera_opcion
  (declare (salience 6))
  (Menu (fin S) (seleccionadas ?))
  ?f <- (OpcionElegida (etiqueta 003))
  =>
  (retract ?f)
  (printout t "Gracias"  crlf)
)

;;;;;;;;;; Cuarta opción ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule cuarta_opcion
  (declare (salience 5))
  (Menu (fin S) (seleccionadas ?))
  ?f <- (OpcionElegida (etiqueta 004))
  =>
  (retract ?f)
  (printout t "Perdon"  crlf)
)

;;;;;;;;;; Quinta opción ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule quinta_opcion
  (declare (salience 4))
  (Menu (fin S) (seleccionadas ?))
  ?f <- (OpcionElegida (etiqueta 005))
  =>
  (retract ?f)
  (printout t "Suerte"  crlf)
)

;;;;;;;;;; Última acción ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule finalizar
  (declare (salience 3))
  (Menu (fin S) (seleccionadas ?k))
  ?f <- (OpcionElegida (etiqueta 000))
  =>
  (retract ?f)
  (printout t "Se han realizado todas las acciones"  crlf)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;