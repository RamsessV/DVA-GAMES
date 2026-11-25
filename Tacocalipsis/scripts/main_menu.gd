extends Control

# ----------------------------------
# MENÚ PRINCIPAL
# ----------------------------------
# Fondo animado estilo panorama (paneo + zoom con Tween),
# enemigos caminando, Taquero/carrito en idle y partículas
# de baba. Todo decorativo: no altera el flujo del menú.

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

# Nodos de la animación decorativa.
@onready var panorama: Node2D = $Backdrop/Panorama
@onready var walkers: Node2D = $Backdrop/Panorama/Walkers
@onready var taquero: Sprite2D = $Backdrop/Taquero
@onready var carrito: Sprite2D = $Backdrop/Carrito
@onready var title: Label = (
	$CenterContainer/VBoxContainer/TitleHolder/TitleLabel
)


func _ready() -> void:

	# Cargar y aplicar la configuración guardada.
	Settings.load_settings()

	# Aplicar el cursor personalizado.
	Settings.apply_cursor()

	# Música del menú principal.
	AudioManager.play_musica("musica_menu")

	play_button.pressed.connect(on_play)
	options_button.pressed.connect(on_options)
	quit_button.pressed.connect(on_quit)

	# Dar foco al primer botón.
	play_button.grab_focus()

	# Animación decorativa del menú.
	_start_background_pan()
	_start_title_float()
	_start_idle_breathing(taquero)
	_start_idle_breathing(carrito)
	_start_walkers()
	_start_button_hover()
	_play_fade_in()


# ----------------------------------
# FADE-IN AL ABRIR
# ----------------------------------

func _play_fade_in() -> void:

	modulate.a = 0.0

	var tween: Tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 0.6).set_trans(
		Tween.TRANS_SINE
	).set_ease(Tween.EASE_OUT)


# ----------------------------------
# FONDO (PANEO + ZOOM)
# ----------------------------------

func _start_background_pan() -> void:

	# Paneo horizontal continuo (tipo ping-pong).
	var pan: Tween = create_tween().set_loops()
	pan.tween_property(panorama, "position:x", 724.0, 9.0).set_trans(
		Tween.TRANS_SINE
	).set_ease(Tween.EASE_IN_OUT)
	pan.tween_property(panorama, "position:x", 556.0, 9.0).set_trans(
		Tween.TRANS_SINE
	).set_ease(Tween.EASE_IN_OUT)

	# Zoom in / out leve y continuo.
	var zoom: Tween = create_tween().set_loops()
	zoom.tween_property(panorama, "scale", Vector2(1.05, 1.05), 7.0).set_trans(
		Tween.TRANS_SINE
	).set_ease(Tween.EASE_IN_OUT)
	zoom.tween_property(panorama, "scale", Vector2.ONE, 7.0).set_trans(
		Tween.TRANS_SINE
	).set_ease(Tween.EASE_IN_OUT)


# ----------------------------------
# TÍTULO FLOTANTE
# ----------------------------------

func _start_title_float() -> void:

	var tween: Tween = create_tween().set_loops()
	tween.tween_property(title, "position:y", 8.0, 1.6).set_trans(
		Tween.TRANS_SINE
	).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(title, "position:y", -8.0, 1.6).set_trans(
		Tween.TRANS_SINE
	).set_ease(Tween.EASE_IN_OUT)


# ----------------------------------
# RESPIRACIÓN (IDLE)
# ----------------------------------

func _start_idle_breathing(node: Sprite2D) -> void:

	var base_scale: Vector2 = node.scale

	var tween: Tween = create_tween().set_loops()
	tween.tween_property(node, "scale", base_scale * 1.06, 1.4).set_trans(
		Tween.TRANS_SINE
	).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(node, "scale", base_scale, 1.4).set_trans(
		Tween.TRANS_SINE
	).set_ease(Tween.EASE_IN_OUT)


# ----------------------------------
# ENEMIGOS CAMINANDO
# ----------------------------------

func _start_walkers() -> void:

	# Configuración por walker: destino en X y duración del recorrido.
	var configs: Array = [
		{"end_x": 740.0, "duration": 18.0},
		{"end_x": -740.0, "duration": 23.0},
		{"end_x": 740.0, "duration": 26.0},
		{"end_x": -740.0, "duration": 21.0},
	]

	var index: int = 0

	for child in walkers.get_children():

		var walker: Sprite2D = child

		# Reutilizar la lista si hay más enemigos que configuraciones.
		var config: Dictionary = configs[index % configs.size()]

		var start_x: float = walker.position.x
		var end_x: float = config["end_x"]
		var duration: float = config["duration"]

		# Caminar de un borde de la pantalla al otro, en bucle.
		var walk: Tween = create_tween().set_loops()
		walk.tween_property(walker, "position:x", end_x, duration).from(
			start_x
		).set_trans(Tween.TRANS_LINEAR)

		# Pequeño balanceo vertical al caminar.
		var base_y: float = walker.position.y
		var bob: Tween = create_tween().set_loops()
		bob.tween_property(walker, "position:y", base_y + 5.0, 0.55).set_trans(
			Tween.TRANS_SINE
		).set_ease(Tween.EASE_IN_OUT)
		bob.tween_property(walker, "position:y", base_y - 5.0, 0.55).set_trans(
			Tween.TRANS_SINE
		).set_ease(Tween.EASE_IN_OUT)

		index += 1


# ----------------------------------
# HOVER DE LOS BOTONES
# ----------------------------------

func _start_button_hover() -> void:

	# Esperar un frame para conocer el tamaño real de los botones.
	await get_tree().process_frame

	for node in [play_button, options_button, quit_button]:

		var button: Button = node
		button.pivot_offset = button.size * 0.5

		button.mouse_entered.connect(_on_button_hover.bind(button, true))
		button.mouse_exited.connect(_on_button_hover.bind(button, false))
		button.focus_entered.connect(_on_button_hover.bind(button, true))
		button.focus_exited.connect(_on_button_hover.bind(button, false))


func _on_button_hover(button: Button, hovered: bool) -> void:

	var tween: Tween = create_tween().set_parallel(true)

	var target_scale: Vector2 = (
		Vector2(1.08, 1.08) if hovered else Vector2.ONE
	)

	var target_color: Color = (
		Color(1.18, 1.18, 1.18, 1.0) if hovered else Color(1, 1, 1, 1)
	)

	tween.tween_property(button, "scale", target_scale, 0.12)
	tween.tween_property(button, "modulate", target_color, 0.12)


# ----------------------------------
# NAVEGACIÓN (misma lógica de antes)
# ----------------------------------

func on_play() -> void:

	get_tree().change_scene_to_file(INTRO_SCENE)


func on_options() -> void:

	options_menu.open()


func on_quit() -> void:

	get_tree().quit()
