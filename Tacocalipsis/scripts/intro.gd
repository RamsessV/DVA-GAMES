extends Control

# ----------------------------------
# PANTALLA DE INTRODUCCIÓN (CÓMIC)
# ----------------------------------
# Muestra la historieta del nivel 1 y permite
# continuar hacia la partida.

# Escena principal del juego.
const MAIN_SCENE: String = "res://scenes/main.tscn"


@onready var continue_button: Button = (
	$BottomBar/CenterContainer/ContinueButton
)


func _ready() -> void:

	continue_button.pressed.connect(on_continue)

	continue_button.grab_focus()


func on_continue() -> void:

	get_tree().change_scene_to_file(MAIN_SCENE)
