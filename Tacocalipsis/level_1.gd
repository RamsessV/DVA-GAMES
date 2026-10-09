extends Node2D

@onready var player = $Player
@onready var cart = $Cart
@onready var hud = $HUD

func _ready() -> void:
	player.health_changed.connect(hud.update_player_health)
	cart.health_changed.connect(hud.update_cart_health)
	
	hud.update_player_health(player.current_health, player.max_health)
	hud.update_cart_health(cart.current_health, cart.max_health)
	
	player.player_died.connect(_on_game_over.bind("¡El Taquero ha caído!"))
	cart.cart_destroyed.connect(_on_game_over.bind("¡Destruyeron el Carrito!"))

func _on_game_over(reason: String) -> void:
	print("GAME OVER: ", reason)
	hud.show_game_over(reason)
	get_tree().paused = true
