# Sistema de Interacción, UI y Validación de Riesgos

## 1. Concepto de UI (HUD, Canales de Información y Feedback)

### Elementos del HUD (Pantalla Limpia y Funcional)
* **Barra de Vida del Taquero:** Ubicada en la esquina superior izquierda, indica la salud restante del personaje antes de perder la partida.
* **Barra de Integridad del Carrito:** Situada justo debajo de la vida del taquero, muestra los puntos de estructura del puesto de tacos frente a las embestidas de las hordas.
* **Contador de Salsa e Ingredientes:** Esquina superior derecha, representa el recurso acumulado al eliminar comida mutante y ratas, utilizado como moneda en la tienda entre oleadas.
* **Oleada y Temporizador:** Centro superior de la pantalla, muestra el número de oleadas superadas y el tiempo restante para sobrevivir a la ronda actual.
* **Ranuras de Armas y Munción/Durabilidad:** Esquina inferior derecha, muestra el arma equipada (pistola de salsa, machete taquero, trompo de pastor giratorio) y su estado.

### Canales de Información y Feedback Visual/Sonoro
* **Canal Visual (En pantalla):**
  * **Hitboxes y Proyectiles:** Áreas de peligro remarcadas en color rojo o neón sobre el suelo para anticipar disparos, embestidas o ataques en zona de los jefes.
  * **Flotantes de Daño:** Números emergentes en pantalla al impactar a los enemigos para confirmar el daño realizado y el tipo de ataque (como daño crítico o quemadura por salsa picante).
  * **Parpadeo Visual (Flash):** El jugador, el puesto y los enemigos parpadean en blanco durante una fracción de segundo al recibir impacto.
* **Canal Auditivo:**
  * Efectos de sonido diferenciados para cada tipo de disparo, impactos en comida mutante, chillidos de ratas y alertas sonoras de emergencia cuando la salud del carrito cae por debajo del 20%.

## 2. Loop Principal de Interacción

El ciclo directo de acciones que ejecuta el jugador en cada ronda se divide en cuatro pasos continuos:

1. **Observar y Moverse:** Identificar los puntos de aparición de la comida mutante y posicionar al taquero en el mapa usando el teclado o la palanca para evitar ser acorralado.
2. **Apuntar y Atacar:** Orientar los ataques hacia las hordas de ratas y platillos mutantes usando el ratón o el apuntado direccional.
3. **Recolectar:** Moverse rápidamente sobre los restos de los enemigos para absorber las gotas de salsa e ingredientes antes de que desaparezcan.
4. **Mejorar y Reparar (Fase de Tienda):** Al terminar el tiempo de la oleada, acceder a la tienda para comprar armas temáticas, reparar el carrito o crear sinergias de objetos.


## 3. Dinámicas Asociadas y Regulación por la UI

* **Gobernanza del Espacio (Mantenimiento de distancia con la horda):** Regula el posicionamiento mediante indicadores de peligro en los bordes de la pantalla cuando hay enemigos grandes o proyectiles aproximándose fuera de cámara.
* **Priorización de Objetivos (Elegir qué amenaza eliminar primero):** Regulada mediante la diferenciación visual de enemigos, aplicando siluetas y colores resplandecientes para identificar rápidamente las amenazas de alto riesgo (como ratas explosivas o aguacates tiradores).
* **Gestión de Recursos bajo Presión (Arriesgarse por la salsa vs. Priorizar la supervivencia):** Regulada con animaciones de parpadeo y temporizadores de desaparición sobre las gotas de salsa tiradas en el suelo.
* **Protección Dividida (Defender la vida del taquero vs. Proteger el puesto de tacos):** Regulada mediante alertas visuales de color en el HUD del puesto (Verde → Amarillo → Rojo en estado crítico) e indicadores de dirección cuando el carrito está siendo atacado.

## 4. Principal Riesgo del Diseño y Prototipado

### Identificación del Riesgo (Experiencia de Juego)
* **Saturación Visual y Cognitiva (Visual Clutter):** Al combinar mecánicas de disparo contra hordas masivas (estilo Brotato o Soul Knight) con la necesidad de vigilar un punto fijo (el puesto de tacos), existe el riesgo de que el jugador pierda el rastro visual de su personaje, de los proyectiles o del estado del puesto debido a la densidad de elementos simultáneos en pantalla.

### Plan de Validación con Prototipo (Prototipo en Gris / Greybox)
* **Objetivo:** Probar la legibilidad de la pantalla y la fluidez del loop de juego en momentos de alta densidad de hordas.
* **Diseño del Prototipo:**
  1. **Gráficos Simplificados:** Utilizar figuras geométricas simples para representar al taquero, los enemigos mutantes y el puesto de tacos sin arte final.
  2. **Prueba de Carga de Enemigos:** Generar oleadas progresivas de 20 a 150 entidades simultáneas atacando en pantalla.
  3. **Métricas a Evaluar:** Tasa de muertes del jugador por daño no detectado (proyectiles no vistos), tiempo de reacción ante los ataques dirigidos al puesto y claridad del feedback del HUD durante los picos de horda.

## 5. Trade-Off Explícito

* **Decisión:** Se renuncia por completo a la mecánica de cocina compleja estilo Overcooked (ensamblar ingredientes paso a paso) en favor de un sistema de disparos, esquiva y supervivencia pura contra hordas (estilo Brotato o Soul Knight).
* **Compromiso:** 
  * **Lo que se pierde:** La profundidad de simulación de cocina y la gestión tradicional de comensales.
  * **Lo que se gana:** Fluidez en la acción, velocidad de respuesta, facilidad de control y eliminación de la frustración por menús en medio del combate, garantizando que el foco esté 100% en la supervivencia y la acción arcade.

## 6. Justificación de Decisiones

* **Justificación de UI:** Ubicar los datos críticos en los bordes y esquinas despeja la zona central de la pantalla, permitiendo que la atención del jugador se mantenga focalizada en esquivar proyectiles y posicionarse frente a la horda.
* **Justificación del Prototipado:** Probar el juego con figuras simples evita malgastar recursos de arte en un sistema de hordas que podría resultar ilegible o frustrante si la cantidad de enemigos tapa la visibilidad del jugador.
* **Justificación del Trade-Off:** Para un juego de ritmo rápido enfocado en sesiones intensas de 10 a 20 minutos con hordas masivas, detenerse a preparar recetas complejas rompía el ritmo, por lo que simplificar la recolección a la absorción automática de ingredientes mantiene la velocidad y la adrenalina constantes.
