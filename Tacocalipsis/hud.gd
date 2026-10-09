extends Control

@onready var player_bar: ProgressBar = $CanvasLayer/PlayerHealthBar
@onready var cart_bar: ProgressBar = $CanvasLayer/CartHealthBar
@onready var game_over_label: Label = $CanvasLayer/GameOverLabel

func _ready() -> void:
	game_over_label.hide()

func update_player_health(current: int, max_val: int) -> void:
	player_bar.max_value = max_val
	player_bar.value = current

func update_cart_health(current: int, max_val: int) -> void:
	cart_bar.max_value = max_val
	cart_bar.value = current

func show_game_over(reason: String) -> void:
	game_over_label.text = "GAME OVER\n" + reason
	game_over_label.show()
