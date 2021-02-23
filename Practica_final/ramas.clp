;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;; PRIMERA PARTE DE LA PRÁCTICA ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  La práctica del curso consiste en diseñar un sistema experto que asesore a un estudiante de        ;
;  ingeniería informática tal y como lo haría un compañero concreto.                                  ;
;  La primera parte de la práctica será dedicada al caso de asesorar sobre que rama elegir.           ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  REALIZADO POR: Paula Cumbreras Torrente                                                            ;
;  GRUPO: Prácticas Lunes (17:30 a 19:30)                                                             ;
;  GII UGR                                                                                            ;
;  CURSO 19-20                                                                                        ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;; Hechos para representar los consejos y las ramas ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  (Rama <nombre de la rama>) representa las posibles ramas a recomendar.                             ;
;  (Consejo_Rama <nombre de la rama> <texto del motivo> <apodo del experto>) representa que la rama        ;
;  <nombre de la rama> ha sido recomendada por el experto <apodo del experto> bajo el razonamiento    ;
;  <texto del motivo>.                                                                                ;
;  (Es_Rama <rama> <nombre>) relaciona la rama con abreviatura <rama> con el <nombre> verdadero       ;
;  de dicha rama.                                                                                     ;
;  (Puntuacion <rama> <puntuacion>) almacena un valor <puntuacion> que irá aumentando en función      ;
;  al grado de afinidad del alumno con la rama <rama>.                                                ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;; Ramas ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(deftemplate Ramas
  (slot nombre
    (type SYMBOL)
    (default null)
    (allowed-symbols null Computacion_y_Sistemas_Inteligentes Ingenieria_del_Software 
    Ingenieria_de_Computadores Sistemas_de_Informacion Tecnologias_de_la_Informacion)
  )
)

