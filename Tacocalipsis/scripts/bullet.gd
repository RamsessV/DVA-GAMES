
extends Area2D

# ----------------------------------
# CONFIGURACIÓN DEL PROYECTIL
# ----------------------------------

@export var speed: float = 650.0
@export var damage: float = 20.0

# Tiempo máximo de existencia en segundos.
@export var lifetime: float = 2.0

# Dirección de movimiento.
var direction: Vector2 = Vector2.RIGHT

# Evita procesar más de un impacto.
var has_hit: bool = false


func _ready() -> void:

	# Detectar cuerpos físicos.
	body_entered.connect(on_body_entered)


# ----------------------------------
# MOVIMIENTO Y COLISIONES
# ----------------------------------

func _physics_process(delta: float) -> void:

	if has_hit:
		return

	# Calcular el desplazamiento de este frame.
	var movement: Vector2 = direction * speed * delta

	# Consultar si hay una pared o enemigo en la trayectoria.
	var query := PhysicsRayQueryParameters2D.create(
		global_position,
		global_position + movement,
		collision_mask
	)

	var result := get_world_2d().direct_space_state.intersect_ray(query)

	if not result.is_empty():

		# Colocar el proyectil en el punto de impacto.
		global_position = result["position"]

		process_hit(result["collider"])

		return

	# Si no chocó con nada, avanzar.
	global_position += movement

	# Reducir tiempo de vida.
	lifetime -= delta

	if lifetime <= 0.0:
		queue_free()


# ----------------------------------
# DETECTAR IMPACTO
# ----------------------------------

func on_body_entered(body: Node2D) -> void:

	process_hit(body)


func process_hit(body: Object) -> void:

	if has_hit:
		return

	has_hit = true

	# Solamente dañar enemigos.
	if body is Node and body.is_in_group("enemies"):

		if body.has_method("take_damage"):
			body.take_damage(damage)

			print("Bala impactó enemigo: ", body.name)

	else:
		print("Bala impactó una cobertura.")

	# Eliminar la bala después del impacto.
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

	# Orientar visualmente la bala.
	rotation = direction.angle()
