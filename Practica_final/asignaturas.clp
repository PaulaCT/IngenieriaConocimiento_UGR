;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;; PRÁCTICA FINAL ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  La práctica del curso consiste en diseñar un sistema experto que asesore a un estudiante de        ;
;  ingeniería informática tal y como lo haría un compañero concreto.                                  ;
;  Esta última práctica será dedicada al caso de asesorar sobre qué asignaturas elegir para un        ;
;  número de créditos dado.                                                                           ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  REALIZADO POR: Paula Cumbreras Torrente                                                            ;
;  GRUPO: Prácticas Lunes (17:30 a 19:30)                                                             ;
;  GII UGR                                                                                            ;
;  CURSO 19-20                                                                                        ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;; Hechos para representar los consejos y las asignaturas ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  (Asignatura <nombre> <rama> <tipo> <cuatrimestre> <dificultad> <creditos> <probabilidad>)          ;
;  representa una asignatura y todas sus características. Todos los datos han de aparecer en el       ;
;  fichero de lectura, salvo <probabilidad> que será usada por el sistema para el razonamiento.       ;
;  (Consejo <nombre de asignatura> <texto del motivo> <apodo del experto>) representa que la          ;
;  asignatura <nombre de asignatura> ha sido recomendada por el experto <apodo del experto> bajo el   ;
;  razonamiento <texto del motivo>.                                                                   ;
;  (Probabilidad <tipo> <valor> <probabilidad>) almacena un valor <probabilidad> correspondiente a    ;
;  lo que el valor <valor> de la característica <tipo> aporta a la selección de asignaturas. Algunos  ;
;  de estos valores serán iniciales, otros variarán en función de las preferencias del usuario.       ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;; Asignaturas ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(deftemplate Asignatura
  (slot nombre
    (type SYMBOL)
    (default null)
  )
  (slot rama
    (type SYMBOL)
    (default troncal)
    (allowed-symbols troncal CSI IS IC SI TI)
  )
  (slot tipo
    (type SYMBOL)
    (default O)
    (allowed-symbols O V)
  )
  (slot cuatrimestre
    (type INTEGER)
    (default 1)
    (allowed-integers 1 2)  
  )
  (slot dificultad
    (type SYMBOL)
    (default facil)
    (allowed-symbols facil normal dificil)
  )
  (slot creditos
    (type INTEGER)
    (default 6)
    (allowed-integers 6 12)  
  )
  (slot prob
    (type FLOAT)
    (default ?DERIVE)
  )
)

;;;;;;;;;; Consejos ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(deftemplate Consejo
  (slot asignatura
    (type SYMBOL)
    (default null)
  )
  (slot motivo
    (type STRING)
    (default ?DERIVE)
  )
  (slot experto
    (type STRING)
    (default "Clips")
    (allowed-strings "Clips" "A. Romero")
  )
)

;;;;;;;;;; Probabilidad aportada por cada característica ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(deftemplate Probabilidad
  (slot tipo 
    (type SYMBOL)
    (default null)
    (allowed-symbols null rama nota obligatoriedad)
  )
  (slot valor
    (type SYMBOL)
    (allowed-symbols troncal CSI IS IC SI TI dificil facil normal O V)
  )
  (slot prob
    (type FLOAT)
    (default ?DERIVE)
  )
)

