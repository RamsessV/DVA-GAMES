extends Area2D

signal carring_change(value: bool)

var player_near := false
var is_carried := false
var player: CharacterBody2D

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _process(_delta: float) -> void:
	if player_near and Input.is_action_just_pressed("interact"):
		is_carried = not is_carried

		carring_change.emit(is_carried)
		if is_carried:
			reparent(player)
			position = Vector2(40, 0)
		else:
			reparent(get_tree().current_scene, true)

func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		player_near = true
		player = body

func _on_body_exited(body: Node2D) -> void:
	if body == player:
		player_near = false
