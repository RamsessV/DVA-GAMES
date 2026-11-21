
class_name TacoEnemy
extends CharacterBody2D

# ----------------------------------
# SEÑALES
# ----------------------------------

# Avisará cuando el enemigo muera.
# Después servirá para generar XP y munición.
signal enemy_died(death_position: Vector2)

# Avisará cuando cambie la vida del enemigo.
# Se reutiliza para la barra de vida del jefe.
signal health_changed(current: float, maximum: float)


# ----------------------------------
# CONFIGURACIÓN DEL ENEMIGO
# ----------------------------------

# Vida máxima del Taco Mutante.
@export var max_health: float = 60.0

# Velocidad de persecución.
@export var move_speed: float = 50.0

# Nombre visible para mensajes del HUD.
@export var display_name: String = "Taco Mutante"

# Daño de cada ataque.
@export var attack_damage: float = 5.0

# Distancia máxima para poder atacar.
@export var attack_range: float = 40.0

# Distancia a la que deja de avanzar.
@export var stop_distance: float = 38.0

# Vida actual.
var current_health: float = 60.0

# Referencias al Taquero y al carrito.
var player: CharacterBody2D = null
var cart: CharacterBody2D = null

# Objetivo que está persiguiendo.
var current_target: CharacterBody2D = null

# Indica si el enemigo ya fue derrotado.
var is_dead: bool = false

# Temporizador de ataque.
@onready var attack_cooldown: Timer = $AttackCooldown

# Sprite animado del enemigo (si la escena lo incluye).
@onready var sprite: AnimatedSprite2D = get_node_or_null("AnimatedSprite2D")


# ----------------------------------
# INICIALIZACIÓN
# ----------------------------------

func _ready() -> void:

	current_health = max_health

	# Identificar al enemigo para el cuchillo.
	add_to_group("enemies")

	# Física de vista superior.
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING

	# Buscar las entidades que puede atacar.
	player = get_tree().get_first_node_in_group(
        "player"
	) as CharacterBody2D

	cart = get_tree().get_first_node_in_group(
        "cart"
	) as CharacterBody2D


# ----------------------------------
# LÓGICA PRINCIPAL
# ----------------------------------

func _physics_process(_delta: float) -> void:

	# No hacer nada si murió.
	if is_dead:
		return

	# Elegir un objetivo.
	choose_target()

	# Mirar siempre hacia el objetivo.
	if is_instance_valid(current_target):
		_face(current_target.global_position - global_position)

	if current_target == null:
		velocity = Vector2.ZERO
		return

	# Distancia al objetivo.
	var distance: float = global_position.distance_to(
		current_target.global_position
	)


	if distance <= attack_range:

		velocity = Vector2.ZERO

		# Verificar que no exista una pared entre
		# el enemigo y su objetivo.
		if has_clear_attack_path():
			try_attack()

		return


	# Si está suficientemente lejos, perseguir.
	if distance > stop_distance:

		var direction: Vector2 = (
			current_target.global_position - global_position
		).normalized()

		velocity = direction * move_speed

		move_and_slide()


# ----------------------------------
# SELECCIÓN DE OBJETIVO
# ----------------------------------

func choose_target() -> void:

	# Buscar nuevamente si aún no encontramos
	# al Taquero o al carrito.
	if not is_instance_valid(player):
		player = get_tree().get_first_node_in_group(
            "player"
		) as CharacterBody2D

	if not is_instance_valid(cart):
		cart = get_tree().get_first_node_in_group(
            "cart"
		) as CharacterBody2D

	# Si ambos están disponibles,
	# perseguir al más cercano.
	if is_instance_valid(player) and is_instance_valid(cart):

		var player_distance: float = global_position.distance_to(
			player.global_position
		)

		var cart_distance: float = global_position.distance_to(
			cart.global_position
		)

		if player_distance <= cart_distance:
			current_target = player
		else:
			current_target = cart

	elif is_instance_valid(player):
		current_target = player

	elif is_instance_valid(cart):
		current_target = cart

	else:
		current_target = null


# ----------------------------------
# SISTEMA DE ATAQUE
# ----------------------------------

func try_attack() -> void:

	if current_target == null:
		return

	# No atacar hasta que termine el cooldown.
	if not attack_cooldown.is_stopped():
		return

	# Aplicar daño al objetivo.
	if current_target.has_method("take_damage"):

		current_target.take_damage(attack_damage)

		print(
			display_name,
			" atacó a: ",
			current_target.name
		)

		# Esperar antes del siguiente ataque.
		attack_cooldown.start()

		# Mostrar la animación de ataque.
		play_attack_animation()


# ----------------------------------
# SISTEMA DE SALUD
# ----------------------------------

func take_damage(amount: float) -> void:

	if is_dead:
		return

	# Restar vida.
	current_health = max(
		current_health - amount,
		0.0
	)

	print(
		display_name,
		" recibió daño. HP: ",
		current_health
	)

	# Comunicar el cambio de vida (lo usa el HUD del jefe).
	health_changed.emit(current_health, max_health)

	# Comprobar muerte.
	if current_health <= 0.0:
		die()


# ----------------------------------
# MUERTE DEL ENEMIGO
# ----------------------------------

func die() -> void:

	if is_dead:
		return

	is_dead = true

	print("¡", display_name, " eliminado!")

	# Avisar su posición de muerte.
	enemy_died.emit(global_position)

	# Si hay animación de muerte, mostrarla antes de desaparecer.
	if (
		sprite != null
		and sprite.sprite_frames != null
		and sprite.sprite_frames.has_animation("dead")
	):

		_play_anim("dead")

		# Dejar de procesar y quitar la colisión para no estorbar.
		set_physics_process(false)
		set_deferred("collision_layer", 0)

		# Esperar brevemente antes de eliminar el nodo.
		await get_tree().create_timer(0.8).timeout

	# Eliminarlo del escenario.
	queue_free()


# ----------------------------------
# ANIMACIÓN
# ----------------------------------

func _play_anim(anim_name: String) -> void:

	if sprite == null or sprite.sprite_frames == null:
		return

	if not sprite.sprite_frames.has_animation(anim_name):
		return

	if sprite.animation != anim_name:
		sprite.play(anim_name)


func play_attack_animation() -> void:

	if sprite == null or sprite.sprite_frames == null:
		return

	if not sprite.sprite_frames.has_animation("attack"):
		return

	_play_anim("attack")

	# Volver a la animación quieta después de un instante.
	await get_tree().create_timer(0.3).timeout

	if not is_dead:
		_play_anim("idle")


func _face(direction: Vector2) -> void:

	if sprite == null:
		return

	# Mirar hacia la dirección indicada.
	if direction.length_squared() < 0.001:
		return

	# Los sprites de los enemigos apuntan a la derecha por defecto,
	# así que la rotación 0 ya apunta hacia la derecha.
	sprite.rotation = direction.angle()
	sprite.flip_h = false
	
	

# ----------------------------------
# VERIFICAR TRAYECTORIA DEL ATAQUE
# ----------------------------------

func has_clear_attack_path() -> bool:

	if not is_instance_valid(current_target):
		return false

	# Obtener el espacio físico del escenario.
	var space_state = get_world_2d().direct_space_state

	# Lanzar una consulta desde el enemigo
	# hasta su objetivo.
	var query = PhysicsRayQueryParameters2D.create(
		global_position,
		current_target.global_position,
		1
	)

	# Ignorar el cuerpo del propio enemigo.
	query.exclude = [get_rid()]

	var result = space_state.intersect_ray(query)

	# Si golpeamos un obstáculo World,
	# el ataque queda bloqueado.
	return result.is_empty()