;;;;;;;;;; Inicialización probabilidades ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(deffacts Probabilidades_iniciales
  (Probabilidad (tipo obligatoriedad) (valor O) (prob 1.0))
  (Probabilidad (tipo obligatoriedad) (valor V) (prob 0.6))
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;; Hechos para la lectura, las preguntas y el control ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  (Pregunta <orden> <finalizada>) es una representación general de todas las preguntas, donde        ;
;  <orden> indica a cuál de todas se refiere. Si la pregunta ya ha sido respondida, se respresentará  ;
;  en <finalizada>.                                                                                   ;
;  (READ <archivo> <nombre>) almacena en <archivo> el nombre del fichero de lectura y en <nombre> se  ;
;  almacena un nombre lógico.                                                                         ;
;  (Leyendo <archivo> <continuar>) continuar valdrá S si aún no se ha alcanzado el fin del archivo    ;
;  <archivo>.                                                                                         ;
;  (Obtencion <continuar>) continuar tomará el valor S hasta que finalice el proceso de obtención     ;
;  de datos del usuario.                                                                              ;
;  (Creditos <primer cuatrimestre> <segundo cuatrimestre>) reparte el número de créditos entre los    ;
;  dos cuatrimestres, de forma que se pueda controlar el número de recomendaciones por cuatrimestre.  ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;; Preguntas ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(deftemplate Pregunta
  (slot n 
    (type INTEGER)
    (default 1)
    (allowed-integers 1 2 3 4 5 6)  
  )
  (slot finalizada
    (type SYMBOL)
    (default N)
    (allowed-symbols S N)  
  )
)

;;;;;;;;;; Archivo de lectura ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(deftemplate READ
  (slot archivo
    (type STRING)
    (default ?DERIVE)
  )
  (slot nombre
    (type SYMBOL)
    (allowed-symbols null primero segundo tercero cuarto nueva)
  )
)

;;;;;;;;;; Controla la lectura de archivos ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(deftemplate Leyendo
  (slot archivo
    (type STRING)
    (default ?DERIVE)
  )
  (slot continuar
    (type SYMBOL)
    (allowed-symbols s n)
  )
)

;;;;;;;;;; Controla la entrevista ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(deftemplate Obtencion
  (slot continuar
    (type SYMBOL)
    (allowed-symbols s n)
  )
)

;;;;;;;;;; Controla la cantidad de consejos ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(deftemplate Creditos
  (slot primer_cuatrimestre
    (type INTEGER)
    (default 6)
  )
  (slot segundo_cuatrimestre
    (type INTEGER)
    (default 6)
  )
)

;;;;;;;;;; Inicialización ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(deffacts Entrevista
  (Pregunta (n 1) (finalizada N))
  (Obtencion (continuar s))
)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;; Obtención de datos ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  Reglas para obtener los datos necesarios para realizar el razonamiento. El usuario podrá elegir no ;
;  responder a las preguntas, aunque si no responde a la primera no obtendrá ningún consejo. Las      ;
;  respuestas influirán en las probabilidades.                                                        ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;; Regla para hacer la primera pregunta: seleccionar base de datos ;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule seleccion_base_datos
  (declare (salience 1))
  (Modulo (nombre asignaturas))
  ?f<-(Pregunta (n 1) (finalizada N))
  (Obtencion (continuar s))
  =>
  (retract ?f) 
  (assert (Pregunta (n 1)(finalizada N)))
  (printout t "Seleccione el curso: 1 2 3 4 o 0 para terminar (podra elegir mas de uno)"  crlf)
  (bind ?curso (read))
  (if (eq ?curso 1) then (assert (READ (archivo "bases_datos_asignaturas/asignaturas_primero.txt") (nombre primero))))
  (if (eq ?curso 2) then (assert (READ (archivo "bases_datos_asignaturas/asignaturas_segundo.txt") (nombre segundo))))
  (if (eq ?curso 3) then (assert (READ (archivo "bases_datos_asignaturas/asignaturas_tercero.txt") (nombre tercero))))
  (if (eq ?curso 4) then (assert (READ (archivo "bases_datos_asignaturas/asignaturas_cuarto.txt") (nombre cuarto))))
  (if (eq ?curso 0) then (assert (READ (archivo "null") (nombre null))))
)

;;;;;;;;;; Regla para añadir otra base de datos ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule nueva_base
  (declare (salience 5))
  (Modulo (nombre asignaturas))
  ?f<-(Pregunta (n 1)(finalizada N))
  ?g<-(READ (archivo ?) (nombre null))
  =>
  (retract ?f ?g)
  (printout t "Si quiere introducir otro archivo escriba su nombre entrecomillado, si no escriba ns "  crlf)
  (bind ?nueva (read))
  (if (neq ?nueva ns) then (assert (READ (archivo ?nueva) (nombre nueva))))
  (assert (Pregunta (n 1) (finalizada S)) (Pregunta (n 2) (finalizada N)))
)

;;;;;;;;;; Regla para abrir el archivo ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule recoger_datos
  (declare (salience 6))
  (Modulo (nombre asignaturas))
  (READ (archivo ?f) (nombre ?n))
  =>
  (open ?f ?n)
  (assert (Leyendo (archivo ?f)(continuar s)))
)

;;;;;;;;;; Regla para leer el archivo ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule nueva_asignatura
  (declare (salience 4))
  (Modulo (nombre asignaturas))
  (READ (archivo ?file) (nombre ?n))
  ?f<-(Leyendo (archivo ?file) (continuar s))
  =>
  (bind ?nombre (read ?n))
  (retract ?f)
  (if (neq ?nombre EOF) then 
    (and
      (bind ?rama (read ?n))
      (bind ?tipo (read ?n))
      (bind ?cuatrimestre (read ?n))
      (bind ?dificultad (read ?n))
      (bind ?creditos (read ?n))
      ;(printout t ?nombre ?rama ?tipo ?cuatrimestre ?dificultad ?creditos  crlf)
      (assert (Leyendo (archivo ?file) (continuar s))
      (Asignatura (nombre ?nombre) (rama ?rama) (tipo ?tipo) (cuatrimestre ?cuatrimestre) (dificultad ?dificultad) (creditos ?creditos))
      (Consejo (asignatura ?nombre) (motivo "") (experto "Clips")))
    )
  )
)

