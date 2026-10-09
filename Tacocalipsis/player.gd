extends CharacterBody2D

signal health_changed(new_health, max_health)
signal player_died

@export var max_health: int = 100
var current_health: int

const SPEED = 300.0
var is_carring: bool = false
var can_attack: bool = true

@onready var screen_size = get_viewport_rect().size
@onready var knife_hitbox: Area2D = $KnifeHitbox
@onready var attack_timer: Timer = $AttackTimer
@onready var knife_collision: CollisionShape2D = $KnifeHitbox/CollisionShape2D

func _ready() -> void:
	position = screen_size / 2
	current_health = max_health
	health_changed.emit(current_health, max_health)
	
	
	knife_collision.disabled = true
	
	
	attack_timer.timeout.connect(_on_attack_timer_timeout)
	knife_hitbox.area_entered.connect(_on_knife_hitbox_entered)
	knife_hitbox.body_entered.connect(_on_knife_hitbox_entered)

func _physics_process(_delta: float) -> void:
	var direction := Input.get_vector(
		"move_left",
		"move_right",
		"move_up",
		"move_down"
	)
	velocity = direction * SPEED
	move_and_slide()
	position = position.clamp(Vector2.ZERO, screen_size)

func _unhandled_input(event: InputEvent) -> void:
	
	if event.is_action_pressed("attack") and can_attack and not is_carring:
		attack()

func attack() -> void:
	can_attack = false
	knife_collision.disabled = false
	print("¡Ataque de cuchillo!")
	
	
	get_tree().create_timer(0.15).timeout.connect(func(): knife_collision.disabled = true)
	
	
	attack_timer.start()

func _on_attack_timer_timeout() -> void:
	can_attack = true

func _on_knife_hitbox_entered(body_or_area: Node) -> void:
	if body_or_area.has_method("take_damage") and body_or_area != self:
		body_or_area.take_damage(25)
		print("¡Enemigo golpeado por el cuchillo!")

func _on_cart_carring_change(value: bool) -> void:
	is_carring = value

func take_damage(amount: int) -> void:
	current_health = max(0, current_health - amount)
	health_changed.emit(current_health, max_health)
	
	if current_health <= 0:
		player_died.emit()
