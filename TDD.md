# Documento de Diseño Técnico (TDD)
## Tacocalipsis

**Proyecto:** Tacocalipsis  
**Motor de desarrollo:** Godot Engine 4.7  
**Lenguaje de programación:** GDScript  
**Tipo de juego:** Acción y supervivencia 2D Top-Down  
**Plataforma objetivo:** PC  
**Repositorio:** https://github.com/RamsessV/DVA-GAMES

---

## 1. Introducción

El presente Documento de Diseño Técnico (TDD) describe la estructura, arquitectura, componentes y funcionamiento interno del videojuego **Tacocalipsis**, tomando como referencia la implementación disponible en su repositorio.

El documento tiene como finalidad explicar cómo se encuentra desarrollado técnicamente el proyecto, identificando los principales scripts, escenas, recursos y mecanismos de comunicación entre los componentes del juego.

El contenido se limita a las funcionalidades implementadas actualmente, por lo que no se incluyen características que únicamente estén contempladas en el Game Design Document (GDD), pero que todavía no formen parte del código.

## 2. Alcance del sistema

Tacocalipsis es un videojuego de acción y supervivencia en 2D con perspectiva Top-Down. El jugador controla a un taquero que debe enfrentarse a enemigos con apariencia de comida mutante mientras protege su carrito de tacos.

La versión implementada contiene los siguientes elementos:

- Un escenario de combate en 2D.
- Un personaje controlable llamado Taquero.
- Un carrito con una barra de vida independiente.
- Movimiento en ocho direcciones y mecánica para sujetar y desplazar el carrito.
- Combate cuerpo a cuerpo mediante un cuchillo.
- Combate a distancia mediante una pistola que se desbloquea con una mejora.
- Dos oleadas de enemigos: Tacos y Burritos.
- Un jefe al finalizar cada oleada.
- Sistema de experiencia, recolección de objetos y mejoras del personaje.
- Sistema de munición y recarga de la pistola.
- Interfaz de usuario para consultar la vida, experiencia, munición y estado de las oleadas.
- Pantallas de derrota y victoria.
- Menú principal, menú de pausa y opciones de configuración.
- Sistema de audio y música.

La partida termina cuando la vida del Taquero o la del carrito llega a cero. La victoria se alcanza al derrotar al jefe de la última oleada configurada.

## 3. Tecnologías y herramientas utilizadas

| Tecnología | Utilización |
|---|---|
| Godot Engine 4.7 | Motor principal para el desarrollo del videojuego. |
| GDScript | Lenguaje utilizado para implementar la lógica y el comportamiento de los componentes. |
| Escenas `.tscn` | Definición de personajes, enemigos, interfaces y elementos del escenario. |
| Recursos `.tres` | Configuración de datos reutilizables, principalmente las oleadas. |
| Imágenes y texturas | Representación visual de personajes, enemigos, objetos e interfaz. |
| Recursos de audio | Efectos de sonido y música del videojuego. |

El proyecto utiliza el sistema de nodos y escenas de Godot. Cada entidad o elemento funcional se organiza mediante nodos, mientras que los scripts asociados definen su comportamiento.

## 4. Arquitectura general del sistema

### 4.1. Organización arquitectónica

El proyecto utiliza una arquitectura basada en escenas y nodos de Godot. Los componentes se encuentran separados de acuerdo con sus responsabilidades, permitiendo que cada sistema gestione una parte específica del funcionamiento del videojuego.

La escena principal de juego contiene los elementos del escenario, las entidades, la interfaz y el gestor de oleadas.

Los principales componentes son:

| Componente | Responsabilidad |
|---|---|
| `Main` | Coordina el funcionamiento de la partida y conecta los diferentes sistemas. |
| `Player` | Controla el movimiento, combate, salud, experiencia y mejoras del Taquero. |
| `Cart` | Administra la salud y el comportamiento del carrito. |
| `WaveManager` | Controla la aparición de enemigos, duración de las oleadas y generación de jefes. |
| `TacoEnemy` | Implementa el comportamiento general de los enemigos. |
| `WaveBoss` | Implementa el comportamiento especial del jefe de la primera oleada. |
| `BurritoBoss` | Implementa el comportamiento especial del jefe de la segunda oleada. |
| `Drop` | Gestiona los objetos de experiencia y munición. |
| `Bullet` | Controla el movimiento, impacto y daño de los proyectiles del jugador. |
| `AudioManager` | Centraliza la reproducción de música y efectos de sonido. |
| `Settings` | Administra las opciones de configuración del juego. |