;;;;;;;;;; Regla para cerrar el archivo ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule fin_archivo
  (declare (salience 5))
  (Modulo (nombre asignaturas))
  ?f<-(READ (archivo ?file) (nombre ?n))
  (not (Leyendo (archivo ?file) (continuar s)))
  =>
  (retract ?f)
  (close ?n)
)

;;;;;;;;;; Regla para hacer la segunda pregunta: seleccionar rama ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule seleccion_rama
  (declare (salience 1))
  (Modulo (nombre asignaturas))
  ?f<-(Pregunta (n 2) (finalizada N))
  (Obtencion (continuar s))
  =>
  (retract ?f)
  (assert (Pregunta (n 2)(finalizada S))(Pregunta (n 3) (finalizada N)))
  (printout t "Seleccione la rama: CSI IS IC SI TI o ns"  crlf)
  (bind ?rama (read))
  (if (eq ?rama ns) then 
    (assert 
      (Probabilidad (tipo rama) (valor troncal) (prob 1.0))
      (Probabilidad (tipo rama) (valor CSI) (prob 0.8))
      (Probabilidad (tipo rama) (valor IS) (prob 0.8))
      (Probabilidad (tipo rama) (valor IC) (prob 0.8))
      (Probabilidad (tipo rama) (valor SI) (prob 0.8))
      (Probabilidad (tipo rama) (valor TI) (prob 0.8))
    )
  )
  (if (eq ?rama CSI) then 
    (assert 
      (Probabilidad (tipo rama) (valor troncal) (prob 1.0))
      (Probabilidad (tipo rama) (valor CSI) (prob 1.0))
      (Probabilidad (tipo rama) (valor IS) (prob 0.1))
      (Probabilidad (tipo rama) (valor IC) (prob 0.1))
      (Probabilidad (tipo rama) (valor SI) (prob 0.1))
      (Probabilidad (tipo rama) (valor TI) (prob 0.1))
    )
  )
  (if (eq ?rama IS) then 
    (assert 
      (Probabilidad (tipo rama) (valor troncal) (prob 1.0))
      (Probabilidad (tipo rama) (valor CSI) (prob 0.1))
      (Probabilidad (tipo rama) (valor IS) (prob 1.0))
      (Probabilidad (tipo rama) (valor IC) (prob 0.1))
      (Probabilidad (tipo rama) (valor SI) (prob 0.1))
      (Probabilidad (tipo rama) (valor TI) (prob 0.1))
    )
  )
  (if (eq ?rama IC) then 
    (assert 
      (Probabilidad (tipo rama) (valor troncal) (prob 1.0))
      (Probabilidad (tipo rama) (valor CSI) (prob 0.1))
      (Probabilidad (tipo rama) (valor IS) (prob 0.1))
      (Probabilidad (tipo rama) (valor IC) (prob 1.0))
      (Probabilidad (tipo rama) (valor SI) (prob 0.1))
      (Probabilidad (tipo rama) (valor TI) (prob 0.1))
    )
  )
  (if (eq ?rama SI) then 
    (assert 
      (Probabilidad (tipo rama) (valor troncal) (prob 1.0))
      (Probabilidad (tipo rama) (valor CSI) (prob 0.1))
      (Probabilidad (tipo rama) (valor IS) (prob 0.1))
      (Probabilidad (tipo rama) (valor IC) (prob 0.1))
      (Probabilidad (tipo rama) (valor SI) (prob 1.0))
      (Probabilidad (tipo rama) (valor TI) (prob 0.1))
    )
  )
  (if (eq ?rama TI) then 
    (assert 
      (Probabilidad (tipo rama) (valor troncal) (prob 1.0))
      (Probabilidad (tipo rama) (valor CSI) (prob 0.1))
      (Probabilidad (tipo rama) (valor IS) (prob 0.1))
      (Probabilidad (tipo rama) (valor IC) (prob 0.1))
      (Probabilidad (tipo rama) (valor SI) (prob 0.1))
      (Probabilidad (tipo rama) (valor TI) (prob 1.0))
    )
  )
)