;;;;;;;;;; Consejos ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(deftemplate Consejo_Rama
  (slot rama
    (type SYMBOL)
    (default null)
    (allowed-symbols null CSI IS IC SI TI)
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

;;;;;;;;;; Equivalencia entre abreviatura de Consejo y Ramas ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(deftemplate Es_Rama
  (slot rama
    (type SYMBOL)
    (default null)
    (allowed-symbols null CSI IS IC SI TI)
  )
  (slot nombre
    (type SYMBOL)
    (default null)
    (allowed-symbols null Computacion_y_Sistemas_Inteligentes Ingenieria_del_Software 
    Ingenieria_de_Computadores Sistemas_de_Informacion Tecnologias_de_la_Informacion)
  )
)


;;;;;;;;;; Puntuaciones de cada rama ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(deftemplate Puntuacion
  (slot rama
    (type SYMBOL)
    (default null)
    (allowed-symbols null CSI IS IC SI TI)
  )
  (slot p
    (type INTEGER)
    (default 0)
  )
)

;;;;;;;;;; Inicialización de las ramas y consejos ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(deffacts Inicializacion_ramas
  ;;;;;;;; Inicialización ramas ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (Ramas (nombre Computacion_y_Sistemas_Inteligentes))
  (Ramas (nombre Ingenieria_del_Software))
  (Ramas (nombre Ingenieria_de_Computadores))
  (Ramas (nombre Sistemas_de_Informacion))
  (Ramas (nombre Tecnologias_de_la_Informacion))
  ;;;;;;;; Equivalencia nombres y abreviaturas ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (Es_Rama (rama CSI) (nombre Computacion_y_Sistemas_Inteligentes))
  (Es_Rama (rama IS) (nombre Ingenieria_del_Software))
  (Es_Rama (rama IC) (nombre Ingenieria_de_Computadores))
  (Es_Rama (rama SI) (nombre Sistemas_de_Informacion))
  (Es_Rama (rama TI) (nombre Tecnologias_de_la_Informacion))
  ;;;;;;;; Inicialización consejos ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (Consejo_Rama (rama CSI) (motivo "") (experto "Clips"))
  (Consejo_Rama (rama IS) (motivo "") (experto "Clips"))
  (Consejo_Rama (rama IC) (motivo "") (experto "Clips"))
  (Consejo_Rama (rama SI) (motivo "") (experto "Clips"))
  (Consejo_Rama (rama TI) (motivo "") (experto "Clips"))
  ;;;;;;;; Inicialización puntuación de ramas ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (Puntuacion (rama CSI) (p 0))
  (Puntuacion (rama IS) (p 0))
  (Puntuacion (rama IC) (p 0))
  (Puntuacion (rama SI) (p 0))
  (Puntuacion (rama TI) (p 0))
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;; Hechos para representar las preguntas y respuestas ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  (Pregunta_Rama<orden> <respuesta util> <puntuada>) es una representación general de todas las          ;
;  preguntas, donde <orden> indica a cuál de todas se refiere. Si la respuesta obtenida es util, se   ;
;  mostrará en <respuesta util> y si esta pregunta ya ha tenido repercusión sobre las puntuaciones    ;
;  de las ramas, <puntuada> lo reflejará.                                                             ;
;  (Respuesta <tipo> <respuesta>) es un template general para todas las respuestas; en <tipo> se      ;
;  indica a qué responde y en <respuesta> se almacena lo respondido por el alumno.                    ;
;  (Es_Pregunta <tipo> <orden>) relaciona el <tipo> de respuesta dada con el número de la pregunta    ;
;  en la que se responde.                                                                             ;
;  (Justificaciones <orden> <texto>) almacena el texto que incluirá el motivo del consejo si la       ;
;  pregunta <orden> ha influenciado en la recomendación.                                              ;
;  (Valor_Pregunta <rama> <pregunta> <respuesta> <puntos>) almacena que la respuesta <respuesta>      ;
;  de la pregunta número <pregunta> aumenta en <puntos> la puntuación o grado de afinidad de la       ;
;  rama con abreviatura <rama>.                                                                       ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;; Preguntas ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(deftemplate Pregunta_Rama
  (slot n ; Orden
    (type INTEGER)
    (default 1)
    (allowed-integers 1 2 3 4 5 6)  
  )
  (slot util ; Elimina respuestas ns
    (type INTEGER)
    (default 0)
    (allowed-integers -1 0 1)  
  )
  (slot puntuada ; Asegura que la pregunta haya sido puntuada
    (type SYMBOL)
    (allowed-symbols S N)
    (default N)
  )
)

;;;;;;;;;; Respuestas ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(deftemplate Respuesta
  (slot tipo
    (type SYMBOL)
    (allowed-symbols trabajador nota futuro hardware matematicas)
  )
  (slot r
    (type SYMBOL)
    (allowed-symbols mucho poco normal alta media baja docencia empresa_publica empresa_privada si no ns)
  )
)

;;;;;;;;;; Equivalencia entre número de pregunta y tipo de respuesta ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(deftemplate Es_Pregunta
  (slot tipo
    (type SYMBOL)
    (allowed-symbols trabajador nota futuro hardware matematicas)
  )
  (slot n ; Orden
    (type INTEGER)
    (default 1)
    (allowed-integers 1 2 3 4 5 6)  
  )
)

;;;;;;;;;; Texto para cada pregunta ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(deftemplate Justificaciones
  (slot n ; Orden
    (type INTEGER)
    (default 1)
    (allowed-integers 0 1 2 3 4 5)  
  )
  (slot texto
    (type STRING)
    (default ?DERIVE)
  )
)

;;;;;;;;;; Puntuación de cada respuesta ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(deftemplate Valor_Pregunta
  (slot rama
    (type SYMBOL)
    (default null)
    (allowed-symbols null CSI IS IC SI TI)
  )
  (slot pregunta
    (type INTEGER)
    (default 1)
    (allowed-integers 1 2 3 4 5 6)  
  )
  (slot respuesta
    (type SYMBOL)
    (allowed-symbols mucho poco normal alta media baja docencia empresa_publica empresa_privada si no ns)
  )
  (slot p
    (type INTEGER)
    (default 0)
  )
)

;;;;;;;;;; Inicialización de las preguntas y respuestas ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(deffacts Inicializacion_preguntas
  ;;;;;;;; Inicialización preguntas ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (Pregunta_Rama(n 1) (util 0))
  (Pregunta_Rama(n 2) (util -1))
  (Pregunta_Rama(n 3) (util -1))
  (Pregunta_Rama(n 4) (util -1))
  (Pregunta_Rama(n 5) (util -1))
  ;;;;;;;; Equivalencias preguntas y tipo respuesta ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (Es_Pregunta (tipo trabajador) (n 1))
  (Es_Pregunta (tipo nota) (n 2))
  (Es_Pregunta (tipo futuro) (n 3))
  (Es_Pregunta (tipo hardware) (n 4))
  (Es_Pregunta (tipo matematicas) (n 5))
  ;;;;;;;; Texto del motivo por pregunta ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (Justificaciones (n 1) (texto "Eres trabajador: "))
  (Justificaciones (n 2) (texto "Tu nota media es: "))
  (Justificaciones (n 3) (texto "Te gustaria trabajar en: "))
  (Justificaciones (n 4) (texto "Te gusta el hardware: "))
  (Justificaciones (n 5) (texto "Te gustan las matematicas: "))
  (Justificaciones (n 0) (texto "Grado de afinidad: "))
  ;;;;;;;; Aumento de afinidad por respuesta ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (Valor_Pregunta (rama CSI) (pregunta 1) (respuesta mucho)(p 75))
  (Valor_Pregunta (rama CSI) (pregunta 1) (respuesta poco)(p 0))
  (Valor_Pregunta (rama CSI) (pregunta 1) (respuesta normal)(p 15))
  (Valor_Pregunta (rama IS) (pregunta 1) (respuesta mucho)(p 0))
  (Valor_Pregunta (rama IS) (pregunta 1) (respuesta poco)(p 75))
  (Valor_Pregunta (rama IS) (pregunta 1) (respuesta normal)(p 15))
  (Valor_Pregunta (rama IC) (pregunta 1) (respuesta mucho)(p 10))
  (Valor_Pregunta (rama IC) (pregunta 1) (respuesta poco)(p 0))
  (Valor_Pregunta (rama IC) (pregunta 1) (respuesta normal)(p 15))
  (Valor_Pregunta (rama SI) (pregunta 1) (respuesta mucho)(p 0))
  (Valor_Pregunta (rama SI) (pregunta 1) (respuesta poco)(p 15))
  (Valor_Pregunta (rama SI) (pregunta 1) (respuesta normal)(p 15))
  (Valor_Pregunta (rama TI) (pregunta 1) (respuesta mucho)(p 10))
  (Valor_Pregunta (rama TI) (pregunta 1) (respuesta poco)(p 0))
  (Valor_Pregunta (rama TI) (pregunta 1) (respuesta normal)(p 15))
  (Valor_Pregunta (rama CSI) (pregunta 2) (respuesta alta)(p 15))
  (Valor_Pregunta (rama CSI) (pregunta 2) (respuesta media)(p 10))
  (Valor_Pregunta (rama CSI) (pregunta 2) (respuesta baja)(p 0))
  (Valor_Pregunta (rama IS) (pregunta 2) (respuesta alta)(p 15))
  (Valor_Pregunta (rama IS) (pregunta 2) (respuesta media)(p 10))
  (Valor_Pregunta (rama IS) (pregunta 2) (respuesta baja)(p 10))
  (Valor_Pregunta (rama IC) (pregunta 2) (respuesta alta)(p 15))
  (Valor_Pregunta (rama IC) (pregunta 2) (respuesta media)(p 10))
  (Valor_Pregunta (rama IC) (pregunta 2) (respuesta baja)(p 65))
  (Valor_Pregunta (rama SI) (pregunta 2) (respuesta media)(p 65))
  (Valor_Pregunta (rama SI) (pregunta 2) (respuesta alta)(p 15))
  (Valor_Pregunta (rama SI) (pregunta 2) (respuesta baja)(p 10))
  (Valor_Pregunta (rama TI) (pregunta 2) (respuesta media)(p 15))
  (Valor_Pregunta (rama TI) (pregunta 2) (respuesta alta)(p 15))
  (Valor_Pregunta (rama TI) (pregunta 2) (respuesta baja)(p 0))
  (Valor_Pregunta (rama CSI) (pregunta 3) (respuesta docencia)(p 15))
  (Valor_Pregunta (rama CSI) (pregunta 3) (respuesta empresa_publica)(p 0))
  (Valor_Pregunta (rama CSI) (pregunta 3) (respuesta empresa_privada)(p 15))
  (Valor_Pregunta (rama IS) (pregunta 3) (respuesta docencia)(p 55))
  (Valor_Pregunta (rama IS) (pregunta 3) (respuesta empresa_publica)(p 0))
  (Valor_Pregunta (rama IS) (pregunta 3) (respuesta empresa_privada)(p 15))
  (Valor_Pregunta (rama IC) (pregunta 3) (respuesta docencia)(p 10))
  (Valor_Pregunta (rama IC) (pregunta 3) (respuesta empresa_publica)(p 55))
  (Valor_Pregunta (rama IC) (pregunta 3) (respuesta empresa_privada)(p 0))
  (Valor_Pregunta (rama SI) (pregunta 3) (respuesta docencia)(p 0))
  (Valor_Pregunta (rama SI) (pregunta 3) (respuesta empresa_publica)(p 0))
  (Valor_Pregunta (rama SI) (pregunta 3) (respuesta empresa_privada)(p 15))
  (Valor_Pregunta (rama TI) (pregunta 3) (respuesta docencia)(p 10))
  (Valor_Pregunta (rama TI) (pregunta 3) (respuesta empresa_publica)(p 10))
  (Valor_Pregunta (rama TI) (pregunta 3) (respuesta empresa_privada)(p 15))
  (Valor_Pregunta (rama CSI) (pregunta 4) (respuesta si)(p 0))
  (Valor_Pregunta (rama CSI) (pregunta 4) (respuesta no)(p 15))
  (Valor_Pregunta (rama IS) (pregunta 4) (respuesta si)(p 0))
  (Valor_Pregunta (rama IS) (pregunta 4) (respuesta no)(p 10))
  (Valor_Pregunta (rama IC) (pregunta 4) (respuesta si)(p 10))
  (Valor_Pregunta (rama IC) (pregunta 4) (respuesta no)(p 0))
  (Valor_Pregunta (rama SI) (pregunta 4) (respuesta si)(p 0))
  (Valor_Pregunta (rama SI) (pregunta 4) (respuesta no)(p 15))
  (Valor_Pregunta (rama TI) (pregunta 4) (respuesta si)(p 35))
  (Valor_Pregunta (rama TI) (pregunta 4) (respuesta no)(p 0))
  (Valor_Pregunta (rama CSI) (pregunta 5) (respuesta si)(p 15))
  (Valor_Pregunta (rama CSI) (pregunta 5) (respuesta no)(p 0))
  (Valor_Pregunta (rama IS) (pregunta 5) (respuesta si)(p 0))
  (Valor_Pregunta (rama IS) (pregunta 5) (respuesta no)(p 10))
  (Valor_Pregunta (rama IC) (pregunta 5) (respuesta si)(p 0))
  (Valor_Pregunta (rama IC) (pregunta 5) (respuesta no)(p 0))
  (Valor_Pregunta (rama SI) (pregunta 5) (respuesta si)(p 0))
  (Valor_Pregunta (rama SI) (pregunta 5) (respuesta no)(p 15))
  (Valor_Pregunta (rama TI) (pregunta 5) (respuesta si)(p 10))
  (Valor_Pregunta (rama TI) (pregunta 5) (respuesta no)(p 0))
)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;; Hechos para controlar el orden de ejecución ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  (Obtencion_Rama <continuar>) continuar tomará el valor S hasta que finalice el proceso de obtención     ;
;  de datos del usuario.                                                                              ;
;  (Razonamiento <finalizado>) finalizado tomará el valor N hasta que se finalice el razonamiento,    ;
;  es decir, hasta que se genere un consejo.                                                          ;
;  (Selección <seleccionado>) seleccionado tomará el valor S cuando se haya seleccionado la rama      ;
;  a aconsejar tras realizar el razonamiento.                                                         ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;; Controla la entrevista ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(deftemplate Obtencion_Rama
  (slot continuar
    (type SYMBOL)
    (allowed-symbols s n)
  )
)

;;;;;;;;;; Controla el razonamiento ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(deftemplate Razonamiento
  (slot finalizado
    (type SYMBOL)
    (allowed-symbols S N)
  )
)

;;;;;;;;;; Controla el consejo final ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(deftemplate Seleccion
  (slot s
    (type SYMBOL)
    (allowed-symbols S N)
  )
)

;;;;;;;;;; Inicialización ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(deffacts Entrevista_rama
  (Obtencion_Rama(continuar s))
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;; Obtención de datos ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  Reglas para obtener los datos necesarios para realizar el razonamiento. Se preguntarán todo lo     ;
;  requerido a menos que el usuario decida obtener una recomendación sin responder a todas las        ;
;  preguntas. Si el usuario no conoce la respuesta a una pregunta o decide no responderla escribiendo ;
;  ns, se eliminará dicha respuesta una vez terminada pues no es una respuesta útil.                  ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;; Reglas para hacer la primera pregunta ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule trabajador
  (declare (salience 1))
  (Modulo (nombre ramas))
  ?f<-(Pregunta_Rama(n 1)(util 0) (puntuada N))
  (Obtencion_Rama(continuar s))
  =>
  (retract ?f)
  (assert (Pregunta_Rama(n 1)(util 1)))
  (printout t "--- Inicio de la entrevista ---"  crlf)
  (printout t "Eres trabajador? Responde mucho poco normal o ns (no se | siguiente pregunta):"  crlf)
  (assert (Respuesta (tipo trabajador) (r (read))))
  ;;;;(assert (Trabajador (t (read))))
)

(defrule terminar_primera
  (declare (salience 1))
  (Modulo (nombre ramas))
  ?f<- (Obtencion_Rama(continuar s))
  ?g<- (Pregunta_Rama(n 1) (util 1) (puntuada N))
  ?h<- (Pregunta_Rama(n 2) (util -1) (puntuada N))
  =>
  (retract ?f ?g ?h)
  (printout t "Desea continuar? (s o n): "  crlf)
  (bind ?r (read))
  (if (eq ?r n) then 
  (printout t "--- Fin de la entrevista ---" crlf "Por favor espere un momento mientras el sistema razona."  crlf))
  (assert (Obtencion_Rama(continuar ?r)))
  (assert (Pregunta_Rama(n 1) (util 1)))
  (assert (Pregunta_Rama(n 2) (util 0)))
)

;;;;;;;;;; Reglas para hacer la segunda pregunta ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule nota
  (declare (salience 2))
  (Modulo (nombre ramas))
  ?f<-(Pregunta_Rama(n 2)(util 0) (puntuada N))
  (Obtencion_Rama(continuar s))
  =>
  (retract ?f)
  (assert (Pregunta_Rama(n 2) (util 1)))
  (printout t "Cual es tu noda media? Responda alta media baja o ns (no se | siguiente pregunta):"  crlf)
  (assert (Respuesta (tipo nota) (r (read))))
)

(defrule terminar_segunda
  (declare (salience 2))
  (Modulo (nombre ramas))
  ?f<- (Obtencion_Rama(continuar s))
  ?g<- (Pregunta_Rama(n 2) (util 1) (puntuada N))
  ?h<- (Pregunta_Rama(n 3) (util -1) (puntuada N))
  =>
  (retract ?f ?g ?h)
  (printout t "Desea continuar? (s o n): "  crlf)
  (bind ?r (read))
  (if (eq ?r n) then 
  (printout t "--- Fin de la entrevista ---" crlf "Por favor espere un momento mientras el sistema razona."  crlf))
  (assert (Obtencion_Rama(continuar ?r)))
  (assert (Pregunta_Rama(n 2) (util 1)))
  (assert (Pregunta_Rama(n 3) (util 0)))
)

;;;;;;;;;; Reglas para hacer la tercera pregunta ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule futuro
  (declare (salience 3))
  (Modulo (nombre ramas))
  ?f<-(Pregunta_Rama(n 3)(util 0) (puntuada N))
  (Obtencion_Rama(continuar s))
  =>
  (retract ?f)
  (assert (Pregunta_Rama(n 3) (util 1)))
  (printout t "Donde te gustaria trabajar? Responde docencia empresa_privada empresa_publica o ns (no se | siguiente pregunta):"  crlf)
  (assert (Respuesta (tipo futuro) (r (read))))
)

(defrule terminar_tercera
  (declare (salience 3))
  (Modulo (nombre ramas))
  ?f<- (Obtencion_Rama(continuar s))
  ?g<- (Pregunta_Rama(n 3) (util 1) (puntuada N))
  ?h<- (Pregunta_Rama(n 4) (util -1) (puntuada N))
  =>
  (retract ?f ?g ?h)
  (printout t "Desea continuar? (s o n): "  crlf)
  (bind ?r (read))
  (if (eq ?r n) then 
  (printout t "--- Fin de la entrevista ---" crlf "Por favor espere un momento mientras el sistema razona."  crlf))
  (assert (Obtencion_Rama(continuar ?r)))
  (assert (Pregunta_Rama(n 3) (util 1)))
  (assert (Pregunta_Rama(n 4) (util 0)))
)

;;;;;;;;;; Regla para hacer la cuarta pregunta ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule hardware
  (declare (salience 4))
  (Modulo (nombre ramas))
  ?f<-(Pregunta_Rama(n 4)(util 0) (puntuada N))
  (Obtencion_Rama(continuar s))
  =>
  (retract ?f)
  (assert (Pregunta_Rama(n 4) (util 1)))
  (printout t "Te gusta el hardware? Responde si no o ns (no se | siguiente pregunta):"  crlf)
  (assert (Respuesta (tipo hardware) (r (read))))
)