### 4.2. Comunicación entre componentes

La comunicación se realiza principalmente mediante cuatro mecanismos:

**Señales:** permiten notificar eventos entre componentes sin que sea necesario que estos controlen directamente toda la lógica de los demás. Por ejemplo, el jugador emite señales cuando cambia su salud, obtiene experiencia o muere.

**Referencias a nodos:** los scripts utilizan referencias directas para acceder a elementos de sus escenas, como las barras de vida, temporizadores, áreas de colisión y otros nodos relacionados.

**Grupos:** permiten localizar entidades mediante categorías. Se utilizan, por ejemplo, los grupos `player`, `cart`, `enemies` y `boss` para identificar personajes y enemigos dentro del escenario.

**Llamadas a métodos:** permiten ejecutar acciones específicas de otros componentes, como aplicar daño mediante `take_damage()`, agregar experiencia con `add_xp()` o recuperar la vida del carrito con `restore_full_health()`.

### 4.3. Escena principal

La ejecución del proyecto comienza desde la escena `main_menu.tscn`, configurada como escena inicial en `project.godot`.

Desde el menú principal se puede acceder a la partida. La escena de juego utiliza el script `main.gd` para coordinar los elementos principales y gestionar las transiciones entre los diferentes estados de la partida.

## 5. Estructura del proyecto

El proyecto organiza sus archivos principalmente en directorios para escenas, scripts, recursos y elementos gráficos.

| Directorio o archivo | Contenido y función |
|---|---|
| `scenes/` | Escenas de los personajes, enemigos, proyectiles, objetos e interfaces. |
| `scripts/` | Scripts que implementan la lógica de los diferentes componentes. |
| `resources/` | Recursos de configuración, incluyendo los datos de las oleadas. |
| `assets/` | Recursos gráficos, texturas, imágenes y elementos visuales. |
| `project.godot` | Configuración general del proyecto, escena inicial, controles y ajustes del motor. |

Entre los principales scripts se encuentran:

- `main.gd`
- `player.gd`
- `cart.gd`
- `wave_manager.gd`
- `wave_data.gd`
- `taco_enemy.gd`
- `boss.gd`
- `burrito_boss.gd`
- `drop.gd`
- `bullet.gd`
- `main_menu.gd`
- `settings.gd`
- `audio_manager.gd`

## 6. Diseño de los componentes principales

### 6.1. Controlador principal (`main.gd`)

El script `main.gd` administra el flujo general de la partida. Funciona como punto de conexión entre el jugador, el carrito, el gestor de oleadas y los elementos de la interfaz.

Sus responsabilidades principales son:

- Conectar las señales de los componentes.
- Actualizar las barras de salud del Taquero y el carrito.
- Actualizar la barra de experiencia y la información de las armas.
- Mostrar las pantallas de mejora y recompensa.
- Administrar los eventos de inicio y finalización de las oleadas.
- Mostrar la barra de vida del jefe.
- Gestionar la derrota y la victoria.
- Controlar el menú de pausa.
- Realizar las transiciones hacia el menú principal o el reinicio de la partida.

Entre las señales que recibe se encuentran las relacionadas con la salud y muerte del jugador, la destrucción del carrito y los eventos del gestor de oleadas.

También administra los botones de las interfaces, conectando sus eventos con métodos que aplican las mejoras o realizan las transiciones correspondientes.

### 6.2. Personaje principal (`player.gd`)

El personaje principal está implementado mediante un nodo de tipo `CharacterBody2D`. Este componente concentra la mayor parte de la lógica relacionada con el control del jugador.

**Movimiento**

El personaje puede desplazarse en ocho direcciones utilizando las entradas de movimiento configuradas en el proyecto.

Se manejan dos velocidades:

- `move_speed`: velocidad normal de movimiento.
- `push_speed`: velocidad al transportar el carrito.

El movimiento se calcula mediante `Input.get_vector()` y se aplica utilizando `move_and_slide()`.

**Interacción con el carrito**

El jugador puede sujetar o soltar el carrito mediante el método `toggle_cart()`.

