
extends Area2D

# ----------------------------------
# TIPOS DE DROP
# ----------------------------------

enum DropType {
	XP,
	AMMO
}

# Recompensa que contiene el objeto.
@export var drop_type: DropType = DropType.XP

# Cantidad de XP o munición.
@export var amount: int = 10

# ----------------------------------
# SISTEMA DE IMÁN
# ----------------------------------

# Distancia para comenzar a atraer el drop.
@export var magnet_radius: float = 110.0

# Velocidad de atracción.
@export var magnet_speed: float = 280.0

# Distancia para recoger automáticamente.
@export var pickup_radius: float = 18.0

# Referencia al Taquero.
var player: CharacterBody2D = null

# Evitar recolectarlo más de una vez.
var collected: bool = false

# Referencia a la apariencia.
@onready var drop_visual: Polygon2D = $Polygon2D


# ----------------------------------
# INICIALIZACIÓN
# ----------------------------------

func _ready() -> void:

	# Buscar al Taquero.
	player = get_tree().get_first_node_in_group(
        "player"
	) as CharacterBody2D

	# Conectar detección física.
	body_entered.connect(on_body_entered)

	# Aplicar color según tipo.
	update_visual()


# ----------------------------------
# APARIENCIA
# ----------------------------------

func update_visual() -> void:

	if drop_type == DropType.XP:
		drop_visual.color = Color(0.25, 0.8, 1.0)

	elif drop_type == DropType.AMMO:
		drop_visual.color = Color(1.0, 0.75, 0.2)


# ----------------------------------
# ATRACCIÓN MAGNÉTICA
# ----------------------------------

func _physics_process(delta: float) -> void:

	if collected:
		return

	# Recuperar referencia si es necesario.
	if not is_instance_valid(player):
		player = get_tree().get_first_node_in_group(
            "player"
		) as CharacterBody2D

	if player == null:
		return

	# Distancia entre el drop y el Taquero.
	var distance: float = global_position.distance_to(
		player.global_position
	)

	# Recoger si está suficientemente cerca.
	if distance <= pickup_radius:
		collect()
		return

	# Activar el imán dentro del radio.
	if distance <= magnet_radius:

		# Mover progresivamente hacia el Taquero.
		global_position = global_position.move_toward(
			player.global_position,
			magnet_speed * delta
		)


# ----------------------------------
# CONTACTO CON EL TAQUERO
# ----------------------------------

func on_body_entered(body: Node2D) -> void:

	if body.is_in_group("player"):
		collect()


# ----------------------------------
# RECOLECTAR RECOMPENSA
# ----------------------------------

func collect() -> void:

	if collected:
		return

	if not is_instance_valid(player):
		return

	collected = true

	match drop_type:

		DropType.XP:
			if player.has_method("add_xp"):
				player.add_xp(amount)

			print("XP recolectada: ", amount)

		DropType.AMMO:
			if player.has_method("add_ammo"):
				player.add_ammo(amount)

			print("Munición recolectada: ", amount)

	# Desaparecer después de recogerlo.
	queue_free()


# ----------------------------------
# CONFIGURAR DROP
# ----------------------------------

func setup(
	new_type: DropType,
	new_amount: int
) -> void:

	drop_type = new_type
	amount = new_amount

	# Si el nodo ya está listo,
	# actualizar inmediatamente el color.
	if is_node_ready():
		update_visual()
