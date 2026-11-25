
extends CharacterBody2D

# Señal que utilizaremos para actualizar la barra
# de salud del carrito.
signal health_changed(current: float, maximum: float)

# Señal que se ejecutará cuando el carrito sea destruido.
signal cart_destroyed


# Vida máxima del carrito.
@export var max_health: float = 150.0

# Referencia al gestor de audio global.
@onready var audio: AudioManager = get_node("/root/AudioManager")

# Vida actual.
var current_health: float = 150.0

# Identifica si el Taquero está sujetando el carrito.
var is_attached: bool = false


# Texturas del carrito según su estado.
const TEX_OK: Texture2D = preload("res://assets/carrito/saludable.png")
const TEX_DAMAGED: Texture2D = preload("res://assets/carrito/dañado.png")
const TEX_DESTROYED: Texture2D = preload("res://assets/carrito/destruido.png")

# Sprite del carrito.
@onready var sprite: Sprite2D = $Sprite2D


func _ready() -> void:
	# Inicializar salud.
	current_health = max_health

	# Permitir que otros scripts encuentren el carrito.
	add_to_group("cart")

	# Configurar física de movimiento superior.
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING

	# Actualizar la apariencia inicial.
	update_visual()


# Esta función se utilizará cuando un enemigo
# ataque al carrito.

func take_damage(amount: float) -> void:

	# Si el carrito ya fue destruido, ignorar el daño.
	if current_health <= 0.0:
		return

	# Restar daño.
	current_health = max(
		current_health - amount,
		0.0
	)

	# Reproducir sonido de daño carrito.
	audio.play_sfx("carrito_dano")

	# Actualizar la interfaz.
	health_changed.emit(current_health, max_health)

	# Actualizar la apariencia según el daño.
	update_visual()

	print("Vida del carrito: ", current_health)

	# Detectar destrucción.
	if current_health <= 0.0:
		cart_destroyed.emit()

	# Reproducir sonido de destrucción carrito.
	audio.play_sfx("carrito_destruido")


# Recuperar puntos de vida.
func heal(amount: float) -> void:

	current_health = min(
		current_health + amount,
		max_health
	)

	health_changed.emit(current_health, max_health)

	update_visual()


# Aumentar la vida máxima del carrito y curar esa cantidad.
# Se reutiliza para la recompensa del jefe.
func increase_max_health(percentage: float) -> void:

	# Aumentar el máximo según el porcentaje indicado.
	max_health *= 1.0 + percentage

	# Curar según el nuevo máximo, sin superarlo.
	current_health = min(
		current_health + max_health * percentage,
		max_health
	)

	health_changed.emit(current_health, max_health)

	update_visual()


# Esta función será útil al terminar el Sprint 3.
# Al derrotar al jefe, el carrito recuperará toda su vida.
func restore_full_health() -> void:

	current_health = max_health

	health_changed.emit(current_health, max_health)

	update_visual()


# Actualiza el sprite según la salud del carrito.
func update_visual() -> void:

	if sprite == null:
		return

	var ratio: float = 0.0

	if max_health > 0.0:
		ratio = current_health / max_health

	if current_health <= 0.0:
		sprite.texture = TEX_DESTROYED
	elif ratio <= 0.5:
		sprite.texture = TEX_DAMAGED
	else:
		sprite.texture = TEX_OK
