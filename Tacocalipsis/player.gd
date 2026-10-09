extends CharacterBody2D

@onready var screen_size = get_viewport_rect().size


const SPEED = 300.0
var is_carring = false

@export var max_health: int = 100
var current_health: int

signal health_changed(new_health, max_health)
signal player_died

func _ready() -> void:
	position = screen_size / 2
	current_health = max_health

func _physics_process(delta: float) -> void:
	var direction := Input.get_vector(
		"move_left",
		"move_right",
		"move_up",
		"move_down"
	)
	velocity = direction * SPEED
	move_and_slide()
	position = position.clamp(Vector2.ZERO, screen_size)
	
	if not is_carring:
		print("Puede atacar")
	else :
		print("No puede atacar")


func _on_cart_carring_change(value: bool) -> void:
	is_carring = value

func take_damage(amount: int) -> void:
	current_health = max(0, current_health - amount)
	health_changed.emit(current_health, max_health)
	
	if current_health <= 0:
		player_died.emit()

#Esto esta provisionalmente para probar lo del daño
func _unhandled_input(event: InputEvent) -> void:

	if event.is_action_pressed("ui_accept") or event.is_echo() == false and Input.is_key_pressed(KEY_J):
		take_damage(20)
		print("Taquero vida actual: ", current_health)
		

	if Input.is_key_pressed(KEY_K) and event.is_pressed() and not event.is_echo():
		var cart_node = get_parent().get_node_or_null("Cart")
		if cart_node and cart_node.has_method("take_damage"):
			cart_node.take_damage(20)
			print("Carrito vida actual: ", cart_node.current_health)
