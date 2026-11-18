extends Node

# ----------------------------------
# GESTOR DE OLEADAS
# ----------------------------------
# Recorre una lista de recursos WaveData. Cada oleada define
# su enemigo común, su jefe, su duración y sus recompensas.
# Al terminar el tiempo de una oleada se invoca a su jefe;
# al derrotarlo se pasa a la siguiente oleada (o se avisa el
# fin del juego con all_waves_completed).


# ----------------------------------
# SEÑALES
# ----------------------------------

# Se emite al comenzar una oleada (índice y nombre).
signal wave_started(wave_index: int, wave_name: String)

# Se emite cuando termina el tiempo de la oleada.
signal wave_time_finished

# Se emite cuando ya no quedan enemigos pendientes.
signal wave_cleared

# Se emite cuando el Jefe de la oleada aparece.
signal boss_spawned

# Se emite cuando el Jefe de la oleada es derrotado.
signal boss_defeated

# Se emite al superar la última oleada.
signal all_waves_completed


# ----------------------------------
# OLEADAS PREDEFINIDAS
# ----------------------------------

# Recursos de oleada por defecto (editables en el inspector).
const WAVE_1_TACOS: WaveData = preload(
	"res://resources/wave_1_tacos.tres"
)

const WAVE_2_BURRITOS: WaveData = preload(
	"res://resources/wave_2_burritos.tres"
)

# Lista de oleadas que se jugarán en orden.
@export var waves: Array[WaveData] = []


# Escena reutilizable para XP y munición.
const DROP_SCENE: PackedScene = preload(
	"res://scenes/drop.tscn"
)


# ----------------------------------
# REFERENCIAS
# ----------------------------------

@onready var spawn_timer: Timer = $SpawnTimer
@onready var wave_timer: Timer = $WaveTimer

@onready var enemies_container: Node2D = (
	get_node("../World/Enemies")
)

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

# Oleada actual.
var current_wave_index: int = -1
var current_wave: WaveData = null


# ----------------------------------
# INICIALIZACIÓN
# ----------------------------------

func _ready() -> void:

	# Inicializar sistema aleatorio.
	randomize()

	# Si no se configuraron oleadas en el inspector,
	# usar las predefinidas.
	if waves.is_empty():
		waves.append(WAVE_1_TACOS)
		waves.append(WAVE_2_BURRITOS)

	# Conectar las señales de ambos Timer.
	spawn_timer.timeout.connect(on_spawn_timer_timeout)
	wave_timer.timeout.connect(on_wave_timer_timeout)

	# Comenzar la primera oleada.
	start_wave(0)


# ----------------------------------
# INICIAR OLEADA
# ----------------------------------

func start_wave(index: int) -> void:

	# Si el índice no es válido, ya no hay más oleadas.
	if index < 0 or index >= waves.size():
		all_waves_completed.emit()
		return

	current_wave_index = index
	current_wave = waves[index]

	# No continuar si el recurso no está asignado.
	if current_wave == null:
		return

	wave_active = true
	wave_ending = false

	enemies_alive = 0
	enemies_spawned = 0
	enemies_killed = 0

	# Aplicar la configuración de esta oleada a los Timer.
	spawn_timer.wait_time = current_wave.spawn_interval
	wave_timer.wait_time = current_wave.wave_duration

	print(
		"¡OLEADA ",
		index + 1,
		" INICIADA: ",
		current_wave.wave_name,
		"!"
	)

	wave_started.emit(index, current_wave.wave_name)

	# Activar ambos temporizadores.
	wave_timer.start()
	spawn_timer.start()

	# Crear el primer enemigo inmediatamente.
	spawn_enemy()


# ----------------------------------
# AVANZAR A LA SIGUIENTE OLEADA
# ----------------------------------

func start_next_wave() -> void:

	var next_index: int = current_wave_index + 1

	# Si ya no hay más oleadas, avisar el fin del juego.
	if next_index >= waves.size():
		all_waves_completed.emit()
		return

	start_wave(next_index)


# ----------------------------------
# GENERAR ENEMIGOS
# ----------------------------------

func spawn_enemy() -> void:

	if not wave_active:
		return

	if current_wave == null:
		return

	if enemies_alive >= current_wave.max_enemies:
		return

	# Buscar una posición libre antes de crear el enemigo.
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

	# Crear al enemigo de esta oleada.
	var enemy = current_wave.enemy_scene.instantiate()

	enemies_container.add_child(enemy)

	enemy.global_position = spawn_position

	enemy.enemy_died.connect(on_enemy_died)

	enemies_alive += 1
	enemies_spawned += 1

	print(
		"Enemigo generado | Vivos: ",
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

	# Invocar al Jefe de la oleada actual.
	start_boss_phase()


# ----------------------------------
# INVOCAR AL JEFE DE LA OLEADA
# ----------------------------------

func start_boss_phase() -> void:

	# Evitar invocar al jefe más de una vez.
	if boss_active:
		return

	if current_wave == null:
		return

	boss_active = true

	print(
		"¡EL JEFE ",
		current_wave.boss_display_name.to_upper(),
		" HA APARECIDO!"
	)

	# Crear al jefe reutilizando su escena.
	boss = current_wave.boss_scene.instantiate()

	enemies_container.add_child(boss)

	boss.global_position = current_wave.boss_spawn_position

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

	print("¡JEFE DERROTADO! Oleada superada.")

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

	print("¡OLEADA COMPLETADA!")
	print("Total eliminados: ", enemies_killed)

	# Avisar que podemos activar al jefe.
	wave_cleared.emit()


# ----------------------------------
# CONSULTAR INFORMACIÓN DE LA OLEADA
# ----------------------------------

func get_remaining_time() -> float:

	return wave_timer.time_left


func get_current_wave_name() -> String:

	if current_wave == null:
		return ""

	return current_wave.wave_name


func get_current_wave_number() -> int:

	return current_wave_index + 1


# ----------------------------------
# GENERAR RECOMPENSAS
# ----------------------------------

func spawn_drops(death_position: Vector2) -> void:

	if current_wave == null:
		return

	# XP: siempre aparece.
	create_drop(
		0,
		current_wave.xp_per_enemy,
		death_position
	)

	# Munición: probabilidad configurada por oleada.
	if randf() < current_wave.ammo_drop_chance:

		create_drop(
			1,
			current_wave.ammo_per_drop,
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
	drop.position = spawn_position

	# Añadir al contenedor de forma diferida.
	drops_container.add_child.call_deferred(drop)