(defrule terminar_cuarta
  (declare (salience 4))
  (Modulo (nombre ramas))
  ?f<- (Obtencion_Rama(continuar s))
  ?g<- (Pregunta_Rama(n 4) (util 1) (puntuada N))
  ?h<- (Pregunta_Rama(n 5) (util -1) (puntuada N))
  =>
  (retract ?f ?g ?h)
  (printout t "Desea continuar? (s o n): "  crlf)
  (bind ?r (read))
  (if (eq ?r n) then 
  (printout t "--- Fin de la entrevista ---" crlf "Por favor espere un momento mientras el sistema razona."  crlf))
  (assert (Obtencion_Rama(continuar ?r)))
  (assert (Pregunta_Rama(n 4) (util 1)))
  (assert (Pregunta_Rama(n 5) (util 0)))
)

;;;;;;;;;; Regla para hacer la quinta pregunta ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule mates
  (declare (salience 5))
  (Modulo (nombre ramas))
  ?f<-(Pregunta_Rama(n 5) (util 0) (puntuada N))
  (Obtencion_Rama(continuar s))
  =>
  (retract ?f)
  (assert (Pregunta_Rama(n 5) (util 1)))
  (printout t "Te gustan las matematicas? Responde si no o ns (no se | siguiente pregunta):"  crlf)
  (assert (Respuesta (tipo matematicas) (r (read))))
)

