class_name Settings
extends RefCounted

# ----------------------------------
# CONFIGURACIÓN GLOBAL DEL JUEGO
# ----------------------------------
# Utilidad estática (no requiere autoload) para
# guardar y aplicar opciones de volumen y pantalla.
# La configuración se conserva en user://settings.cfg.

const CONFIG_PATH: String = "user://settings.cfg"

# Volumen del bus Master (0.0 - 1.0).
static var master_volume: float = 1.0

# Pantalla completa activa.
static var fullscreen: bool = false


# ----------------------------------
# CARGAR / GUARDAR
# ----------------------------------

static func load_settings() -> void:

	var config := ConfigFile.new()

	if config.load(CONFIG_PATH) == OK:

		master_volume = config.get_value(
			"audio", "master_volume", 1.0
		)

		fullscreen = config.get_value(
			"video", "fullscreen", false
		)

	apply_settings()


static func save_settings() -> void:

	var config := ConfigFile.new()

	config.set_value("audio", "master_volume", master_volume)
	config.set_value("video", "fullscreen", fullscreen)

	config.save(CONFIG_PATH)


# ----------------------------------
# APLICAR CAMBIOS
# ----------------------------------

static func set_master_volume(value: float) -> void:

	master_volume = clampf(value, 0.0, 1.0)

	apply_audio()


static func set_fullscreen(enabled: bool) -> void:

	fullscreen = enabled

	apply_video()


static func apply_settings() -> void:

	apply_audio()
	apply_video()


static func apply_audio() -> void:

	var bus_index: int = AudioServer.get_bus_index("Master")

	if bus_index >= 0:

		# linear_to_db permite silenciar en 0.0.
		AudioServer.set_bus_volume_db(
			bus_index,
			linear_to_db(master_volume)
		)


static func apply_video() -> void:

	var mode: int = DisplayServer.WINDOW_MODE_WINDOWED

	if fullscreen:
		mode = DisplayServer.WINDOW_MODE_FULLSCREEN

	DisplayServer.window_set_mode(mode)


# ----------------------------------
# CURSOR PERSONALIZADO
# ----------------------------------

const CURSOR_PATH: String = "res://assets/cursor/cursor.png"

static func apply_cursor(size: int = 32) -> void:

	var texture: Texture2D = load(CURSOR_PATH) as Texture2D

	if texture == null:
		return

	# La imagen original es muy grande: reducirla al tamaño de cursor.
	var image: Image = texture.get_image()

	if image == null:
		return

	image.resize(size, size, Image.INTERPOLATE_LANCZOS)

	var cursor_texture: ImageTexture = ImageTexture.create_from_image(image)

	# Punto activo en el centro de la mira.
	Input.set_custom_mouse_cursor(
		cursor_texture,
		Input.CURSOR_ARROW,
		Vector2(size / 2.0, size / 2.0)
	)