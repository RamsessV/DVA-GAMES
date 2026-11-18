extends Control

# ----------------------------------
# MENÚ DE OPCIONES
# ----------------------------------
# Panel reutilizable para ajustar volumen y pantalla.
# Se instancia tanto en el menú principal como en la
# pausa. Emite "closed" al pulsar VOLVER.

# Avisa que el menú se cerró.
signal closed


@onready var volume_slider: HSlider = (
	$CenterContainer/PanelContainer/VBoxContainer/VolumeSlider
)

@onready var volume_value: Label = (
	$CenterContainer/PanelContainer/VBoxContainer/VolumeValue
)

@onready var fullscreen_check: CheckBox = (
	$CenterContainer/PanelContainer/VBoxContainer/FullscreenCheck
)

@onready var back_button: Button = (
	$CenterContainer/PanelContainer/VBoxContainer/BackButton
)


func _ready() -> void:

	# Cargar y aplicar la configuración guardada.
	Settings.load_settings()

	volume_slider.value = Settings.master_volume
	fullscreen_check.button_pressed = Settings.fullscreen

	update_volume_label(Settings.master_volume)

	volume_slider.value_changed.connect(on_volume_changed)
	fullscreen_check.toggled.connect(on_fullscreen_toggled)
	back_button.pressed.connect(on_back)

	# Empezar oculto.
	hide()


# ----------------------------------
# ABRIR / CERRAR
# ----------------------------------

func open() -> void:

	volume_slider.value = Settings.master_volume
	fullscreen_check.button_pressed = Settings.fullscreen

	update_volume_label(Settings.master_volume)

	show()

	back_button.grab_focus()


func on_back() -> void:

	Settings.save_settings()

	hide()

	closed.emit()


# ----------------------------------
# CAMBIO DE VALORES
# ----------------------------------

func on_volume_changed(value: float) -> void:

	Settings.set_master_volume(value)

	update_volume_label(value)


func on_fullscreen_toggled(enabled: bool) -> void:

	Settings.set_fullscreen(enabled)


func update_volume_label(value: float) -> void:

	volume_value.text = "%d %%" % roundi(value * 100.0)