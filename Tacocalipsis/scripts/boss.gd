class_name WaveBoss
extends TacoEnemy

# ----------------------------------
# JEFE DE LA OLEADA 1
# ----------------------------------
# Reutiliza toda la lógica de TacoEnemy
# (salud, daño, señal enemy_died, grupo "enemies")
# y solo reemplaza el comportamiento de movimiento
# por un ataque de embestida recta.

# Se emite al iniciar una embestida (útil para VFX/sonido).
signal charge_started(direction: Vector2)

# Se emite al terminar una embestida (acierte o no).
signal charge_finished


# ----------------------------------
# ESTADOS DEL JEFE
# ----------------------------------

enum BossState {
	CHASE,
	WINDUP,
	DASH,
	RECOVER
}


# ----------------------------------
# CONFIGURACIÓN DE EMBESTIDA
# ----------------------------------

# Escala visual y física del jefe (más grande que un enemigo común).
@export var boss_scale: float = 2.5

# Pausa de carga antes de embestir (telegrafía el ataque).
@export var windup_duration: float = 1.0

# Velocidad de la embestida.
@export var dash_speed: float = 700.0

# Duración máxima de la embestida si no choca con nada.
@export var dash_max_duration: float = 1.0

# Pausa después de embestir antes de volver a perseguir.
@export var recover_duration: float = 0.8

# Tiempo mínimo entre embestidas.
@export var charge_cooldown: float = 2.5

# Distancia a la que comienza a preparar la embestida.
@export var charge_trigger_distance: float = 360.0

# Distancia a la que aplica daño por contacto.
@export var contact_damage_distance: float = 80.0


# ----------------------------------
# ESTADO INTERNO
# ----------------------------------

var _state: BossState = BossState.CHASE
var _state_timer: float = 0.0
var _charge_cooldown_left: float = 0.0
var _dash_direction: Vector2 = Vector2.RIGHT


# ----------------------------------
# INICIALIZACIÓN
# ----------------------------------

func _ready() -> void:

	# Reutilizar la inicialización del enemigo base
	# (vida, grupo "enemies", física, referencias).
	super._ready()

	# Registrar al jefe en su propio grupo.
	add_to_group("boss")

	# Aplicar el tamaño mayor desde el editor.
	scale = Vector2.ONE * boss_scale

	# El jefe siempre persigue al Taquero.
	current_target = player


# ----------------------------------
# LÓGICA PRINCIPAL
# ----------------------------------

func _physics_process(delta: float) -> void:

	if is_dead:
		return

	# Recuperar la referencia al Taquero si hace falta.
	if not is_instance_valid(player):
		player = get_tree().get_first_node_in_group(
			"player"
		) as CharacterBody2D

	if player == null:
		velocity = Vector2.ZERO
		return

	# El jefe solo ataca al Taquero.
	current_target = player

	# Reducir el tiempo de espera entre embestidas.
	_charge_cooldown_left = max(
		_charge_cooldown_left - delta,
		0.0
	)

	match _state:

		BossState.CHASE:
			_process_chase()

		BossState.WINDUP:
			_process_windup(delta)

		BossState.DASH:
			_process_dash(delta)

		BossState.RECOVER:
			_process_recover(delta)


# ----------------------------------
# ESTADO: PERSEGUIR
# ----------------------------------

func _process_chase() -> void:

	var distance: float = global_position.distance_to(
		player.global_position
	)

	# Golpe por contacto si está muy cerca.
	if distance <= contact_damage_distance:
		try_attack()

	# Preparar la embestida si está en rango y sin cooldown.
	if (
		_charge_cooldown_left <= 0.0
		and distance <= charge_trigger_distance
	):
		_enter_windup()
		return

	# Avanzar hacia el Taquero.
	var direction: Vector2 = (
		player.global_position - global_position
	).normalized()

	velocity = direction * move_speed
	move_and_slide()


# ----------------------------------
# ESTADO: CARGA (ANTICIPACIÓN)
# ----------------------------------

func _enter_windup() -> void:

	_state = BossState.WINDUP
	_state_timer = windup_duration
	velocity = Vector2.ZERO

	# Señal visual de que va a embestir.
	modulate = Color(1.0, 0.4, 0.4)

	print("Jefe: preparando embestida...")


func _process_windup(delta: float) -> void:

	# El jefe se queda quieto cargando.
	velocity = Vector2.ZERO

	_state_timer -= delta

	if _state_timer > 0.0:
		return

	# Fijar la dirección recta hacia la posición actual del Taquero.
	_dash_direction = (
		player.global_position - global_position
	).normalized()

	if _dash_direction.length_squared() < 0.001:
		_dash_direction = Vector2.RIGHT

	_enter_dash()


# ----------------------------------
# ESTADO: EMBESTIDA
# ----------------------------------

func _enter_dash() -> void:

	_state = BossState.DASH
	_state_timer = dash_max_duration

	modulate = Color(1.0, 1.0, 1.0)

	charge_started.emit(_dash_direction)

	print("Jefe: ¡EMBESTIDA!")


func _process_dash(delta: float) -> void:

	_state_timer -= delta

	# Movimiento recto a alta velocidad.
	velocity = _dash_direction * dash_speed
	move_and_slide()

	# Daño por contacto durante la embestida.
	var distance: float = global_position.distance_to(
		player.global_position
	)

	if distance <= contact_damage_distance:
		try_attack()

	# Terminar si se agota el tiempo o choca con algo.
	if (
		_state_timer <= 0.0
		or get_slide_collision_count() > 0
	):
		_enter_recover()


# ----------------------------------
# ESTADO: RECUPERACIÓN
# ----------------------------------

func _enter_recover() -> void:

	_state = BossState.RECOVER
	_state_timer = recover_duration
	velocity = Vector2.ZERO

	charge_finished.emit()


func _process_recover(delta: float) -> void:

	velocity = Vector2.ZERO

	_state_timer -= delta

	if _state_timer > 0.0:
		return

	# Volver a perseguir tras un breve cooldown.
	_charge_cooldown_left = charge_cooldown
	_state = BossState.CHASE


# ----------------------------------
# MUERTE
# ----------------------------------

func die() -> void:

	if is_dead:
		return

	print("¡EL JEFE DE LA OLEADA HA SIDO DERROTADO!")

	# Reutilizar la muerte del enemigo base
	# (emite enemy_died y libera el nodo).
	super.die()