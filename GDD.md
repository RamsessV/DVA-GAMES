# Tacocalipsis
## 1. High Concept

Tacocalipsis es un action-shooter de supervivencia 2D de vista superior (Top-Down) donde un taquero mexicano debe defender y trasladar estratégicamente su carrito de tacos mientras combate caóticas hordas de comida callejera mutante y diabólica. El juego combina la progresión frenética de recolección de experiencia y selección de armas con una mecánica única de escolta activa, donde la supervivencia depende de proteger simultáneamente la vida del personaje y la integridad del carrito.

---

## 2. Experiencia central

La experiencia central de Tacocalipsis se define como una tensión táctica de defensa dual impregnada de humor absurdo y progresión frenética.
A diferencia de los juegos de supervivencia tradicionales donde el jugador solo se preocupa por su propia vida, la experiencia de Tacocalipsis gira en torno a proteger también el carrito. En general, la experiencia se puede describir con los siguientes puntos:

1. **Tensión de Movilidad**: La experiencia combina la adrenalina del combate ágil con la responsabilidad de proteger y reposicionar el carrito. El jugador experimenta un dilema constante entre quedarse a luchar en una posición o sacrificar su capacidad de ataque para empujar el carrito a una zona segura detrás de la cobertura del mapa.
2. **Progresión Gratificante y Caótica**: Sensación constante de empoderamiento visual y numérico. Cada oleada eleva el caos en pantalla con hordas de comida mutante atacando, pero el ciclo de recolección de experiencia y selección rápida de mejoras mantiene al jugador en un estado de flujo dinámico.
3. **Tono Humorístico y Cómico**: Una narrativa absurda de comida contra taquero transmitida mediante la estética animada y viñetas de historieta, lo que amortigua la frustración de la derrota y refuerza el deseo de reintentar.

---

## 3. Perfil de jugador

## Datos demográficos:

1. Edad: 16 a 35 años.
2. Plataforma: PC.
3. Segmento: Jugadores de perfil casual que disfrutan de partidas rápidas, independientes y altamente rejugables.

## Principales perfiles a los que va dirigido este juego:

Aquellos que buscan experimentar con combinaciones de armas y mejoras, optimizar el uso de coberturas y superar todas las oleadas sin perder el carrito.

Los atraídos por el bucle de juego frenético que requiere reflejos rápidos, pero que a la vez exige decisiones estratégicas en tiempo real como el cuándo curar, a quién proteger o cuándo mover el carrito.

## Posibles intereses del jugador:

1. Interés de Género: Fans de títulos de hordas y supervivencia como Vampire Survivors, Brotato o Enter the Gungeon.

2. Aprecio por el Humor y el Estilo Visual: Jugadores atraídos por temáticas satíricas, la cultura pop, la gastronomía mexicana y el arte cómico en 2D.

3. Estilo de Juego Preferido: Sesiones de juego de corta a media duración, de máximo 10 minutos por partida, donde la curva de aprendizaje es inmediata pero dominar la mecánica requiere práctica.

## Justificación de la estructura del juego

- **Jugador**: Busca partidas ágiles y gratificación rápida.
  - **Estructura**: Estructura dividida en 5 oleadas temáticas cortas con jefes finales en lugar de una sesión infinita y monótona.
- **Jugador**: Quiere decisiones tácticas con impacto real.
  - **Estructura**: Mecánica del Carrito Movible, la cual fuerza al jugador a evaluar el mapa y posicionarse, evitando que solo corra en círculos.
- **Jugador**: Desea rejugabilidad y sensación de avance.
  - **Estructura**: Sistema de Selección de 3 Mejoras por Nivel, lo que permite adaptar el estilo de combate (velocidad, vida o poder de fuego) según la amenaza de la oleada.
- **Jugador**: Busca una narrativa ligera que no interrumpa el ritmo.
  - **Estructura**: Historieta en Viñetas entre oleadas, lo que entrega contexto narrativo cómico de forma visual y rápida antes de volver a la acción.

