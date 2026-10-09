extends CharacterBody2D

@onready var screen_size = get_viewport_rect().size

const SPEED = 300.0


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
