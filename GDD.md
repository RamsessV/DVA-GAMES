# Nombre del juego
## 1. High Concept
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

---

### 4.3. Matriz de Decisiones y Tiempo por Fases de Juego

| Fase de Juego | Frecuencia | Acción Principal del Jugador | Recompensa e Impacto en la Partida |
| :--- | :--- | :--- | :--- |
| **Acción Inmediata (Momento a Momento)** | Todo el tiempo (Segundos) | Disparar, atacar con el cuchillo, cubrirse en el mapa y cambiar de lugar el carrito de tacos. | Mantiene con vida al Taquero y al carrito mientras elimina a las hordas mutantes. |
| **Avance y Mejoras (En la Oleada)** | Cada 1 a 2 minutos | Recoger la experiencia del suelo y elegir 1 de las 3 opciones al subir de nivel (Curación, +Velocidad o Mejora de Arma). | Aumenta la potencia de fuego, el rendimiento del personaje o recupera salud en medio del combate. |
| **Cierre de Nivel (Final de Oleada)** | Cada 5 a 8 minutos | Enfrentar y derrotar al Jefe Mutante del nivel (Taco, Burrito, Tamal, Elote o Chicharrón) y leer la historieta. | Restaura la vida del carrito al 100%, otorga aumento de vida máxima (al Taquero o al Carrito) y desbloquea la siguiente oleada. |

---

## 5. Mecánicas principales
## 6. Dinámicas esperadas
## 7. Mundo y conflicto
## 8. Interfaz conceptual
## 9. MVP
## 10. Riesgos y trade-offs