Para sujetarlo, se comprueba que la distancia entre ambos elementos no supere el valor de `interact_distance`. Cuando se encuentra dentro del rango, se activa el estado `is_pushing_cart`.

Mientras transporta el carrito:

- El jugador utiliza una velocidad de movimiento reducida.
- Se deshabilitan los ataques.
- El carrito se desplaza junto con el personaje.
- Se modifican las excepciones de colisión entre ambos elementos para permitir su movimiento conjunto.

El método `move_with_cart()` se encarga de coordinar el desplazamiento de ambos cuerpos, comprobando previamente las colisiones del carrito con el escenario.

**Sistema de salud**

El jugador cuenta con una vida máxima definida por `max_health` y una vida actual almacenada en `current_health`.

Los métodos principales son:

| Método | Función |
|---|---|
| `take_damage()` | Reduce la salud del personaje y comprueba si ha muerto. |
| `heal()` | Recupera salud sin superar el máximo permitido. |
| `increase_max_health()` | Incrementa la vida máxima del personaje. |

Cuando la salud llega a cero, se emite la señal `player_died`.

**Combate cuerpo a cuerpo**

El cuchillo se implementa mediante un `Area2D` denominado `MeleeHitbox`, que permite detectar los cuerpos cercanos al personaje.

El método `melee_attack()` comprueba que el jugador pueda atacar y que el temporizador de enfriamiento haya terminado. Después, obtiene los cuerpos detectados por el área y aplica daño a aquellos que pertenecen al grupo `enemies`.

El daño se controla mediante `melee_damage`.

**Combate a distancia**

La pistola se encuentra bloqueada inicialmente y se desbloquea mediante el sistema de mejoras.

Sus principales variables son:

- `has_gun`: indica si el jugador tiene desbloqueada la pistola.
- `gun_damage`: daño de cada disparo.
- `magazine_size`: capacidad máxima del cargador.
- `current_ammo`: munición disponible en el cargador.
- `reserve_ammo`: munición almacenada en reserva.
- `gun_level`: nivel actual del arma.

El método `shoot()` comprueba que el personaje pueda atacar, que tenga la pistola desbloqueada y que el temporizador de disparo haya terminado.

Cuando se realiza un disparo, se consume una unidad de munición, se instancia la escena `bullet.tscn` y se configura su dirección y daño.

El método `reload_gun()` transfiere munición de la reserva al cargador, respetando su capacidad máxima.

**Experiencia y niveles**

El jugador almacena su progreso mediante las variables `player_level`, `current_xp` y `xp_to_next_level`.

Cuando recoge experiencia, se ejecuta `add_xp()`. Si alcanza el requisito necesario, se activa `level_up_pending` y se emite la señal `level_up_ready`.

La función `complete_level_up()` consume la experiencia requerida, aumenta el nivel y establece un nuevo requisito de experiencia para el siguiente nivel.

**Mejoras disponibles**

El jugador cuenta con tres métodos principales de mejora:

- `heal()`: recupera el 30 % de la salud máxima cuando se selecciona la opción de curación.
- `upgrade_speed()`: incrementa un 10 % las velocidades normal y de transporte.
- `upgrade_gun()`: desbloquea la pistola en su primera utilización y aumenta su daño en las mejoras posteriores.

### 6.3. Carrito (`cart.gd`)

El carrito utiliza un nodo de tipo `CharacterBody2D` y administra su propia salud de manera independiente a la del personaje.

Sus variables principales incluyen:

- `max_health`: salud máxima del carrito.
- `current_health`: salud actual.
- `is_attached`: indica si el carrito está sujeto al personaje.

Entre sus métodos principales se encuentran:

| Método | Función |
|---|---|
| `take_damage()` | Reduce la salud del carrito. |
| `heal()` | Recupera salud sin superar el máximo. |
| `increase_max_health()` | Incrementa su salud máxima. |
| `restore_full_health()` | Restaura completamente su salud. |

El carrito emite la señal `health_changed` cuando cambia su salud y `cart_destroyed` cuando llega a cero.

También cuenta con diferentes texturas para representar visualmente su estado: normal, dañado y destruido.

La recuperación completa del carrito se ejecuta después de derrotar a un jefe.

### 6.4. Enemigos comunes (`taco_enemy.gd`)

