# Reporte de Evaluación y Plan de Trabajo Final: Tacocalipsis

**Estudio:** Tacocalipsis Dev Studio

**Fecha de entrega:** Noviembre de 2026

**Objetivo:** Evaluar los avances del videojuego y establecer un plan de trabajo realista hasta el cierre del curso, cubriendo desarrollo, integración, pruebas de jugabilidad (playtesting) y corrección de errores.

## 1. Estado Actual del Videojuego

### 1.1 Funcionalidades y Mecánicas Terminadas

Con base en los tres sprints completados al 23 de octubre, se han implementado y verificado las siguientes características del MVP:

* **Sistemas Core y Movilidad:**

  * Movimiento del Taquero en 8 direcciones con colisiones sobre escenario rectilíneo (calle).

  * Entidad del Carrito de Tacos interactiva con sistema de agarre/soltar (`E` / `Espacio`).

  * Restricción contextual de acción: deshabilitación del ataque mientras se empuja el carrito.

  * Barras de salud independientes para el Taquero y el Carrito, con lógica de *Game Over* si cualquiera de las dos llega a $0\text{ HP}$.

* **Combate y Enemigos:**

  * Arma secundaria: Cuchillo taquero (ataque cuerpo a cuerpo, hitbox y cooldown programados).

  * Arma principal: Disparo a distancia con consumo de munición.

  * Comportamiento básico de la horda: Enemigo común (*Taco Mutante*) con navegación directa hacia el Taquero/Carrito y ataque melee.

  * Generador de oleadas (*Spawner*) por tiempos y límites simultáneos en pantalla.

  * Enemigo Boss (Oleada 1): *Gran Taco de Pastor* (escalado mayor, alta vida, ataque de embestida recta).

* **Progresión y Loop Roguelite:**

  * Drops de enemigos: Orbes de XP ($100\%$ probabilidad) con imán de recolección y Munición ($20\%$ probabilidad).

  * Pausa táctica y UI de subida de nivel (*Pop-up* con 3 opciones: Curación $30\%$, $+10\%$ Velocidad, Obtención/Mejora de Arma Principal).

  * Lógica Post-Jefe de Oleada 1: Regeneración al $100\%$ del Carrito y menú de elección ($+20\%\text{ HP}$ Taquero o $+20\%\text{ HP}$ Carrito).

* **Escenario e Interfaz:**

  * 3 a 4 obstáculos fijos (*colliders*) que bloquean movimiento y proyectiles.

  * HUD funcional (Salud de ambos entes, XP/Nivel, Iconos de armamento y contador de munición).

  * Flujo de pantallas: Intro (placeholder viñeta), Game Over y Pantalla de Victoria/Cliffhanger de Oleada 1.

### 1.2 Funcionalidades en Desarrollo

* **Oleada 2 (Burritos):** Integración del enemigo tipo tanque (*Burrito Diabólico*) y el jefe (*Burrito Supremo*) con ataque de proyectil lento de frijol.

* **Historieta / Cómic Narrativo:** Transición entre la plantilla provisional (*placeholder*) y la interfaz final de cómics ilustrados.

### 1.3 Problemas Pendientes y Bugs Detectados

1. **Balance de Drops de Munición (RNG):** Riesgo de desabasto severo de munición en momentos de alta densidad de enemigos, forzando un uso exclusivo del cuchillo que rompe la fluidez.

2. **Solapamiento de Enemigos:** Los *Tacos Mutantes* se enciman excesivamente al perseguir al carrito, generando acumulación de daño instantáneo no legible.

3. **Dificultad mas alta de lo esperado:** Que el alternar entre atacar, esquivar y mover el carrito, en conjunto con la densidad de enemigos, conlleve a una dificultad bastante elevada y por lo tanto una experiencia no tan grata.

## 2. Trabajo Pendiente y Prioridades

Para garantizar una entrega estable y jugable al cierre del proyecto, se clasifican los requerimientos entre indispensables (MVP) y opcionales.

### 2.1 Indispensables

* Finalizar Oleada 2 (*Burrito Diabólico* y *Burrito Supremo* con sus respectivos patrones de ataque).

* Ajustar empuje y separación (*steering/separation behaviors*) entre enemigos de la horda.

* Integración final de la interfaz de viñetas narrativas (Intro, Transición de Oleada y Final).

* Balance de valores de daño, HP, hitbox y velocidad general.

### 2.2 Opciones de Valor 

* Inclusión de las Oleadas 3, 4 y 5 (Tamal, Elote, Chicharrón).

* Efectos de audio (SFX de disparos, impactos y empuje del carrito) y banda sonora *chiptune/cumbia*.

* Feedback visual avanzado (parpadeo al recibir daño, partículas al destruir mutantes).

## 3. Plan de Trabajo hasta el 29 de Noviembre

