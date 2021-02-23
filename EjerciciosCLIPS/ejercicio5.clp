;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;; EJERCICIO 5 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  Crea un trozo de código que el hecho (NumeroHechos XXX n), siendo n el número de hechos del tipo   ;
;  XXX, se mantenga siempre actualizado mediante el hecho (ContarHechos XXX)                          ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  REALIZADO POR: Paula Cumbreras Torrente                                                            ;
;  GRUPO: Prácticas Lunes (17:30 a 19:30)                                                             ;
;  GII UGR                                                                                            ;
;  CURSO 19-20                                                                                        ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(clear)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;; Hechos para la representación del ejercicio 5 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  (Hecho <tipo> <valor>) representa los hechos a contar: su tipo y su valor.                         ;
;  (NumeroHechos <tipo> <cuenta>) almacena el número de hechos que hay de un determinado tipo.        ;
;  (ContarHechos <tipo>) actualiza el valor cuenta de NumeroHechos del tipo indicado.                 ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(deftemplate Hecho
  (slot tipo
    (type SYMBOL)
    (allowed-symbols a b c d e f)
  )
  (slot valor
    (type INTEGER)
    (default 0)
  )
)

(deftemplate NumeroHechos
  (slot tipo
    (type SYMBOL)
    (allowed-symbols a b c d e f)
  )
  (slot cuenta
    (type INTEGER)
    (default 0)
    (range 0 100)
  )
)

(deftemplate ContarHechos
  (slot tipo
    (type SYMBOL)
    (allowed-symbols a b c d e f)
  )
)

;;;;;;;;;; Hecho para seguir añadiendo hechos ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(deftemplate Continuar
  (slot s
    (type SYMBOL)
    (allowed-symbols s n)
  )
)

;;;;;;;;;; Inicialización ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(deffacts Inicio 
  (NumeroHechos (tipo a) (cuenta 0))
  (NumeroHechos (tipo b) (cuenta 0))
  (NumeroHechos (tipo c) (cuenta 0))
  (NumeroHechos (tipo d) (cuenta 0))
  (NumeroHechos (tipo e) (cuenta 0))
  (Continuar (s s))
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;; Reglas del ejercicio 5 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  Reglas para añadir nuevos hecho y para mantener actualizados los hechos NumeroHechos.              ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;; Regla para añadir nuevos hechos ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule nuevo_hecho
  (declare (salience 0))
  ?f <- (Continuar (s s))
  =>
  (retract ?f)
  (printout t "Elija el tipo f para salir" crlf)
  (printout t "Elija el tipo (a b c d e f):       ")
  (bind ?t (read))
  (printout t "Elija el valor (0-10):             ")
  (bind ?v (read))
  (assert (Hecho (tipo ?t) (valor ?v)) (ContarHechos (tipo ?t)) (Continuar (s s)))
)

;;;;;;;;;; Regla para actualizar el número de hechos ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule actualizar
  (declare (salience 5))
  ?f <- (ContarHechos (tipo ?t))
  ?g <- (NumeroHechos (tipo ?t) (cuenta ?n))
  =>
  (retract ?f ?g)
  (bind ?m (+ ?n 1))
  (assert (NumeroHechos (tipo ?t) (cuenta ?m)))
  (printout t "Hecho aniadido"  crlf)
  ;(printout t "Hay " ?m " hechos del tipo " ?t  crlf)
  (printout t " "  crlf)
)

;;;;;;;;;; Regla para salir ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule salir
  (declare (salience 5))
  ?f <- (Continuar (s s))
  ?g <- (Hecho (tipo f) (valor ?))
  (NumeroHechos (tipo a) (cuenta ?a))
  (NumeroHechos (tipo b) (cuenta ?b))
  (NumeroHechos (tipo c) (cuenta ?c))
  (NumeroHechos (tipo d) (cuenta ?d))
  (NumeroHechos (tipo e) (cuenta ?e))
  =>
  (retract ?f ?g)
  (printout t " "  crlf)
  (printout t "Tipos      a   b   c   d   e" crlf)
  (printout t "N hechos   " ?a "   " ?b "   " ?c "   " ?d "   " ?e crlf)
  (assert (Continuar (s n)))
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;