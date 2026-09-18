# Core loop cerrado
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
  * Cajas de Munición (20% de probabilidad al morir).

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