;;;;;;;;;; Regla para terminar la entrevista ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule terminar_entrevista
  (declare (salience 5))
  (Modulo (nombre ramas))
  ?f<- (Obtencion_Rama(continuar s))
  ?g<- (Pregunta_Rama(n 5) (util 1) (puntuada N))
  =>
  (retract ?f ?g)
  (printout t "--- Fin de la entrevista ---" crlf "Por favor espere un momento mientras el sistema razona."  crlf)
  (assert (Obtencion_Rama(continuar n)))
  (assert (Pregunta_Rama(n 5) (util 1)))
)

;;;;;;;;;; Regla para borrar información innecesaria ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule respuesta_inutil
  (declare (salience 100))
  (Modulo (nombre ramas))
  (Obtencion_Rama(continuar n))
  ?f<-(Pregunta_Rama(n ?orden) (util 1) (puntuada N))
  (Es_Pregunta (tipo ?tipo) (n ?orden))
  ?g<-(Respuesta (tipo ?tipo) (r ns))
  =>
  (retract ?f ?g)
  (assert (Pregunta_Rama(n ?orden)(util 0)))
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;; Razonamiento ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  Reglas para realizar el razonamiento a partir de los datos obtenidos. Se realizará mediante una    ;
;  variación del razonamiento probabilístico, de forma que en vez de probabilidad se usará un grado   ;
;  de afinidad que tomará valores de 0 a 100, recomendando aquella(s) rama(s) que más alto valor      ;
;  tomen, de acuerdo con el árbol de clasificación obtenido. A diferencia del razonamiento            ;
;  probabilístico, cada rama partirá con una puntuación de 0 e irá sumando puntos de acuerdo con      ;
;  las respuestas dadas por el usuario.                                                               ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;; Aviso de la precisión del resultado por falta de datos ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule calidad_respuesta_rama
  (declare (salience 60))
  (Modulo (nombre ramas))
  (not (Obtencion_Rama(continuar s)))
  (Pregunta_Rama(n 1) (util ?u1) (puntuada N))
  (Pregunta_Rama(n 2) (util ?u2) (puntuada N))
  (Pregunta_Rama(n 3) (util ?u3) (puntuada N))
  (Pregunta_Rama(n 4) (util ?u4) (puntuada N))
  (Pregunta_Rama(n 5) (util ?u5) (puntuada N))
  =>
  (bind ?cuenta (+ ?u1 ?u2))
  (bind ?cuenta (+ ?cuenta ?u3))
  (bind ?cuenta (+ ?cuenta ?u4))
  (bind ?cuenta (+ ?cuenta ?u5))
  (if (neq ?cuenta 5) then (printout t "No has respondido a todas las preguntas, la recomendacion podria no ser acertada" crlf crlf))
)