## 4. Core Loop
### 4.1. Descripción Breve
En *Tacocalipsis*, el jugador asume el rol del Taquero, cuya meta es sobrevivir a 5 oleadas de comida mutante mientras protege su herramienta de trabajo: el carrito de tacos. El ciclo fundamental combina el **combate táctico y posicionamiento dual** (cubrir al personaje y al carrito) con la **recolección de recursos (XP y munición)**, lo que alimenta la **mejora constante en el nivel de poder del personaje** mediante selecciones *roguelite* de subida de nivel.

---

### 4.2. Flujo Estructurado del Bucle

#### A. Inicio de Oleada y Combate Activo
* **Entrada al Mapa:** El jugador inicia en la calle con el personaje y el carrito situados en el escenario.
* **Acción de Combate Dual:**
  * **Ataque:** Disparar con el arma principal (pistola) a distancia o atacar con el cuchillo (cuerpo a cuerpo) de cerca.
  * **Navegación:** Mover al Taquero o sujetar el carrito para reubicarlo (inhabilitando el ataque mientras se empuja).
  * **Cobertura:** Usar los objetos fijos del mapa (autos, postes) para bloquear proyectiles enemigos.
* **Eliminación y Despliegue de Drops:** Al morir, los enemigos sueltan **Orbes de XP** y, con cierta probabilidad, **Munición**.

#### B. Ciclo de Modificación y Progreso (Subida de Nivel)
* **Recolección de Recursos:** Recoger XP para llenar la barra de progreso del HUD.
* **Pausa Táctica (Level Up):** Al llenar la barra, el juego despliega un menú con **3 opciones aleatorias**:
  1. *Curación al personaje.*
  2. *Aumento de velocidad de movimiento.*
  3. *Obtención / Mejora del arma principal* (conservando el cuchillo como arma secundaria).
* **Retorno al Combate:** Se reanuda la acción con la mejora aplicada.

#### C. Resolución de Oleada y Transición
* **Aparición del Jefe:** Al resistir la horda, se invoca al Jefe Mutante de la categoría (Taco, Burrito, Tamal, Elote o Chicharrón).
* **Derrota del Jefe:**
  * La vida del carrito se **restaura automáticamente al 100%**.
  * **Elección de Mejora Pasiva:** Aumentar la Vida Máxima (+Max HP) del **Taquero** O del **Carrito**.
  * **Narrativa:** Despliegue de la **pantalla de historieta** explicativa del nuevo platillo fallido.
* **Evaluación de Progreso:**
  * **Oleadas 1 a 4:** Transición inmediata al siguiente nivel de comida.
  * **Oleada 5 (Victoria Final):** Despliegue de la historieta final (vendedor de la India) y créditos.

#### D. Condición de Derrota
* Si la vida del **Taquero** llega a **0 HP** $\rightarrow$ **Game Over**.
* Si la vida del **Carrito** llega a **0 HP** $\rightarrow$ **Game Over**.

#### E. Condición de Victoria
* Si se sobrevive a las 5 oleadas y se derrota al jefe final, el jugador obtiene la victoria.

---

### 4.3. Matriz de Decisiones y Tiempo por Fases de Juego

| Fase de Juego | Frecuencia | Acción Principal del Jugador | Recompensa e Impacto en la Partida |
| :--- | :--- | :--- | :--- |
| **Acción Inmediata (Momento a Momento)** | Todo el tiempo (Segundos) | Disparar, atacar con el cuchillo, cubrirse en el mapa y cambiar de lugar el carrito de tacos. | Mantiene con vida al Taquero y al carrito mientras elimina a las hordas mutantes. |
| **Avance y Mejoras (En la Oleada)** | Cada 1 a 2 minutos | Recoger la experiencia del suelo y elegir 1 de las 3 opciones al subir de nivel (Curación, +Velocidad o Mejora de Arma). | Aumenta la potencia de fuego, el rendimiento del personaje o recupera salud en medio del combate. |
| **Cierre de Nivel (Final de Oleada)** | Cada 5 a 8 minutos | Enfrentar y derrotar al Jefe Mutante del nivel (Taco, Burrito, Tamal, Elote o Chicharrón) y leer la historieta. | Restaura la vida del carrito al 100%, otorga aumento de vida máxima (al Taquero o al Carrito) y desbloquea la siguiente oleada. |

---

