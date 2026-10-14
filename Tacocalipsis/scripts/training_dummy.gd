
extends StaticBody2D

# Vida del objetivo.
@export var max_health: float = 60.0

var current_health: float = 60.0


func _ready() -> void:

	current_health = max_health

	# Registrar como enemigo.
	add_to_group("enemies")


func take_damage(amount: float) -> void:

	# Restar puntos de vida.
	current_health -= amount

	print("Objetivo recibió ", amount, " de daño.")

	print("Vida restante: ", current_health)

	# Destruir al llegar a cero.
	if current_health <= 0.0:
		print("¡Objetivo destruido!")
		queue_free()