El script `taco_enemy.gd` implementa el comportamiento general de los enemigos mediante un nodo `CharacterBody2D`.

Los enemigos se incorporan al grupo `enemies`, lo que permite que otros componentes los identifiquen y puedan interactuar con ellos.

**Persecución**

El enemigo busca al jugador y al carrito utilizando sus grupos. Posteriormente, compara las distancias para seleccionar el objetivo más cercano.

Su desplazamiento se realiza mediante `move_and_slide()`.

**Ataque**

El enemigo puede atacar cuando su objetivo se encuentra dentro de su rango de ataque.

Antes de aplicar daño, utiliza una consulta de raycast para comprobar que no exista un obstáculo que bloquee la trayectoria.

El ataque se controla mediante un temporizador de enfriamiento y el daño se aplica utilizando el método `take_damage()` del objetivo.

**Salud y eliminación**

Cada enemigo dispone de salud máxima y actual. Cuando recibe daño, actualiza su salud y emite la señal `health_changed`.

Cuando su salud llega a cero, ejecuta `die()`, que emite la señal `enemy_died` indicando su posición de muerte.

Esta señal permite que el gestor de oleadas registre la eliminación y genere las recompensas correspondientes.

### 6.5. Jefe de la primera oleada (`boss.gd`)

El jefe de la primera oleada utiliza la clase `WaveBoss`, que hereda de `TacoEnemy`.

Por lo tanto, reutiliza el sistema de salud, daño, persecución, animaciones y eliminación de los enemigos comunes.

Su principal característica es un sistema de embestida que funciona mediante una máquina de estados.

Los estados implementados son:

| Estado | Descripción |
|---|---|
| `CHASE` | Persigue al Taquero. |
| `WINDUP` | Se detiene y prepara la embestida. |
| `DASH` | Se desplaza rápidamente en línea recta hacia la dirección calculada. |
| `RECOVER` | Permanece detenido durante un periodo antes de volver a perseguir. |

La anticipación de la embestida permite que el jugador identifique cuándo el jefe se prepara para atacar.

El jefe emite las señales `charge_started` y `charge_finished` para notificar el inicio y finalización de este ataque.

### 6.6. Jefe de la segunda oleada (`burrito_boss.gd`)

El jefe de la segunda oleada utiliza la clase `BurritoBoss`, que también hereda de `TacoEnemy`.

A diferencia del primer jefe, mantiene el comportamiento de persecución y ataque cuerpo a cuerpo de la clase base, pero incorpora un ataque a distancia.

Su principal función adicional es `fire_bean()`, que instancia un proyectil de frijol y lo dirige hacia la posición actual del Taquero.

Sus variables principales son:

- `boss_scale`: tamaño del jefe.
- `bean_scene`: escena del proyectil que utiliza.
- `bean_damage`: daño del proyectil.
- `bean_interval`: tiempo entre disparos.
- `_shoot_timer`: temporizador interno para controlar los disparos.

El jefe persigue específicamente al Taquero, ignorando el carrito como objetivo.

### 6.7. Gestor de oleadas (`wave_manager.gd`)

El script `wave_manager.gd` administra la secuencia de enemigos y jefes durante la partida.

Su funcionamiento se basa en una lista de recursos de tipo `WaveData`, que contienen la configuración de cada oleada.

Cuando inicia el juego, carga las oleadas configuradas. Si no se han asignado recursos desde el inspector, utiliza las dos oleadas predeterminadas:

- `wave_1_tacos.tres`
- `wave_2_burritos.tres`

**Temporizadores**

El gestor utiliza dos temporizadores:

- `SpawnTimer`: controla el intervalo entre apariciones de enemigos.
- `WaveTimer`: determina cuánto tiempo dura la fase de aparición de enemigos comunes.

Al comenzar una oleada, se inicia el temporizador de duración y el de aparición. También se genera inmediatamente el primer enemigo.

**Generación de enemigos**

El método `spawn_enemy()` instancia la escena del enemigo correspondiente a la oleada actual.

Antes de crear un enemigo, busca una posición de aparición válida mediante `get_spawn_position()` e `is_spawn_position_safe()`.

Las posiciones se seleccionan aleatoriamente entre los cuatro bordes del escenario. Para evitar apariciones demasiado cercanas, se comprueba que exista una separación mínima de 100 píxeles respecto al jugador, el carrito y los demás enemigos.