;;;;;;;;;; Regla para hacer la tercera pregunta: seleccionar dificultad ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule seleccion_nota
  (declare (salience 1))
  (Modulo (nombre asignaturas))
  ?f<-(Pregunta (n 3) (finalizada N))
  (Obtencion (continuar s))
  =>
  (retract ?f)
  (assert (Pregunta (n 3)(finalizada S))(Pregunta (n 4) (finalizada N)))
  (printout t "Seleccione su nota media: alta media baja o ns"  crlf)
  (bind ?nota (read))
  (if (eq ?nota ns) then 
    (assert 
      (Probabilidad (tipo nota) (valor facil) (prob 1.0))
      (Probabilidad (tipo nota) (valor normal) (prob 1.0))
      (Probabilidad (tipo nota) (valor dificil) (prob 1.0))
    )
  )
  (if (eq ?nota alta) then 
    (assert 
      (Probabilidad (tipo nota) (valor facil) (prob 0.8))
      (Probabilidad (tipo nota) (valor normal) (prob 0.9))
      (Probabilidad (tipo nota) (valor dificil) (prob 1.0))
    )
  )
  (if (eq ?nota media) then 
    (assert 
      (Probabilidad (tipo nota) (valor facil) (prob 0.9))
      (Probabilidad (tipo nota) (valor normal) (prob 1.0))
      (Probabilidad (tipo nota) (valor dificil) (prob 0.9))
    )
  )
  (if (eq ?nota baja) then 
    (assert 
      (Probabilidad (tipo nota) (valor facil) (prob 1.0))
      (Probabilidad (tipo nota) (valor normal) (prob 0.6))
      (Probabilidad (tipo nota) (valor dificil) (prob 0.2))
    )
  )
)

;;;;;;;;;; Regla para hacer la cuarta pregunta: seleccionar créditos ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule seleccion_creditos
  (declare (salience 1))
  (Modulo (nombre asignaturas))
  ?f<-(Pregunta (n 4) (finalizada N))
  ?g<-(Obtencion (continuar s))
  =>
  (retract ?f)
  (printout t "Introduzca el numero de creditos (multiplo de 6) "  crlf)
  (bind ?total (read))
  (printout t "Introduzca el numero de asignaturas para el primer_cuatrimestre "  crlf)
  (bind ?primer (read))
  (bind ?segundo (- (/ ?total 6) ?primer))
  (if (and (eq (mod ?total 6) 0) (< (* ?primer 6) ?total))
  then (and (retract ?g)(assert (Pregunta (n 4)(finalizada S)) (Pregunta (n 5) (finalizada N)) (Creditos (primer_cuatrimestre ?primer) (segundo_cuatrimestre ?segundo))))
  else (assert (Pregunta (n 4)(finalizada N))))
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;; Razonamiento ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  Reglas para realizar el razonamiento a partir de los datos obtenidos. Se realizará un razonamiento ;
;  probabilístico a partir del conocimiento extraído del experto en la entrevista realizada.          ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;; Aviso de la precisión del resultado por falta de datos ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule calidad_respuesta
  (declare (salience 60))
  (Modulo (nombre asignaturas))
  ?f<-(Pregunta (n 4) (finalizada S))
  (or
    (Probabilidad (tipo rama) (valor CSI) (prob 0.8))
    (and
      (Probabilidad (tipo nota) (valor facil) (prob 1.0))
      (Probabilidad (tipo nota) (valor normal) (prob 1.0))
      (Probabilidad (tipo nota) (valor dificil) (prob 1.0))
    )
  )
  =>
  (retract ?f)
  (printout t "No has respondido a todas las preguntas, la recomendacion podria no ser acertada" crlf crlf)
)