;;;;;;;;;; Obtiene puntuación por cada pregunta ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule puntuar_rama
  (declare (salience 50))
  (Modulo (nombre ramas))
  (Obtencion_Rama(continuar n))
  ?f<-(Pregunta_Rama(n ?orden) (util 1) (puntuada N))
  (Es_Pregunta (tipo ?tipo) (n ?orden))
  (Respuesta (tipo ?tipo) (r ?r))
  ?g<-(Puntuacion (rama CSI) (p ?csi))
  ?h<-(Puntuacion (rama IS) (p ?is))
  ?i<-(Puntuacion (rama IC) (p ?ic))
  ?j<-(Puntuacion (rama SI) (p ?si))
  ?k<-(Puntuacion (rama TI) (p ?ti))
  (Valor_Pregunta (rama CSI) (pregunta ?orden) (respuesta ?r)(p ?p_csi))
  (Valor_Pregunta (rama IS) (pregunta ?orden) (respuesta ?r)(p ?p_is))
  (Valor_Pregunta (rama IC) (pregunta ?orden) (respuesta ?r)(p ?p_ic))
  (Valor_Pregunta (rama SI) (pregunta ?orden) (respuesta ?r)(p ?p_si))
  (Valor_Pregunta (rama TI) (pregunta ?orden) (respuesta ?r)(p ?p_ti))
  =>
  (retract ?f ?g ?h ?i ?j ?k)
  (assert (Pregunta_Rama(n ?orden) (util 1) (puntuada S))
  (Puntuacion (rama CSI) (p (+ ?csi ?p_csi)))
  (Puntuacion (rama IS) (p (+ ?is ?p_is)))
  (Puntuacion (rama IC) (p (+ ?ic ?p_ic)))
  (Puntuacion (rama SI) (p (+ ?si ?p_si)))
  (Puntuacion (rama TI) (p (+ ?ti ?p_ti))))
)

