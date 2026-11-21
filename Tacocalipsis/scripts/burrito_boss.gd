class_name BurritoBoss
extends TacoEnemy

# ----------------------------------
# JEFE DE LA OLEADA 2 (BURRITO SUPREMO)
# ----------------------------------
# Reutiliza toda la lógica de TacoEnemy (salud, daño,
# señal enemy_died, grupo "enemies", persecución y
# ataque melee) y añade dos cosas:
#   - Escala mayor (más resistente y grande).
#   - Lanza proyectiles lentos de frijol al Taquero.

# Escala visual y física del jefe.
@export var boss_scale: float = 3.0

# Escena del proyectil de frijol.
@export var bean_scene: PackedScene

# Daño de cada proyectil de frijol.
@export var bean_damage: float = 10.0

# Tiempo entre cada lanzamiento de frijol.
@export var bean_interval: float = 2.2

# Contador interno para el próximo lanzamiento.
var _shoot_timer: float = 0.0


# ----------------------------------
# INICIALIZACIÓN
# ----------------------------------

func _ready() -> void:

	# Reutilizar la inicialización del enemigo base.
	super._ready()

	# Registrar al jefe en su propio grupo.
	add_to_group("boss")

	# Aplicar el tamaño mayor.
	scale = Vector2.ONE * boss_scale

	# Empezar con el lanzamiento listo.
	_shoot_timer = bean_interval

	# El jefe siempre persigue al Taquero.
	current_target = player


# ----------------------------------
# LÓGICA PRINCIPAL
# ----------------------------------

func _physics_process(delta: float) -> void:

	# Persecución y ataque melee heredados.
	super._physics_process(delta)

	if is_dead:
		return

	if not is_instance_valid(player):
		return

	# Lanzar frijoles de forma periódica.
	_shoot_timer -= delta

	if _shoot_timer <= 0.0:
		_shoot_timer = bean_interval
		fire_bean()


# ----------------------------------
# SELECCIÓN DE OBJETIVO
# ----------------------------------

# El jefe ignora al carrito y persigue al Taquero.
func choose_target() -> void:

	if not is_instance_valid(player):
		player = get_tree().get_first_node_in_group(
			"player"
		) as CharacterBody2D

	current_target = player


# ----------------------------------
# LANZAR FRIJOL
# ----------------------------------

func fire_bean() -> void:

	if bean_scene == null:
		return

	if not is_instance_valid(player):
		return

	# Dirección desde el jefe hasta el Taquero.
	var direction: Vector2 = (
		player.global_position - global_position
	).normalized()

	if direction == Vector2.ZERO:
		direction = Vector2.RIGHT

	# Contenedor de proyectiles enemigos.
	var container: Node = get_tree().current_scene.get_node_or_null(
		"World/EnemyProjectiles"
	)

	# Crear el proyectil.
	var bean = bean_scene.instantiate()

	if container != null:
		container.add_child(bean)
	else:
		get_parent().add_child(bean)

	# Colocarlo delante del jefe.
	bean.global_position = global_position + direction * 34.0

	# Configurar trayectoria y daño.
	bean.setup(direction, bean_damage)

	# Mostrar la animación de ataque.
	play_attack_animation()

	print("Burrito Supremo lanzó un frijol.")


# ----------------------------------
# MUERTE
# ----------------------------------

func die() -> void:

	if is_dead:
		return

	print("¡EL BURRITO SUPREMO HA SIDO DERROTADO!")

	# Reutilizar la muerte del enemigo base.
	super.die()