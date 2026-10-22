
extends CharacterBody2D

# Señal que utilizaremos para actualizar la barra
# de salud del carrito.
signal health_changed(current: float, maximum: float)

# Señal que se ejecutará cuando el carrito sea destruido.
signal cart_destroyed


# Vida máxima del carrito.
@export var max_health: float = 150.0

# Vida actual.
var current_health: float = 150.0

# Identifica si el Taquero está sujetando el carrito.
var is_attached: bool = false


func _ready() -> void:
	# Inicializar salud.
	current_health = max_health

	# Permitir que otros scripts encuentren el carrito.
	add_to_group("cart")

	# Configurar física de movimiento superior.
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING


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

	# Actualizar la interfaz.
	health_changed.emit(current_health, max_health)

	print("Vida del carrito: ", current_health)

	# Detectar destrucción.
	if current_health <= 0.0:
		cart_destroyed.emit()


# Recuperar puntos de vida.
func heal(amount: float) -> void:

	current_health = min(
		current_health + amount,
		max_health
	)

	health_changed.emit(current_health, max_health)


# Esta función será útil al terminar el Sprint 3.
# Al derrotar al jefe, el carrito recuperará toda su vida.
func restore_full_health() -> void:

	current_health = max_health

	health_changed.emit(current_health, max_health)
