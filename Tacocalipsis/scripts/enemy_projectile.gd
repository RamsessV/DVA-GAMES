class_name EnemyProjectile
extends Area2D

# ----------------------------------
# PROYECTIL ENEMIGO (FRIJOL)
# ----------------------------------
# Reutiliza el patrón del proyectil del jugador
# (bullet.gd): movimiento con raycast para no
# atravesar paredes, pero daña al Taquero y al
# carrito en lugar de a los enemigos.

# Velocidad de desplazamiento.
@export var speed: float = 220.0

# Daño que causa al impactar.
@export var damage: float = 10.0

# Tiempo máximo de existencia en segundos.
@export var lifetime: float = 5.0

# Dirección de movimiento.
var direction: Vector2 = Vector2.RIGHT

# Evita procesar más de un impacto.
var has_hit: bool = false


func _ready() -> void:

	# Detectar cuerpos físicos (jugador / carrito).
	body_entered.connect(on_body_entered)


# ----------------------------------
# MOVIMIENTO Y COLISIONES
# ----------------------------------

func _physics_process(delta: float) -> void:

	if has_hit:
		return

	# Desplazamiento de este frame.
	var movement: Vector2 = direction * speed * delta

	# Consultar si hay un objetivo o pared en la trayectoria.
	var query := PhysicsRayQueryParameters2D.create(
		global_position,
		global_position + movement,
		collision_mask
	)

	var result := get_world_2d().direct_space_state.intersect_ray(query)

	if not result.is_empty():

		global_position = result["position"]

		process_hit(result["collider"])

		return

	# Si no chocó con nada, avanzar.
	global_position += movement

	# Reducir tiempo de vida.
	lifetime -= delta

	if lifetime <= 0.0:
		queue_free()


func on_body_entered(body: Node2D) -> void:

	process_hit(body)


func process_hit(body: Object) -> void:

	if has_hit:
		return

	has_hit = true

	# Solamente dañar al Taquero o al carrito.
	if body is Node and (
		body.is_in_group("player")
		or body.is_in_group("cart")
	):

		if body.has_method("take_damage"):

			body.take_damage(damage)

			print("Frijol impactó a: ", body.name)

	else:
		print("Frijol impactó una cobertura.")

	# Eliminar el proyectil tras el impacto.
	queue_free()


# ----------------------------------
# INICIALIZAR DISPARO
# ----------------------------------

func setup(
	new_direction: Vector2,
	new_damage: float
) -> void:

	direction = new_direction.normalized()

	damage = new_damage

	# Orientar visualmente el proyectil.
	rotation = direction.angle()