## 5. Mecánicas principales
* **Mecánica de Cobertura Dinámica:** El mapa contiene objetos fijos (autos estacionados, puestos, postes de luz) que bloquean las líneas de visión y detienen proyectiles enemigos. Tanto el Taquero como el carrito pueden ocultarse tras ellos para evitar daño entrante.
* **Mecánica de Empuje y Custodia del Carrito:** El carrito de tacos actúa como una entidad móvil interactiva con su propia barra de salud. Al acercarse, el jugador puede presionar un botón contextual para empujarlo y reubicarlo. Durante el tiempo en que se empuja el carrito, el jugador pierde la capacidad de atacar.
* **Sistema de Armamento Dual (Principal y Secundaria):** El jugador inicia la partida únicamente con un Cuchillo de cocina como arma de cuerpo a cuerpo. Al seleccionar la primera mejora de arma en la subida de nivel, recibe una Pistola sencilla como arma principal de fuego. El cuchillo permanece permanentemente mapeado como arma secundaria para combate cercano, mientras que las posteriores mejoras de arma actualizan y potencian el arma principal.
* **Mecánica de Selección Roguelite (3 Opciones):** Cada vez que la barra de XP se llena, se pausa el combate y se presenta una interfaz de selección fija con 3 cartas aleatorias: Curación de Personaje, Aumento de Velocidad, o Mejora/Evolución de Arma Principal.
* **Gestión de Recursos y Probabilidad de Drops:** La Experiencia (XP) es dropeada obligatoriamente por los enemigos derrotados. La Munición es dropeada de forma probabilística (RNG) para recargar el arma principal en uso.
* **Sistema de Restauración de Salud Post-Jefe:** Al eliminar al jefe de cada oleada, el carrito recupera instantáneamente el 100% de sus Puntos de Vida (HP) y se activa la selección especial de desarrollo (+Max HP al Taquero O al Carrito).

---

## 6. Dinámicas esperadas

- **Gestión del Riesgo:** La dinámica central nace de la necesidad de dividir la atención entre la supervivencia propia y la integridad del carrito. El jugador constantemente pensará si mantenerse en un tiroteo activo o arriesgarse a quedar indefenso durante unos segundos para mover el carrito antes de que sea acorralado por la horda.

- **Priorización Táctica de Bajas:** Dado que el arma principal consume munición limitada disponible en drops, los jugadores tenderán a reservar sus disparos para enemigos a distancia o jefes, usando el cuchillo secundario para despachar mutantes solitarios o débiles que se acerquen.

- **Construcción de Build y Estilo de Juego Adaptativo:** Dependiendo de las 3 opciones recibidas al subir de nivel, los jugadores adaptarán su estrategia: una ruta enfocada en Velocidad favorecerá un estilo de *hit-and-run*, moviendo rápido el carrito, mientras que una ruta de Armamento priorizará la eliminación rápida de amenazas antes de que alcancen el puesto de tacos.

- **Uso Táctico del Mapa y Embudo de Enemigos (Chokepoints):** Los jugadores utilizarán activamente los objetos fijos del escenario no solo como cobertura defensiva contra proyectiles, sino como barreras para atraer a las hordas hacia pasillos estrechos y optimizar el daño en área.

- **Estrategia de Desarrollo Post-Jefe:** Al final de cada oleada, el jugador deberá evaluar el rendimiento de su partida para decidir si invierte el bonificador en la salud máxima del Taquero (si tiende a recibir mucho daño esquivando) o en la salud máxima del Carrito (si prefiere usar el carrito como escudo pesado en el centro del mapa).

---

## 7. Mundo y conflicto

### 7.1 Origen del Problema

El conflicto se desencadena por un intento desesperado del Taquero por mejorar y perfeccionar sus recetas para incrementar sus ventas. Al experimentar e intentar innovar en su cocina, los experimentos salen mal, desatando un caos masivo que cobra vida y transforma los platillos tradicionales en entes mutantes y agresivos.

### 7.2 Entorno y Escenario

La historia y la acción se desarrollan en una calle ordinaria de México, la cual actúa como la arena de combate para todas las oleadas del juego, incorporando elementos urbanos decorativos.

### 7.3 Estilo Visual y Atmósfera