;;;;;;;;;; Incluye en el motivo una justificación ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule justificar
  (declare (salience 50))
  (Modulo (nombre ramas))
  (not (Obtencion_Rama(continuar s)))
  ?f<-(Pregunta_Rama(n ?orden) (util 1) (puntuada S))
  (Es_Pregunta (tipo ?tipo) (n ?orden))
  (Respuesta (tipo ?tipo) (r ?r))
  (Justificaciones (n ?orden) (texto ?texto))
  (Valor_Pregunta (rama CSI) (pregunta ?orden) (respuesta ?r)(p ?p_csi))
  (Valor_Pregunta (rama IS) (pregunta ?orden) (respuesta ?r)(p ?p_is))
  (Valor_Pregunta (rama IC) (pregunta ?orden) (respuesta ?r)(p ?p_ic))
  (Valor_Pregunta (rama SI) (pregunta ?orden) (respuesta ?r)(p ?p_si))
  (Valor_Pregunta (rama TI) (pregunta ?orden) (respuesta ?r)(p ?p_ti))
  ?g<-(Consejo_Rama (rama CSI) (motivo ?motivo_csi) (experto ?experto_csi))
  ?h<-(Consejo_Rama (rama IS) (motivo ?motivo_is) (experto ?experto_is))
  ?i<-(Consejo_Rama (rama IC) (motivo ?motivo_ic) (experto ?experto_ic))
  ?j<-(Consejo_Rama (rama SI) (motivo ?motivo_si) (experto ?experto_si))
  ?k<-(Consejo_Rama (rama TI) (motivo ?motivo_ti) (experto ?experto_ti))
  =>
  (bind ?justificacion (str-cat ". " ?texto ?r))
  (retract ?f)
  (if (neq ?p_csi 0) then 
    (and
      (retract ?g)
      (assert (Consejo_Rama (rama CSI) (motivo (str-cat ?motivo_csi ?justificacion)) (experto ?experto_csi)))
    )
  )
  (if (neq ?p_is 0) then 
    (and
      (retract ?h)
      (assert (Consejo_Rama (rama IS) (motivo (str-cat ?motivo_is ?justificacion)) (experto ?experto_is)))
    )
  )
  (if (neq ?p_ic 0) then 
    (and
      (retract ?i)
      (assert (Consejo_Rama (rama IC) (motivo (str-cat ?motivo_ic ?justificacion)) (experto ?experto_ic)))
    )
  )
  (if (neq ?p_si 0) then 
    (and
      (retract ?j)
      (assert (Consejo_Rama (rama SI) (motivo (str-cat ?motivo_si ?justificacion)) (experto ?experto_si)))
    )
  )
  (if (neq ?p_ti 0) then 
    (and
      (retract ?k)
      (assert (Consejo_Rama (rama TI) (motivo (str-cat ?motivo_ti ?justificacion)) (experto ?experto_ti)))
    )
  )
)

