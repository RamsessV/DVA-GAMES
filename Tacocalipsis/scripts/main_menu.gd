extends Control

# ----------------------------------
# MENÚ PRINCIPAL
# ----------------------------------

# Escena de la historieta de introducción.
const INTRO_SCENE: String = "res://scenes/intro.tscn"


@onready var play_button: Button = (
	$CenterContainer/VBoxContainer/PlayButton
)

@onready var options_button: Button = (
	$CenterContainer/VBoxContainer/OptionsButton
)

@onready var quit_button: Button = (
	$CenterContainer/VBoxContainer/QuitButton
)

@onready var options_menu: Control = $OptionsMenu


func _ready() -> void:

	# Cargar y aplicar la configuración guardada.
	Settings.load_settings()

	play_button.pressed.connect(on_play)
	options_button.pressed.connect(on_options)
	quit_button.pressed.connect(on_quit)

	# Dar foco al primer botón.
	play_button.grab_focus()


func on_play() -> void:

	get_tree().change_scene_to_file(INTRO_SCENE)


func on_options() -> void:

	options_menu.open()


func on_quit() -> void:

	get_tree().quit()
