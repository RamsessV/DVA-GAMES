class_name IntroScreen
extends Control

# ----------------------------------
# PANTALLA DE HISTORIETA (CÓMIC)
# ----------------------------------
# Se reutiliza tanto para la historieta de introducción
# (como escena independiente) como para la del nivel 2
# (mostrada como superposición durante la partida).

# Se emite al avanzar o saltar cuando la historieta se usa
# como superposición. Si `next_scene_path` está vacío, se usa esto.
signal finished

# Textura de la historieta. Si es null, se usa la de la escena.
@export var comic_texture: Texture2D

# Escena a la que ir al avanzar. Si está vacía, se emite `finished`.
@export var next_scene_path: String = "res://scenes/main.tscn"


@onready var comic: TextureRect = $Comic

@onready var continue_button: Button = (
	$BottomBar/CenterContainer/HBoxContainer/ContinueButton
)

@onready var skip_button: Button = (
	$BottomBar/CenterContainer/HBoxContainer/SkipButton
)


func _ready() -> void:

	# Usar la textura indicada, si se proporcionó una.
	if comic_texture != null:
		comic.texture = comic_texture

	continue_button.pressed.connect(_on_continue_pressed)
	skip_button.pressed.connect(_on_skip_pressed)

	# Dar foco al primer botón solo si la historieta está visible
	# (como escena independiente).
	if visible:
		continue_button.grab_focus()


# Muestra la historieta y da foco al botón de avanzar.
func open() -> void:

	# Aplicar la textura configurada, si la hay.
	if comic_texture != null:
		comic.texture = comic_texture

	show()

	continue_button.grab_focus()


func _on_continue_pressed() -> void:

	_advance()


func _on_skip_pressed() -> void:

	_advance()


func _advance() -> void:

	# Como superposición: avisar a quien la mostró.
	if next_scene_path.is_empty():
		finished.emit()
		return

	# Como escena independiente: cargar la siguiente escena.
	get_tree().change_scene_to_file(next_scene_path)