El mundo presenta un estilo gráfico en 2D con vista desde arriba (*top-down*), caracterizado por un tono animado y caricaturesco. La comida mutante posee un diseño tétrico pero caricaturizado, manteniendo un tono humorístico y ligero a pesar de la amenaza.

### 7.4 Identidad Narrativa del Entorno

Es un entorno urbano de comida callejera mexicana donde la vida cotidiana de un puesto de tacos se ve interrumpida por un brote de comida viviente y violenta.

### 7.5 El Cierre

Tras erradicar la quinta oleada y derrotar a los jefes correspondientes, el Taquero se enfrenta al desenlace de su crisis inicial, solo para ser abordado por un misterioso personaje proveniente de la India, el cual le presenta una propuesta enigmática, dejando el conflicto principal en pausa y estableciendo un final abierto.

---

## 8. Interfaz conceptual
### 8.1 Pantalla Principal de Juego (*In-Game HUD*)

Durante la partida, la interfaz mantendrá un diseño limpio y despejado con vista estilo *top-down*, mostrando los siguientes indicadores:

- **Barra de Vida del Taquero:** Ubicada en la esquina superior izquierda. Indica la salud actual del jugador.

- **Barra de Vida del Carrito:** Ubicada justo debajo de la barra del Taquero (o sobre la estructura del carrito), permitiendo monitorear su estado crítico.

- **Barra / Contador de Experiencia (XP):** Barra horizontal de progreso para visualizar el nivel actual y cuánto falta para la siguiente subida de nivel.

- **Visualización de Armas:** Ubicada en la esquina inferior derecha, mostrando el arma principal equipada (pistola/mejoras) y el arma secundaria disponible (cuchillo).

- **Contador de Munición:** Contador numérico posicionado junto al ícono del arma principal activa.

### 8.2 Menú de Subida de Nivel (*Level Up Pop-up*)

Pantalla emergente que pausa la acción al subir de nivel, desplegando 3 opciones seleccionables:

1. Curación al personaje.
2. Aumento de velocidad de movimiento.
3. Obtención o mejora de arma principal.

### 8.3 Formato Narrativo

Entre cada oleada y al final del juego, la interfaz desplegará un formato de cómic/historieta interactiva con viñetas ilustradas, texto desplegable y un botón para avanzar o saltar la secuencia.

### 8.4 Pantallas de Estado de Fin de Juego

- **Pantalla de Victoria:** Desplegada tras vencer al jefe de la quinta oleada, dando paso a la historieta final.

- **Pantalla de Derrota (*Game Over*):** Se activa si la salud del Taquero o la del Carrito llegan a cero, ofreciendo las opciones de **"Reintentar"** o **"Volver al Menú Principal"**.

---

## 9. MVP

### 1. Objetivo del MVP
Validar si la combinación de **movilidad del carrito + defensa dual (personaje/carrito) + progresión de armas** resulta divertida, fluida y balanceada en un entorno de vista superior (2D Top-Down), asegurando la viabilidad del *core loop* antes de la producción completa.

---

### 2. Que contiene

####  Escenario y Entorno
* **Mapa Único:** Un tramo rectilíneo de una calle de la ciudad en vista *Top-Down*.
* **Cobertura y Obstáculos Fijos:** 3 a 4 objetos fijos en el mapa (ej. contenedores de basura, vehículos estacionados, postes) que bloquean proyectiles y paso tanto del jugador como de los enemigos.

####  Oleadas y Enemigos (Reducido a 2 Oleadas para Validación)
* **Oleada 1 – "Tacos":**
  * **Enemigo Común:** *Taco Mutante* (ataque cuerpo a cuerpo, velocidad media).
  * **Jefe:** *Gran Taco de Pastor* (tamaño mayor, alta vida, ataque de embestida recta).
* **Oleada 2 – "Burritos":**
  * **Enemigo Común:** *Burrito Diabólico* (tipo tanque, movimiento lento, golpe pesado).
  * **Jefe:** *Burrito Supremo* (alta resistencia, lanza proyectiles lentos de frijol).