;;;;;;;;;; Marca un consejo como válido cambiando el nombre del experto ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule consejo_valido
  (declare (salience 80))
  (Modulo (nombre ramas))
  (not (Obtencion_Rama(continuar s)))
  ?f<-(Consejo_Rama (rama ?rama) (motivo ?motivo) (experto "Clips"))
  (Puntuacion (rama ?rama) (p ?p))
  (test (neq ?p 0))
  =>
  (retract ?f)
  (assert (Consejo_Rama (rama ?rama) (motivo (str-cat ?motivo "")) (experto "A. Romero")))
)

;;;;;;;;;; Comprueba que la puntuación siga dentro de los estándares ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule puntuacion_valida
  (declare (salience 80))
  (Modulo (nombre ramas))
  (not (Obtencion_Rama(continuar s)))
  ?f<-(Puntuacion (rama ?rama) (p ?p))
  (test (> ?p 100))
  =>
  (retract ?f)
  (assert (Puntuacion (rama ?rama) (p 100)))
)

;;;;;;;;;; Asigna el grado de afinidad y da por finalizado el razonamiento ;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule fin_razonamiento
  (declare (salience 20))
  (Modulo (nombre ramas))
  (not (Obtencion_Rama(continuar s)))
  ;;(not (Pregunta_Rama(n ?) (util ?) (puntuada ?)))
  ?g<-(Consejo_Rama (rama CSI) (motivo ?motivo_csi) (experto ?experto_csi))
  ?h<-(Consejo_Rama (rama IS) (motivo ?motivo_is) (experto ?experto_is))
  ?i<-(Consejo_Rama (rama IC) (motivo ?motivo_ic) (experto ?experto_ic))
  ?j<-(Consejo_Rama (rama SI) (motivo ?motivo_si) (experto ?experto_si))
  ?k<-(Consejo_Rama (rama TI) (motivo ?motivo_ti) (experto ?experto_ti))
  (Puntuacion (rama CSI) (p ?p_csi))
  (Puntuacion (rama IS) (p ?p_is))
  (Puntuacion (rama IC) (p ?p_ic))
  (Puntuacion (rama SI) (p ?p_si))
  (Puntuacion (rama TI) (p ?p_ti))
  (Justificaciones (n 0) (texto ?texto))
  => 
  (retract ?g ?h ?i ?j ?k)
  (bind ?texto (str-cat ". " ?texto))
  (bind ?jus_csi (str-cat ?texto ?p_csi))
  (bind ?jus_is (str-cat ?texto ?p_is))
  (bind ?jus_ic (str-cat ?texto ?p_ic))
  (bind ?jus_si (str-cat ?texto ?p_si))
  (bind ?jus_ti (str-cat ?texto ?p_ti))
  (assert (Razonamiento (finalizado S)))
  (assert (Consejo_Rama (rama CSI) (motivo (str-cat ?motivo_csi ?jus_csi)) (experto ?experto_csi)))
  (assert (Consejo_Rama (rama IS) (motivo (str-cat ?motivo_csi ?jus_is)) (experto ?experto_is)))
  (assert (Consejo_Rama (rama IC) (motivo (str-cat ?motivo_csi ?jus_ic)) (experto ?experto_ic)))
  (assert (Consejo_Rama (rama SI) (motivo (str-cat ?motivo_csi ?jus_si)) (experto ?experto_si)))
  (assert (Consejo_Rama (rama TI) (motivo (str-cat ?motivo_csi ?jus_ti)) (experto ?experto_ti)))
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;; Fin del razonamiento ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  Se muestra por pantalla la rama aconsejada junto al motivo                                         ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;; Selecciona la mejor rama ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule mejor_rama
  (declare (salience 300))
  (Modulo (nombre ramas))
  (Razonamiento (finalizado S))
  ?f<-(Consejo_Rama (rama ?rf) (motivo ?) (experto ?))
  ?g<-(Consejo_Rama (rama ?rg) (motivo ?) (experto ?))
  ?h<-(Consejo_Rama (rama ?rh) (motivo ?) (experto ?))
  ?i<-(Consejo_Rama (rama ?ri) (motivo ?) (experto ?))
  ?k<-(Consejo_Rama (rama ?rk) (motivo ?) (experto ?))
  (Puntuacion (rama ?rf) (p ?pf))
  (Puntuacion (rama ?rg) (p ?pg))
  (Puntuacion (rama ?rh) (p ?ph))
  (Puntuacion (rama ?ri) (p ?pi))
  (Puntuacion (rama ?rk) (p ?pk))
  (test (> ?pk ?pf))
  (test (> ?pk ?pg))
  (test (> ?pk ?ph))
  (test (> ?pk ?pi))
  (test (neq ?rf ?rg))
  (test (neq ?rf ?rh))
  (test (neq ?rf ?ri))
  (test (neq ?rg ?rh))
  (test (neq ?rg ?ri))
  (test (neq ?rh ?ri))
  =>
  (retract ?f ?g ?h ?i)
  (assert (Seleccion (s S)))
)