Se realizan hasta 15 intentos para encontrar una posición segura.

**Generación del jefe**

Cuando termina el tiempo de la oleada, se detienen las apariciones de enemigos comunes y se ejecuta `start_boss_phase()`.

El jefe se instancia a partir de la escena configurada en el recurso `WaveData` y aparece en la posición definida para esa oleada.

Cuando el jefe es derrotado, se ejecuta `on_boss_died()`, que genera las recompensas y emite las señales correspondientes para que el juego pueda continuar.

**Señales principales**

| Señal | Función |
|---|---|
| `wave_started` | Notifica el inicio de una oleada. |
| `wave_time_finished` | Indica que terminó el tiempo de aparición de enemigos. |
| `wave_cleared` | Notifica que la oleada fue completada. |
| `boss_spawned` | Indica que apareció el jefe. |
| `boss_defeated` | Notifica la derrota del jefe. |
| `all_waves_completed` | Indica que no existen más oleadas por iniciar. |

### 6.8. Configuración de oleadas (`wave_data.gd`)

El script `wave_data.gd` define la clase `WaveData`, que hereda de `Resource`.

Su propósito es almacenar la configuración de una oleada sin tener que modificar directamente la lógica del gestor.

Las propiedades configurables son:

| Variable | Descripción |
|---|---|
| `wave_name` | Nombre de la oleada. |
| `enemy_scene` | Escena del enemigo común. |
| `boss_scene` | Escena del jefe. |
| `boss_display_name` | Nombre del jefe mostrado en la interfaz. |
| `wave_duration` | Duración de la oleada. |
| `spawn_interval` | Tiempo entre apariciones de enemigos. |
| `max_enemies` | Cantidad máxima de enemigos comunes vivos. |
| `xp_per_enemy` | Experiencia que entrega cada enemigo. |
| `ammo_drop_chance` | Probabilidad de generar munición. |
| `ammo_per_drop` | Cantidad de munición por objeto. |
| `boss_spawn_position` | Posición de aparición del jefe. |

Los recursos utilizados actualmente son:

**Primera oleada: Tacos**

- Enemigo común: Taco Mutante.
- Jefe: Gran Taco de Pastor.
- Duración: 45 segundos.
- Experiencia por enemigo: 15 puntos.
- Probabilidad de munición: 20 %.
- Munición por objeto: 10 unidades.

**Segunda oleada: Burritos**

- Enemigo común: Burrito Diabólico.
- Jefe: Burrito Supremo.
- Duración: 45 segundos.
- Intervalo de aparición: 2.2 segundos.
- Máximo de enemigos comunes vivos: 6.
- Experiencia por enemigo: 20 puntos.
- Probabilidad de munición: 20 %.
- Munición por objeto: 12 unidades.

### 6.9. Sistema de recompensas (`drop.gd`)

El script `drop.gd` implementa los objetos que aparecen cuando un enemigo es derrotado.

Los objetos se implementan mediante un nodo `Area2D` y existen dos tipos:

- `XP`: proporciona experiencia al jugador.
- `AMMO`: proporciona munición para la pistola.

Cada objeto almacena su tipo y cantidad mediante las variables `drop_type` y `amount`.

**Atracción y recolección**

El sistema incorpora un mecanismo de atracción magnética hacia el jugador.

Cuando el jugador se encuentra dentro del radio definido por `magnet_radius`, el objeto comienza a desplazarse hacia su posición utilizando `magnet_speed`.

Cuando alcanza la distancia de recolección, definida por `pickup_radius`, se ejecuta `collect()`.

Según el tipo de objeto, se llama al método `add_xp()` o `add_ammo()` del jugador. Finalmente, el objeto se elimina del escenario.

**Generación de recompensas**

El gestor de oleadas genera experiencia cada vez que un enemigo es derrotado. La munición se genera de acuerdo con la probabilidad configurada en el recurso de la oleada.

### 6.10. Proyectil del jugador (`bullet.gd`)

El script `bullet.gd` controla los proyectiles disparados por la pistola.

Se implementa mediante un nodo `Area2D` y cuenta con las siguientes variables:

- `speed`: velocidad del proyectil.
- `damage`: daño que provoca.
- `lifetime`: tiempo máximo de existencia.
- `direction`: dirección de movimiento.
- `has_hit`: indicador que evita procesar varios impactos.