| Periodo | Meta Principal | Actividades Concretas | Responsable | Resultado Esperado | 
| ----- | ----- | ----- | ----- | ----- | 
| **3–8 nov.** | Diagnóstico, planificación y prioridades | • Auditoría de código del build del 23 de oct.  • Comenzar a generar los sprites de todo el juego.  • Creación del formato para pruebas de playtesting. | Programador Principal / Game Designer | Build estable con gestión de drops corregida y guía de pruebas lista. | 
| **9–15 nov.** | Completar mecánicas y funcionalidades esenciales | • Programación de *Burrito* y *Burrito Supremo* (Oleada 2).  • Implementar los sprites al juego.  • Ajuste de separación física de enemigos.  • Integración de viñetas narrativas finales. | Programador de IA / Artista 2D | Versión candidata (*Feature Complete*) con 2 oleadas jugables de principio a fin. | 
| **16–22 nov.** | Integración y pruebas de jugabilidad | • Ejecución de sesiones de Playtesting (Mínimo 4 usuarios externos).  • Recopilación de métricas de telemetría y encuestas.  • Identificación de puntos de frustración en combate dual. | Todo el Estudio | Reporte consolidado de retroalimentación e inventario de *bugs*. | 
| **23–25 nov.** | Corregir problemas, pulir y versión final | • Corrección de *bugs* críticos hallados en pruebas.  • Ajuste de balance final ($HP$, daño, velocidad).  • Compilación de ejecutable final. | Programador Principal / Lead Tester | Master Build (.exe) verificado y listo para presentación. | 

## 4. Plan de Pruebas de Jugabilidad (Playtesting)

### 4.1 Cronograma y Muestra

* **Fecha de aplicación:** Del 17 al 19 de noviembre de 2026.

* **Perfil de evaluadores:** 8 a 12 jugadores de entre 16 y 35 años (mezcla de jugadores casuales y fans de títulos *roguelite* / *survivor*).

### 4.2 Criterios de Evaluación

1. **Controles e Interacción:** Intuitividad al presionar `E`/`Espacio` para arrastrar el carrito y claridad de la restricción de combate.

2. **Tensión Dual (Dificultad):** Balance de atención dividida entre la vida del Taquero y la del Carrito.

3. **Claridad del HUD y Objetivos:** Facilidad para leer los contadores de salud, barra de XP y necesidad de munición en tiempo real.

4. **Sensación de Progresión y Diversión:** Nivel de gratificación al elegir las mejoras de subida de nivel y ritmo de juego (*pacing*).

### 4.3 Metodología de Registro

* **Prueba directa observacional:** Registro de tiempo de juego, cantidad de muertes por nivel y causa de Game Over (¿murió el Taquero o el Carrito?).

* **Cuestionario post-partida (Escala Likert 1-5 + Cualitativo):**

  * *¿Sentiste frustrante perder el ataque al empujar el carrito?*

  * *¿La munición disponible fue suficiente para resolver las oleadas?*

  * *¿Qué mejora sentiste más útil durante la subida de nivel?*

## 5. Organización y Compromisos del Estudio

### 5.1 Roles y Responsabilidades

* **DEV 2:** Encargado de la lógica de la Oleada 2, implementación del *pity system* de munición, ajuste de colisiones e integración general.

* **DEV 1:** Responsable del balance numérico ($HP$, daño, velocidad), diseño del flujo de playtesting e interpretación de métricas.

* **DEV 2:** Elaboración de las viñetas narrativas finales, iconos del HUD y pulido visual del sprite del Carrito y Taquero.

* **DEV 1:** Coordinación de las sesiones de prueba con usuarios externos, captura de *bugs* y verificación de correcciones antes de la compilación final.

### 5.2 Mecanismos de Coordinación

* **Reuniones Stand-up (15 min):** Lunes, miércoles y viernes vía Discord para sincronizar avances del plan semanal.

* **Control de Versiones:** Repositorio en GitHub con ramas protegidas (`main` para builds estables, `dev` para integración de características).

### 5.3 Matriz de Riesgos y Mitigación

| Riesgo Detectado | Impacto | Estrategia de Mitigación | 
| ----- | ----- | ----- | 
| **Retraso en el arte de viñetas finales** | Medio | Mantener la secuencia de viñetas en formato borrador/boceto limpio con funcionalidad completa de navegación por botón. | 
| **Desbalance severo en la Oleada 2 (Jefe Burrito Supremo)** | Alto | Parametrizar variables de daño y vida en *ScriptableObjects* o tablas externas para realizar ajustes en tiempo real sin recompilar el núcleo. | 
| **Bugs críticos de colisión durante el empuje del carrito** | Alto | Congelar la adición de nuevas mecánicas el 16 de noviembre para enfocar a todo el equipo exclusivamente en la estabilización del código. | 
