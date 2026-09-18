# Nombre del juego
## 1. High Concept

Tacocalipsis es un action-shooter de supervivencia 2D de vista superior (Top-Down) donde un taquero mexicano debe defender y trasladar estratégicamente su carrito de tacos mientras combate caóticas hordas de comida callejera mutante y diabólica. El juego combina la progresión frenética de recolección de experiencia y selección de armas con una mecánica única de escolta activa, donde la supervivencia depende de proteger simultáneamente la vida del personaje y la integridad del carrito.

---

## 2. Experiencia central
## 3. Perfil de jugador
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

---

## 7. Mundo y conflicto

 ### Entorno y Escenario:
 La historia y la acción se desarrollan en una calle ordinaria de México la cuál actúa como la arena de combate para todas las oleadas del juego, incorporando elementos urbanos decorativos.
 
 ### Estilo Visual y Atmósfera:
 El mundo presenta un estilo gráfico en 2D con vista desde arriba (top-down), caracterizado por un tono animado y caricaturesco. La comida mutante, la cual posee un diseño tétrico pero caricaturizado, manteniendo un tono humorístico y ligero a pesar de la amenaza.
 
 ### Identidad Narrativa del Entorno:
 Es un entorno urbano de comida callejera mexicana donde la vida cotidiana de un puesto de tacos se ve interrumpida por un brote de comida viviente y violenta.

---

## 8. Interfaz conceptual
 ### Origen del Problema:
 El conflicto se desencadena por un intento desesperado del Taquero por mejorar y perfeccionar sus recetas para incrementar sus ventas, al experimentar e intentar innovar en su cocina, los experimentos salen mal, desatando un caos masivo que cobra vida y transforma los platillos tradicionales en entes mutantes y agresivos.
 ### El Conflicto Recursivo:
 El conflicto no ocurre una sola vez, sino que es un ciclo recurrente. Cada uno de los niveles o intentos del Taquero por crear un nuevo producto alimenticio genera una nueva crisis, al elaborar un nuevo platillo, desencadena una nueva plaga de comida mutante que le toca limpiar y erradicar personalmente.
 ### Conflicto de Juego:
 El Taquero debe enfrentarse y sobrevivir a 5 oleadas continuas de hordas de comida malvada (Tacos, Burritos, Tamales, Elotes y Chicharrones). Para contener la amenaza, el personaje debe luchar por su propia vida, al mismo tiempo que protege y defiende su puesto de comida.
 ### El Cierre y Final Abierto:
 Tras erradicar la quinta oleada y derrotar a los jefes correspondientes, el Taquero se enfrenta al desenlace de su crisis inicial solo para ser abordado por un misterioso personaje proveniente de la India, el cuál le presenta una propuesta enigmática, dejando el conflicto principal en pausa y estableciendo un final abierto.

---

## 9. MVP

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