El método `setup()` recibe la dirección y el daño del disparo.

Durante la ejecución, el proyectil calcula su desplazamiento y realiza una consulta de raycast para detectar obstáculos o enemigos en su trayectoria.

Si impacta contra un enemigo del grupo `enemies`, aplica daño mediante `take_damage()`. Después del impacto, el proyectil se elimina.

Si no encuentra un objetivo, continúa avanzando hasta alcanzar su tiempo máximo de existencia.

## 7. Sistemas de interfaz y control de partida

### 7.1. HUD

La interfaz de juego se administra desde `main.gd` y utiliza diferentes elementos de tipo `Label`, `ProgressBar` y `Control`.

Los principales indicadores son:

- Salud actual y máxima del Taquero.
- Salud actual y máxima del carrito.
- Nivel y experiencia acumulada.
- Estado de la pistola.
- Nivel del arma y munición disponible.
- Estado y nombre de la oleada.
- Nombre y salud del jefe.
- Mensajes de aparición de oleadas y jefes.

La actualización de estos elementos se realiza mediante métodos específicos que reciben los valores de los componentes correspondientes.

### 7.2. Sistema de mejoras

Cuando el jugador reúne suficiente experiencia, el componente `Player` emite la señal `level_up_ready`.

El controlador principal recibe esta señal y muestra el menú de mejoras, deteniendo temporalmente la partida mediante `get_tree().paused`.

El menú ofrece tres opciones:

1. **Curación:** recupera el 30 % de la salud máxima del Taquero.
2. **Velocidad:** incrementa un 10 % la velocidad normal y de transporte.
3. **Arma:** desbloquea la pistola o aumenta su daño.

Al seleccionar una opción, `main.gd` ejecuta el método correspondiente del jugador y llama a `complete_level_up()`.

Si todavía existe experiencia suficiente para otro nivel, el menú vuelve a mostrarse. En caso contrario, se reanuda la partida.

### 7.3. Recompensa posterior al jefe

Cuando un jefe es derrotado, el controlador principal restaura completamente la salud del carrito y muestra una interfaz de recompensa.

El jugador puede seleccionar una de las siguientes opciones:

- Incrementar la salud máxima del Taquero.
- Incrementar la salud máxima del carrito.

La selección se procesa mediante `select_boss_reward()` y ejecuta el método de mejora correspondiente.

### 7.4. Pantalla de derrota

La derrota ocurre cuando el Taquero o el carrito pierden toda su salud.

El controlador principal recibe las señales `player_died` o `cart_destroyed` y ejecuta `show_game_over()`.

Este método muestra la pantalla de derrota, reproduce el sonido correspondiente, detiene la música y pausa el juego.

Desde esta pantalla se puede reiniciar la partida o regresar al menú principal.

### 7.5. Pantalla de victoria

Cuando el gestor de oleadas emite `all_waves_completed`, el controlador principal ejecuta `show_victory()`.

Se muestra la pantalla de victoria, se detiene la música de la partida, se reproduce el sonido correspondiente y se pausa el juego.

Desde esta pantalla se puede reiniciar la partida o regresar al menú principal.

### 7.6. Menú de pausa

El menú de pausa se controla desde `main.gd` mediante la acción de entrada `pause`.

El método `toggle_pause()` alterna el estado de pausa del árbol de escenas y muestra u oculta la interfaz correspondiente.

No permite abrirse cuando se muestran pantallas de victoria, derrota, subida de nivel o recompensa del jefe.

También permite acceder al menú de opciones.

### 7.7. Menú principal y configuración

El menú principal se implementa mediante `main_menu.gd` y constituye el punto de entrada del videojuego.

La configuración general se encuentra separada en `settings.gd`, que define la clase `Settings`.

Este componente permite:

- Consultar y modificar el volumen general.
- Activar o desactivar el modo de pantalla completa.
- Guardar la configuración en `user://settings.cfg`.
- Cargar la configuración almacenada.
- Aplicar un cursor personalizado.

La configuración de audio y video se aplica utilizando las clases `AudioServer` y `DisplayServer` de Godot.

## 8. Sistema de audio

El proyecto utiliza un componente global denominado `AudioManager`, configurado como un Autoload en `project.godot`.