;;;;;;;;;; Selecciona las dos mejores ramas en caso de empate ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule empate_ramas
  (declare (salience 300))
  (Modulo (nombre ramas))
  (Razonamiento (finalizado S))
  ?f<-(Consejo_Rama (rama ?rf) (motivo ?) (experto ?))
  ?g<-(Consejo_Rama (rama ?rg) (motivo ?) (experto ?))
  ?h<-(Consejo_Rama (rama ?rh) (motivo ?) (experto ?))
  ?i<-(Consejo_Rama (rama ?ri) (motivo ?) (experto ?))
  ?k<-(Consejo_Rama (rama ?rk) (motivo ?) (experto ?))
  (Puntuacion (rama ?rf) (p ?pf))
  (Puntuacion (rama ?rg) (p ?pg))
  (Puntuacion (rama ?rh) (p ?ph))
  (Puntuacion (rama ?ri) (p ?pi))
  (Puntuacion (rama ?rk) (p ?pk))
  (test (> ?pk ?pf))
  (test (> ?pk ?pg))
  (test (> ?pk ?ph))
  (test (= ?pk ?pi))
  (test (> ?pk 0))
  (test (neq ?rf ?rg))
  (test (neq ?rf ?rh))
  (test (neq ?rg ?rh))
  (test (neq ?rk ?ri))
  =>
  (retract ?f ?g ?h)
  (assert (Seleccion (s S)))
)

;;;;;;;;;; Muestra la rama y su motivo ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule final
  (declare (salience 300))
  (Modulo (nombre ramas))
  ?g<-(Seleccion (s S))
  ?f<-(Consejo_Rama (rama ?rama) (motivo ?motivo) (experto ?experto))
  (test (neq ?experto "Clips"))
  (test (neq ?rama null))
  (Es_Rama (rama ?rama) (nombre ?nombre_rama))
  =>
  (printout t "El experto " ?experto " te recomienda la rama " ?nombre_rama " con el siguiente mensaje: " crlf)
  (printout t ?motivo crlf)
  (retract ?f ?g)
) 

;;;;;;;;;; Indica que no se ha podido realizar el razonamiento ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule final_fallo
  (declare (salience 300))
  (Modulo (nombre ramas))
  (Seleccion (s S))
  (Consejo_Rama (rama ?) (motivo ?) (experto ?exp))
  (test (neq ?exp "A. Romero"))
  =>
  (printout t " No has dado suficiente informacion como para poder aconsejarte una rama" crlf)
  (retract *)
) 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;