####  Personaje Jugable y Mecánicas del Carrito
* **El Taquero:**
  * Movimiento en 8 direcciones.
  * Barras de vida independientes: **Vida del Taquero** y **Vida del Carrito**.
* **El Carrito de Tacos:**
  * Mecánica de agarre mediante tecla de interacción (ej. `E` / `Espacio`).
  * **Restricción:** Mientras el Taquero empuja el carrito, **NO** puede disparar ni atacar.
  * Si la vida del Taquero **O** la vida del Carrito llega a 0 $\rightarrow$ **Pantalla de Derrota (*Game Over*)**.
  * Al derrotar al Jefe de la Oleada 1 $\rightarrow$ Regeneración del 100% de la vida del carrito + Selección de mejora permanente:
    * `+20% Vida Máxima del Taquero`
    * `+20% Vida Máxima del Carrito`

####  Sistema de Combate y Armas
* **Arma Secundaria (Inicial / Fija):** *Cuchillo Taquero* (ataque cuerpo a cuerpo de corto alcance, sin consumo de munición, daño base).
* **Progreso y Subida de Nivel (XP):**
  * Los enemigos derrotados dropean orbes/gemas de **XP**.
  * Al llenar la barra de XP, el juego se pausa y despliega una ventana interactiva para elegir **1 de 3 mejoras aleatorias**:
    1. **Salud:** Curación inmediata (30% HP).
    2. **Movilidad:** +10% Velocidad de movimiento.
    3. **Arma:** Desbloquea o mejora el arma principal (*Pistola Sencilla*).
* **Arma Principal:** *Pistola Sencilla*
  * Requiere munición. Seleccionar la mejora de arma cambia a un arma mas fuerte.
* **Drops de Enemigos:**
  * XP (100% de probabilidad al morir).
  * Munición (20% de probabilidad al morir).

####  HUD
1. Barra de Vida del Taquero.
2. Barra de Vida del Carrito.
3. Barra de Experiencia y Nivel actual.
4. Icono del Arma Principal + Contador de Munición (`Cargador / Reserva`).
5. Icono del Cuchillo (Arma Secundaria).

####  Narrativa Mínima (Cómics / Historieta)
* **Pantalla de Intro:** 2 a 3 viñetas con diálogo estilo historieta donde el Taquero intenta mejorar su receta, provoca la mutación accidental y desencadena la huida de la comida.
* **Pantalla de Victoria:** 2 viñetas mostrando la derrota del segundo jefe y la aparición del vendedor callejero de la India con la propuesta misteriosa (*Cliffhanger*).

---

## 10. Riesgos y trade-offs
 ### Riesgo 1
 * **Impacto:** Alto
 * **Definición:** Desbalance en la curva de dificultad al obligar al jugador a defender dos barras de vida paralelas (personaje y carrito). Como el taquero queda indefenso al empujar el carrito, la acumulación masiva de hordas mutantes puede generar una experiencia frustrante si el jugador se siente acorralado o sin poder responder.
 * **Trade-off:** Se asume el riesgo de una curva de aprendizaje más empinada para el jugador casual y se requiere tiempo de desarrollo adicional para iterar y probar el ritmo (pacing) de las oleadas.

 ### Riesgo 2
 * **Impacto:** Medio
 * **Definición:** Al desbloquear la pistola y sus posteriores mejoras como arma principal, el cuchillo secundario puede quedar completamente sin utilidad táctica real.
 * **Trade-off:** Mantener el cuchillo como arma permanente preserva la fantasía del personaje del Taquero y garantiza que el jugador nunca quede totalmente indefenso en situaciones extremas, pero se requiere un incentivo o utilidad única al cuchillo.

 ### Riesgo 3
 * **Impacto:** Alto
 * **Definición:** Al depender de la probabilidad (drop rate) de los enemigos para obtener munición de la pistola/arma principal, una racha de mala suerte en la selección aleatoria puede dejar al jugador sin balas contra jefes o masas de enemigos.
 * **Trade-off:** Se delega el éxito de la partida a la suerte (RNG), lo que puede castigar injustamente al jugador hábil y provocar estados de imposibilidad de victoria (fail states) no merecidos, requiriendo la implementación de sistemas de protección contra malas rachas (pity systems) o mecánicas de respaldo.