Esto permite acceder a sus métodos desde diferentes scripts sin necesidad de crear referencias individuales en cada escena.

Entre sus responsabilidades se encuentran:

- Reproducir música.
- Reproducir efectos de sonido.
- Detener la música.
- Controlar la reproducción de efectos en bucle.
- Ajustar parámetros de reproducción, como el volumen y la variación de tono.

Los componentes principales utilizan este sistema para reproducir sonidos relacionados con ataques, daño, muerte, recolección de objetos, aparición de jefes y eventos de la partida.

## 9. Flujo de ejecución del videojuego

El funcionamiento general de una partida se desarrolla mediante la siguiente secuencia:

1. El proyecto inicia desde `main_menu.tscn`.
2. El jugador accede a la partida y se carga la escena principal.
3. `main.gd` conecta las señales de los componentes y configura la interfaz.
4. `WaveManager` inicia automáticamente la primera oleada.
5. Se generan enemigos comunes en posiciones aleatorias del escenario.
6. Los enemigos persiguen al Taquero o al carrito y realizan ataques.
7. El jugador combate utilizando el cuchillo y, cuando la desbloquea, la pistola.
8. Al derrotar enemigos, se generan objetos de experiencia y, de manera probabilística, munición.
9. El jugador recoge los objetos y obtiene experiencia o munición.
10. Al alcanzar la experiencia necesaria, se muestra el menú de mejoras.
11. Cuando termina el tiempo de la oleada, dejan de aparecer enemigos comunes y se genera el jefe.
12. El jugador debe derrotar al jefe para completar la oleada.
13. Al derrotarlo, el carrito recupera toda su salud y se presenta una selección de mejora permanente.
14. El gestor inicia la siguiente oleada cuando se solicita avanzar.
15. Después de derrotar al jefe de la última oleada, se muestra la pantalla de victoria.

En cualquier momento, si la salud del Taquero o del carrito llega a cero, se muestra la pantalla de derrota y se detiene la partida.

## 10. Controles del videojuego

Los controles se encuentran configurados en la sección `input` del archivo `project.godot`.

| Acción | Entrada |
|---|---|
| Mover hacia arriba | W / Flecha arriba |
| Mover hacia abajo | S / Flecha abajo |
| Mover hacia la izquierda | A / Flecha izquierda |
| Mover hacia la derecha | D / Flecha derecha |
| Sujetar o soltar el carrito | E |
| Ataque cuerpo a cuerpo | Espacio / Botón derecho del ratón |
| Disparar | Botón izquierdo del ratón |
| Pausar | Escape |

El apuntado del personaje se realiza utilizando la posición del cursor del ratón.

## 11. Configuración del proyecto

El archivo `project.godot` contiene los parámetros generales del videojuego.

Entre los valores configurados se encuentran:

| Parámetro | Valor |
|---|---|
| Nombre del proyecto | Tacocalipsis |
| Versión de Godot | 4.7 |
| Ancho de resolución base | 1280 píxeles |
| Alto de resolución base | 720 píxeles |
| Escena inicial | `res://scenes/main_menu.tscn` |
| Autoload | `AudioManager` |

También se encuentran configuradas las capas de física 2D utilizadas para distinguir el escenario, jugador, carrito, enemigos, proyectiles y objetos recolectables.

## 12. Consideraciones sobre la implementación actual

El desarrollo documentado corresponde a la versión existente del repositorio y no a todas las características descritas en el GDD.

Por ello, se consideran las siguientes delimitaciones:

- El sistema de oleadas está configurado actualmente para dos categorías: Tacos y Burritos.
- Se cuenta con un jefe específico para cada una de esas oleadas.
- Las mejoras de nivel se presentan mediante tres opciones definidas en la interfaz; no se documentan como un sistema de selección aleatoria de cartas.
- El sistema de recompensas posteriores al jefe permite aumentar la salud máxima del Taquero o del carrito.
- La generación de experiencia y munición se encuentra implementada mediante objetos recolectables.
- La pistola se desbloquea mediante el sistema de mejoras y utiliza munición limitada.
- La restauración completa de la salud del carrito se ejecuta al derrotar a un jefe.
- Las funcionalidades que forman parte de la propuesta del GDD, pero que no se encuentran implementadas en el código actual, no se consideran parte de la arquitectura descrita en este documento.

---

**Fin del documento.**
