;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;; EJERCICIO 9 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  Crea un trozo de código que lea de un fichero de datos los valores de un vector WRITE con un       ;
;  número indefinido de elementos.                                                                    ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  REALIZADO POR: Paula Cumbreras Torrente                                                            ;
;  GRUPO: Prácticas Lunes (17:30 a 19:30)                                                             ;
;  GII UGR                                                                                            ;
;  CURSO 19-20                                                                                        ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(clear)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;; Hechos para la representación del ejercicio 9 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  (WRITE <valores>) almacena un conjunto de valores.                                                 ;
;  (READ <archivo>) almacena el archivo del que se leerán los valores.                                ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(deftemplate WRITE
  (multislot valores)
)

(deftemplate READ
  (slot archivo
    (type STRING)
    (default ?DERIVE)
  )
)

;;;;;;;;;; Hechos para controlar la lectura ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(deftemplate SeguirLeyendo
  (slot c
    (type SYMBOL)
    (allowed-symbols s n)
  )
)

(deftemplate Empezar
  (slot c
    (type SYMBOL)
    (allowed-symbols s)
  )
)

;;;;;;;;;; Hecho para añadir o no un valor leído ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(deftemplate Aniadir
  (slot valor)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;; Reglas del ejercicio 9 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  Reglas para preguntar el nombre del archivo, abrirlo, obtener todos los valores del mismo hasta    ;
;  acabar de leerlo, añadiéndolos al vector WRITE, para cerrar el archivo y para escribir el vector   ;
;  obtenido tras la lectura.                                                                          ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;; Reglas para obtener el nombre del archivo ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule obtener_archivo
  (declare (salience 10))
  (not (READ (archivo ?)))
  (not (Empezar (c ?)))
  (not (SeguirLeyendo (c ?)))
  =>
  (printout t "Indique el nombre del archivo: " )
  (assert (READ (archivo (read))) (Empezar (c s)))
)

;;;;;;;;;; Regla para abrir un archivo ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule openfile_read
  (declare (salience 8))
  (READ (archivo ?f))
  ?g <- (Empezar (c s))
  (not (SeguirLeyendo (c ?)))
  =>
  (retract ?g)
  (open ?f file)
  (assert (SeguirLeyendo (c s)))
)

;;;;;;;;;; Regla para leer de un archivo ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule readfile
  (declare (salience 9))
  (SeguirLeyendo (c s))
  (not (Aniadir (valor ?)))
  =>
  (bind ?v (read file))
  (assert (Aniadir (valor ?v)))
)

;;;;;;;;;; Reglas para añadir a vector WRITE ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule aniadir_primer_valor
  (declare (salience 20))
  ?f <- (SeguirLeyendo (c s))
  ?g <- (Aniadir (valor ?v))
  (not (WRITE (valores $?)))
  (test (neq ?v EOF))
  =>
  (retract ?f ?g)
  (assert (WRITE (valores ?v)) (SeguirLeyendo (c s)))
)

(defrule aniadir_otro_valor
  (declare (salience 20))
  ?f <- (SeguirLeyendo (c s))
  ?g <- (Aniadir (valor ?v))
  ?h <- (WRITE (valores $?v_antes))
  (test (neq ?v EOF))
  =>
  (retract ?f ?g ?h)
  (assert (WRITE (valores ?v_antes ?v)) (SeguirLeyendo (c s)))
)

;;;;;;;;;; Regla para determinar el fin del archivo ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule no_aniadir_valor
  (declare (salience 20))
  ?f <- (SeguirLeyendo (c s))
  ?g <- (Aniadir (valor ?v))
  (test (eq ?v EOF))
  =>
  (retract ?f ?g)
  (assert (SeguirLeyendo (c n)))
)

;;;;;;;;;; Regla para cerrar un archivo ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule closefile_read
  (declare (salience 7))
  ?g <- (SeguirLeyendo (c n))
  ?f <- (READ (archivo ?))
  (not (Empezar (c ?)))
  =>
  (retract ?f ?g)
  (assert (SeguirLeyendo (c n)))
  (close file)
)

;;;;;;;;;; Regla para escribir el vector ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule escribir
  (declare (salience 2))
  ?f <- (WRITE (valores $?v))
  (not (Empezar (c ?)))
  =>
  (retract ?f)
  (printout t ?v  crlf)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;