
extends Node

# ----------------------------------
# SEÑALES
# ----------------------------------

# Se emite cuando comienza la oleada.
signal wave_started

# Se emite cuando termina el tiempo.
signal wave_time_finished

# Se emite cuando ya no quedan enemigos
# y podemos activar al jefe.
signal wave_cleared

# Se emite cuando el Jefe de la Oleada aparece.
signal boss_spawned

# Se emite cuando el Jefe de la Oleada es derrotado.
signal boss_defeated


# ----------------------------------
# CONFIGURACIÓN DE OLEADA
# ----------------------------------

# Duración de la primera oleada.
@export var wave_duration: float = 60.0

# Tiempo entre apariciones.
@export var spawn_interval: float = 2.0

# Máximo de enemigos vivos a la vez.
@export var max_enemies: int = 8

# Escena del Taco Mutante.
const TACO_SCENE: PackedScene = preload(
	"res://scenes/taco_enemy.tscn"
)


# Escena reutilizable para XP y munición.
const DROP_SCENE: PackedScene = preload(
	"res://scenes/drop.tscn"
)

# Escena del Jefe de la Oleada 1.
const BOSS_SCENE: PackedScene = preload(
	"res://scenes/boss.tscn"
)

# Posición donde aparecerá el jefe al invocarse.
@export var boss_spawn_position: Vector2 = Vector2(640, 120)

# Cantidad de XP que entrega cada Taco Mutante.
@export var xp_per_enemy: int = 10

# Probabilidad de soltar munición: 20%.
@export_range(0.0, 1.0) var ammo_drop_chance: float = 0.20

# Balas que contiene cada paquete.
@export var ammo_per_drop: int = 6



# ----------------------------------
# REFERENCIAS
# ----------------------------------

@onready var spawn_timer: Timer = $SpawnTimer
@onready var wave_timer: Timer = $WaveTimer

@onready var enemies_container: Node2D = (
	get_node("../World/Enemies")
)


# Contenedor donde aparecerán los drops.
@onready var drops_container: Node2D = (
	get_node("../World/Drops")
)


# ----------------------------------
# VARIABLES DE CONTROL
# ----------------------------------

var wave_active: bool = false
var wave_ending: bool = false

var enemies_alive: int = 0
var enemies_spawned: int = 0
var enemies_killed: int = 0

# Control del Jefe de la Oleada.
var boss_active: bool = false
var boss: Node2D = null


# ----------------------------------
# INICIALIZACIÓN
# ----------------------------------

func _ready() -> void:

	# Inicializar sistema aleatorio.
	randomize()

	# Conectar las señales de ambos Timer.
	spawn_timer.timeout.connect(on_spawn_timer_timeout)
	wave_timer.timeout.connect(on_wave_timer_timeout)

	# Aplicar configuraciones.
	spawn_timer.wait_time = spawn_interval
	wave_timer.wait_time = wave_duration

	# Comenzar la primera oleada.
	start_wave()


# ----------------------------------
# INICIAR OLEADA
# ----------------------------------

func start_wave() -> void:

	wave_active = true
	wave_ending = false

	enemies_alive = 0
	enemies_spawned = 0
	enemies_killed = 0

	print("¡OLEADA 1 INICIADA!")

	wave_started.emit()

	# Activar ambos temporizadores.
	wave_timer.start()
	spawn_timer.start()

	# Crear el primer enemigo inmediatamente.
	spawn_enemy()


# ----------------------------------
# GENERAR ENEMIGOS
# ----------------------------------


func spawn_enemy() -> void:

	if not wave_active:
		return

	if enemies_alive >= max_enemies:
		return

	# Buscar una posición libre antes de crear el taco.
	var spawn_position: Vector2 = Vector2.ZERO
	var valid_position: bool = false

	# Realizar hasta 15 intentos.
	for attempt in range(15):

		spawn_position = get_spawn_position()

		if is_spawn_position_safe(spawn_position):
			valid_position = true
			break

	# No generar este enemigo si no encontramos espacio.
	if not valid_position:
		return

	# Crear al enemigo.
	var enemy = TACO_SCENE.instantiate()

	enemies_container.add_child(enemy)

	enemy.global_position = spawn_position

	enemy.enemy_died.connect(on_enemy_died)

	enemies_alive += 1
	enemies_spawned += 1

	print(
		"Taco generado | Vivos: ",
		enemies_alive,
		" | Total: ",
		enemies_spawned
	)


# ----------------------------------
# VALIDAR POSICIÓN DE APARICIÓN
# ----------------------------------

func is_spawn_position_safe(position: Vector2) -> bool:

	# Comprobar distancia con jugador y carrito.
	for group_name in ["player", "cart", "enemies"]:

		for entity in get_tree().get_nodes_in_group(group_name):

			if not entity is Node2D:
				continue

			# Mantener una separación mínima.
			if position.distance_to(entity.global_position) < 100.0:
				return false

	return true



# ----------------------------------
# POSICIONES DE APARICIÓN
# ----------------------------------

