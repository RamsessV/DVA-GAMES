# Core Loop *Tacocalipsis*

## 1. Descripción Breve
En *Tacocalipsis*, el jugador asume el rol del Taquero, cuya meta es sobrevivir a 5 oleadas de comida mutante mientras protege su herramienta de trabajo: el carrito de tacos. El ciclo fundamental combina el **combate táctico y posicionamiento dual** (cubrir al personaje y al carrito) con la **recolección de recursos (XP y munición)**, lo que alimenta la **mejora constante en el nivel de poder del personaje** mediante selecciones *roguelite* de subida de nivel.

---

## 2. Flujo Estructurado del Bucle

### A. Inicio de Oleada y Combate Activo
* **Entrada al Mapa:** El jugador inicia en la calle con el personaje y el carrito situados en el escenario.
* **Acción de Combate Dual:**
  * **Ataque:** Disparar con el arma principal (pistola) a distancia o atacar con el cuchillo (cuerpo a cuerpo) de cerca.
  * **Navegación:** Mover al Taquero o sujetar el carrito para reubicarlo (inhabilitando el ataque mientras se empuja).
  * **Cobertura:** Usar los objetos fijos del mapa (autos, postes) para bloquear proyectiles enemigos.
* **Eliminación y Despliegue de Drops:** Al morir, los enemigos sueltan **Orbes de XP** y, con cierta probabilidad, **Munición**.

### B. Ciclo de Modificación y Progreso (Subida de Nivel)
* **Recolección de Recursos:** Recoger XP para llenar la barra de progreso del HUD.
* **Pausa Táctica (Level Up):** Al llenar la barra, el juego despliega un menú con **3 opciones aleatorias**:
  1. *Curación al personaje.*
  2. *Aumento de velocidad de movimiento.*
  3. *Obtención / Mejora del arma principal* (conservando el cuchillo como arma secundaria).
* **Retorno al Combate:** Se reanuda la acción con la mejora aplicada.

### C. Resolución de Oleada y Transición
* **Aparición del Jefe:** Al resistir la horda, se invoca al Jefe Mutante de la categoría (Taco, Burrito, Tamal, Elote o Chicharrón).
* **Derrota del Jefe:**
  * La vida del carrito se **restaura automáticamente al 100%**.
  * **Elección de Mejora Pasiva:** Aumentar la Vida Máxima (+Max HP) del **Taquero** O del **Carrito**.
  * **Narrativa:** Despliegue de la **pantalla de historieta** explicativa del nuevo platillo fallido.
* **Evaluación de Progreso:**
  * **Oleadas 1 a 4:** Transición inmediata al siguiente nivel de comida.
  * **Oleada 5 (Victoria Final):** Despliegue de la historieta final (vendedor de la India) y créditos.

### D. Condición de Derrota
* Si la vida del **Taquero** llega a **0 HP** $\rightarrow$ **Game Over**.
* Si la vida del **Carrito** llega a **0 HP** $\rightarrow$ **Game Over**.

---

## 3. Matriz de Decisiones y Tiempo por Fases de Juego

| Fase de Juego | Frecuencia | Acción Principal del Jugador | Recompensa e Impacto en la Partida |
| :--- | :--- | :--- | :--- |
| **Acción Inmediata (Momento a Momento)** | Todo el tiempo (Segundos) | Disparar, atacar con el cuchillo, cubrirse en el mapa y cambiar de lugar el carrito de tacos. | Mantiene con vida al Taquero y al carrito mientras elimina a las hordas mutantes. |
| **Avance y Mejoras (En la Oleada)** | Cada 1 a 2 minutos | Recoger la experiencia del suelo y elegir 1 de las 3 opciones al subir de nivel (Curación, +Velocidad o Mejora de Arma). | Aumenta la potencia de fuego, el rendimiento del personaje o recupera salud en medio del combate. |
| **Cierre de Nivel (Final de Oleada)** | Cada 5 a 8 minutos | Enfrentar y derrotar al Jefe Mutante del nivel (Taco, Burrito, Tamal, Elote o Chicharrón) y leer la historieta. | Restaura la vida del carrito al 100%, otorga aumento de vida máxima (al Taquero o al Carrito) y desbloquea la siguiente oleada. |
# MVP definido
##  Producto Mínimo Viable (MVP) – *Tacocalipsis*

---

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

# 3 riesgos identificados.
### Riesgo 1

 - Impacto: Alto
 
 - Definición: Desbalance en la curva de dificultad al obligar al jugador a defender dos barras de vida paralelas (personaje y carrito). Como el taquero queda indefenso al empujar el carrito, la acumulación masiva de hordas mutantes puede generar una experiencia frustrante si el jugador se siente acorralado o sin poder responder.
 
### Riesgo 2

 - Impacto: Medio
 
 - Definición: Al desbloquear la pistola y sus posteriores mejoras como arma principal, el cuchillo secundario puede quedar completamente sin utilidad táctica real.
 
### Riesgo 3

 - Impacto: Alto
 
 - Definición: Al depender de la probabilidad (drop rate) de los enemigos para obtener munición de la pistola/arma principal, una racha de mala suerte en la selección aleatoria puede dejar al jugador sin balas contra jefes o masas de enemigos.