;;;;;;;;;; Regla para asignar la probabilidad a cada asignatura ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule puntuar
  (declare (salience 10))
  (Modulo (nombre asignaturas))
  (not (Obtencion (continuar s)))
  ?f<-(Consejo (asignatura ?nombre) (motivo ?motivo) (experto "Clips"))
  ?g<-(Asignatura (nombre ?nombre) (rama ?rama) (tipo ?tipo) (cuatrimestre ?cuatrimestre) (dificultad ?dificultad) (creditos ?creditos))
  (Probabilidad (tipo rama) (valor ?rama) (prob ?p_rama))
  (Probabilidad (tipo obligatoriedad) (valor ?tipo) (prob ?p_ob))
  (Probabilidad (tipo nota) (valor ?dificultad) (prob ?p_dif))
  =>
  (retract ?f)
  (bind ?prob (* 1.0 ?p_rama))
  (bind ?prob (* ?prob ?p_ob))
  (bind ?prob (* ?prob ?p_dif))
  (if (eq ?tipo O) then (bind ?n_t "obligatoria") else (bind ?n_t "optativa"))
  (bind ?motivo (str-cat ?motivo "Asignatura de la rama " ?rama " de tipo " ?n_t " y es " ?dificultad ". Numero creditos: " ?creditos " Probabilidad: " ?prob ))
  (assert
    (Consejo (asignatura ?nombre) (motivo ?motivo) (experto "A. Romero"))
    (Asignatura (nombre ?nombre) (rama ?rama) (tipo ?tipo) (cuatrimestre ?cuatrimestre) (dificultad ?dificultad) (creditos ?creditos) (prob ?prob))
  )
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;; Fin del razonamiento ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  Se muestran por pantalla las asignaturas recomendadas junto a su motivo. Se recomendarán tantas    ;
;  asignaturas por cuatrimestre como se hayan indicado en la cuarta pregunta.                         ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;; Aconsejar asignaturas del primer cuatrimestre ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule mejores_primer_cuatrimeste
  (declare (salience 2))
  (Modulo (nombre asignaturas))
  (not (Obtencion (continuar s)))
  ?h<-(Creditos (primer_cuatrimestre ?n) (segundo_cuatrimestre ?m))
  ?g<-(Asignatura (nombre ?nombre) (rama ?rama) (tipo ?tipo) (cuatrimestre 1) (dificultad ?dificultad) (creditos ?creditos) (prob ?prob))
  (or
    (and
      (test (= ?creditos 6))
      (test (>= ?n 1))
    )
    (and
      (test (= ?creditos 12))
      (test (>= ?n 2))
    )
  )
  ?f<-(Consejo (asignatura ?nombre) (motivo ?motivo) (experto ?experto))
  (test (neq ?experto "Clips"))
  (forall (Asignatura (nombre ?nombre2) (rama ?) (tipo ?) (cuatrimestre 1) (dificultad ?) (creditos ?) (prob ?prob2))
    (test (<= ?prob2 ?prob))
  )
  =>
  (retract ?f ?g ?h)
  (printout t "El experto " ?experto " te recomienda la asignatura " ?nombre " del cuatrimestre 1 con el siguiente motivo: " crlf ?motivo crlf crlf)
  (if (eq ?creditos 6) then (bind ?n (- ?n 1))
  else (bind ?n (- ?n 2)))
  (assert (Creditos (primer_cuatrimestre ?n) (segundo_cuatrimestre ?m)))
)

;;;;;;;;;; Aconsejar asignaturas del segundo cuatrimestre ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule mejores_segundo_cuatrimeste
  (declare (salience 0))
  (Modulo (nombre asignaturas))
  (not (Obtencion (continuar s)))
  ?h<-(Creditos (primer_cuatrimestre ?n) (segundo_cuatrimestre ?m))
  ?g<-(Asignatura (nombre ?nombre) (rama ?rama) (tipo ?tipo) (cuatrimestre 2) (dificultad ?dificultad) (creditos ?creditos) (prob ?prob))
  (or
    (and
      (test (= ?creditos 6))
      (test (>= ?m 1))
    )
    (and
      (test (= ?creditos 12))
      (test (>= ?m 2))
    )
  )
  ?f<-(Consejo (asignatura ?nombre) (motivo ?motivo) (experto ?experto))
  (test (neq ?experto "Clips"))
  (forall (Asignatura (nombre ?nombre2) (rama ?) (tipo ?) (cuatrimestre 2) (dificultad ?) (creditos ?) (prob ?prob2))
    (test (<= ?prob2 ?prob))
  )
  =>
  (retract ?f ?g ?h)
  (printout t "El experto " ?experto " te recomienda la asignatura " ?nombre " del cuatrimeste 2 con el siguiente motivo: " crlf ?motivo crlf crlf)
  (if (eq ?creditos 6) then (bind ?m (- ?m 1))
  else (bind ?m (- ?m 2)))
  (assert (Creditos (primer_cuatrimestre ?n) (segundo_cuatrimestre ?m)))
)

;;;;;;;;;; Aviso: no hay base de datos ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule error_base_datos
  (declare (salience 0))
  (Modulo (nombre asignaturas))
  (not (Obtencion (continuar s)))
  (not (Creditos (primer_cuatrimestre 0) (segundo_cuatrimestre 0)))
  (not (Asignatura (nombre ?) (rama ?) (tipo ?) (cuatrimestre ?) (dificultad ?) (creditos ?) (prob ?)))
  =>
  (printout t "No has introducido ninguna base de datos en el sistema. Por favor intentelo de nuevo." crlf )
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;