func get_spawn_position() -> Vector2:

	# Escoger uno de los cuatro bordes.
	var side: int = randi_range(0, 3)

	var spawn_position: Vector2 = Vector2.ZERO

	match side:

		# Borde superior.
		0:
			spawn_position = Vector2(
				randf_range(80.0, 1200.0),
				60.0
			)

		# Borde inferior.
		1:
			spawn_position = Vector2(
				randf_range(80.0, 1200.0),
				660.0
			)

		# Borde izquierdo.
		2:
			spawn_position = Vector2(
				50.0,
				randf_range(80.0, 640.0)
			)

		# Borde derecho.
		3:
			spawn_position = Vector2(
				1230.0,
				randf_range(80.0, 640.0)
			)

	return spawn_position


# ----------------------------------
# TEMPORIZADOR DE SPAWN
# ----------------------------------

func on_spawn_timer_timeout() -> void:

	# Intentar crear otro enemigo.
	spawn_enemy()


# ----------------------------------
# TERMINAR TIEMPO DE OLEADA
# ----------------------------------

func on_wave_timer_timeout() -> void:

	wave_active = false
	wave_ending = true

	# Detener aparición de enemigos.
	spawn_timer.stop()

	print("¡Tiempo de oleada terminado!")

	wave_time_finished.emit()

	# En lugar de esperar a limpiar la pantalla,
	# invocamos al Jefe de la Oleada 1.
	start_boss_phase()


# ----------------------------------
# INVOCAR AL JEFE DE LA OLEADA
# ----------------------------------

func start_boss_phase() -> void:

	# Evitar invocar al jefe más de una vez.
	if boss_active:
		return

	boss_active = true

	print("¡EL JEFE DE LA OLEADA 1 HA APARECIDO!")

	# Crear al jefe reutilizando su escena.
	boss = BOSS_SCENE.instantiate()

	enemies_container.add_child(boss)

	boss.global_position = boss_spawn_position

	# Conectar la muerte del jefe para cerrar la oleada.
	boss.enemy_died.connect(on_boss_died)

	boss_spawned.emit()


# ----------------------------------
# DERROTA DEL JEFE
# ----------------------------------

func on_boss_died(death_position: Vector2) -> void:

	if not boss_active:
		return

	boss_active = false
	boss = null

	print("¡JEFE DERROTADO! Oleada 1 completada.")

	# Recompensas al derrotar al jefe.
	spawn_drops(death_position)

	boss_defeated.emit()

	# La oleada termina con la muerte del jefe.
	wave_ending = false
	wave_cleared.emit()


# ----------------------------------
# MUERTE DE UN ENEMIGO
# ----------------------------------


func on_enemy_died(death_position: Vector2) -> void:

	# Reducir número de enemigos vivos.
	enemies_alive = max(enemies_alive - 1, 0)

	# Registrar enemigo eliminado.
	enemies_killed += 1

	print(
		"Enemigo eliminado | Restantes: ",
		enemies_alive
	)

	# Generar recompensas en la posición de muerte.
	spawn_drops(death_position)

	# Comprobar si la oleada terminó.
	check_wave_completion()



# ----------------------------------
# COMPROBAR FIN DE OLEADA
# ----------------------------------

func check_wave_completion() -> void:

	# Durante la fase del jefe la oleada
	# no termina hasta derrotarlo.
	if boss_active:
		return

	# Esperar a que termine el tiempo.
	if not wave_ending:
		return

	# Esperar a eliminar a todos los enemigos.
	if enemies_alive > 0:
		return

	# Evitar completar dos veces.
	wave_ending = false

	print("¡OLEADA 1 COMPLETADA!")
	print("Total eliminados: ", enemies_killed)

	# Avisar que podemos activar al jefe.
	wave_cleared.emit()


# ----------------------------------
# CONSULTAR TIEMPO RESTANTE
# ----------------------------------

func get_remaining_time() -> float:

	return wave_timer.time_left
	
	

# ----------------------------------
# GENERAR RECOMPENSAS
# ----------------------------------

func spawn_drops(death_position: Vector2) -> void:

	# XP: siempre aparece.
	create_drop(
		0,
		xp_per_enemy,
		death_position
	)

	# Munición: probabilidad del 20%.
	if randf() < ammo_drop_chance:

		create_drop(
			1,
			ammo_per_drop,
			death_position + Vector2(14, 0)
		)


# ----------------------------------
# CREAR DROP INDIVIDUAL
# ----------------------------------

func create_drop(
	drop_type: int,
	amount: int,
	spawn_position: Vector2
) -> void:

	# Crear instancia de la escena Drop.
	var drop = DROP_SCENE.instantiate()

	# Configurar el tipo y cantidad de recompensa.
	drop.setup(drop_type, amount)

	# Colocar donde murió el enemigo.
	# (el contenedor Drops no tiene transform, así que position == global)
	drop.position = spawn_position

	# Añadir al contenedor de forma diferida: el drop es un
	# Area2D y su detección no puede activarse mientras la
	# física está resolviendo consultas (p. ej. al morir un enemigo).
	drops_container.add_child.call_deferred(drop)
