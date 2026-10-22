
extends Node2D

# ----------------------------------
# REFERENCIAS A LAS ENTIDADES
# ----------------------------------

@onready var player = $World/Player
@onready var cart = $World/Cart

# Referencia al gestor de oleadas.
@onready var wave_manager = $WaveManager

# ----------------------------------
# REFERENCIAS AL HUD
# ----------------------------------

@onready var player_health_label: Label = $HUD/HUDMargin/HealthBars/PlayerHealthLabel
@onready var player_health_bar: ProgressBar = $HUD/HUDMargin/HealthBars/PlayerHealthBar

@onready var cart_health_label: Label = $HUD/HUDMargin/HealthBars/CartHealthLabel
@onready var cart_health_bar: ProgressBar = $HUD/HUDMargin/HealthBars/CartHealthBar


# Pantalla de derrota.
@onready var game_over_screen: Control = $HUD/GameOverScreen


# ----------------------------------
# MENÚ DE MEJORAS
# ----------------------------------

@onready var level_up_screen: Control = $HUD/LevelUpScreen

@onready var heal_button: Button = $HUD/LevelUpScreen/CenterContainer/PanelContainer/VBoxContainer/HealButton

@onready var speed_button: Button = $HUD/LevelUpScreen/CenterContainer/PanelContainer/VBoxContainer/SpeedButton

@onready var weapon_button: Button = $HUD/LevelUpScreen/CenterContainer/PanelContainer/VBoxContainer/WeaponButton


# ----------------------------------
# HUD DE EXPERIENCIA
# ----------------------------------

@onready var xp_label: Label = $HUD/HUDMargin/HealthBars/XPLabel
@onready var xp_bar: ProgressBar = $HUD/HUDMargin/HealthBars/XPBar

# ----------------------------------
# HUD DE ARMAS
# ----------------------------------

@onready var gun_label: Label = $HUD/WeaponHUD/WeaponInfo/GunLabel
@onready var ammo_label: Label = $HUD/WeaponHUD/WeaponInfo/AmmoLabel
@onready var knife_label: Label = $HUD/WeaponHUD/WeaponInfo/KnifeLabel

# Etiqueta que muestra el estado de la oleada.
@onready var wave_label: Label = $HUD/WaveLabel


func _ready() -> void:

	# Conectar los cambios de salud.
	player.health_changed.connect(update_player_health)
	cart.health_changed.connect(update_cart_health)

	# Conectar las señales de derrota.
	player.player_died.connect(on_player_died)
	cart.cart_destroyed.connect(on_cart_destroyed)

	# Mostrar los valores iniciales.
	update_player_health(
		player.current_health,
		player.max_health
	)

	update_cart_health(
		cart.current_health,
		cart.max_health
	)
	
	
	# ----------------------------------
	# CONECTAR SISTEMA DE NIVEL
	# ----------------------------------

	# Escuchar cuando el Taquero reúne suficiente XP.
	player.level_up_ready.connect(show_level_up)

	# Conectar los tres botones por código.
	heal_button.pressed.connect(
		func(): select_upgrade("heal")
	)

	speed_button.pressed.connect(
		func(): select_upgrade("speed")
	)

	weapon_button.pressed.connect(
		func(): select_upgrade("weapon")
	)

	# Mantener oculto el menú al iniciar.
	level_up_screen.hide()

	
	# Escuchar cambios de experiencia.
	player.xp_changed.connect(update_xp_hud)

	# Escuchar cambios de arma y munición.
	player.weapon_changed.connect(update_weapon_hud)

	# Mostrar valores iniciales.
	update_xp_hud(
		player.current_xp,
		player.xp_to_next_level
	)

	update_weapon_hud()

	# ----------------------------------
	# CONECTAR EVENTOS DE LA OLEADA
	# ----------------------------------

	wave_manager.wave_started.connect(on_wave_started)
	wave_manager.boss_spawned.connect(on_boss_spawned)
	wave_manager.boss_defeated.connect(on_boss_defeated)
	wave_manager.wave_cleared.connect(on_wave_cleared)

	# Mostrar el estado inicial de la oleada.
	wave_label.text = "OLEADA 1"



# ----------------------------------
# ACTUALIZAR BARRA DEL TAQUERO
# ----------------------------------

func update_player_health(
	current: float,
	maximum: float
) -> void:

	player_health_bar.max_value = maximum
	player_health_bar.value = current

	player_health_label.text = "Taquero: %d / %d HP" % [
		ceili(current),
		ceili(maximum)
	]


# ----------------------------------
# ACTUALIZAR BARRA DEL CARRITO
# ----------------------------------

func update_cart_health(
	current: float,
	maximum: float
) -> void:

	cart_health_bar.max_value = maximum
	cart_health_bar.value = current

	cart_health_label.text = "Carrito: %d / %d HP" % [
		ceili(current),
		ceili(maximum)
	]


# ----------------------------------
# DETECTAR GAME OVER
# ----------------------------------

func on_player_died() -> void:
	print("GAME OVER: El Taquero murió.")
	show_game_over()


func on_cart_destroyed() -> void:
	print("GAME OVER: El carrito fue destruido.")
	show_game_over()



func show_game_over() -> void:

	# Evitar abrir Game Over varias veces.
	if game_over_screen.visible:
		return

	# Mostrar pantalla de derrota.
	game_over_screen.show()

	# Detener el juego.
	get_tree().paused = true



func restart_game() -> void:

	# Quitar la pausa antes de reiniciar.
	get_tree().paused = false

	# Volver a cargar el nivel desde cero.
	get_tree().reload_current_scene()


func _on_retry_button_pressed() -> void:
	restart_game()



# ----------------------------------
# PRUEBAS TEMPORALES DE SALUD
# ----------------------------------

func _unhandled_key_input(event: InputEvent) -> void:

	if not event is InputEventKey:
		return

	if not event.pressed or event.echo:
		return

	# Tecla 1: Daño al Taquero.
	if event.keycode == KEY_1:
		player.take_damage(20.0)

	# Tecla 2: Daño al Carrito.
	if event.keycode == KEY_2:
		cart.take_damage(30.0)

	# Tecla 3: Curación de ambos.
	if event.keycode == KEY_3:
		player.heal(20.0)
		cart.heal(30.0)



# ----------------------------------
# MOSTRAR MENÚ DE SUBIDA DE NIVEL
# ----------------------------------

func show_level_up() -> void:

	# No abrir el menú si terminó la partida.
	if game_over_screen.visible:
		return

	# Evitar abrirlo sin mejora pendiente.
	if not player.level_up_pending:
		return

	# No mostrarlo dos veces.
	if level_up_screen.visible:
		return

	print("¡Mostrando menú de mejoras!")

	# Mostrar interfaz.
	level_up_screen.show()

	# Pausar la acción.
	get_tree().paused = true

	# Dar foco al primer botón.
	heal_button.grab_focus()


# ----------------------------------
# SELECCIONAR UNA MEJORA
# ----------------------------------

func select_upgrade(upgrade_type: String) -> void:

	# Solo aceptar mejoras cuando el menú está abierto.
	if not level_up_screen.visible:
		return

	if not player.level_up_pending:
		return

	# Aplicar la mejora seleccionada.
	match upgrade_type:

		"heal":
			# Recuperar 30% de la vida máxima.
			player.heal(player.max_health * 0.30)
			print("Mejora elegida: Curación")

		"speed":
			# Aumentar velocidad 10%.
			player.upgrade_speed()
			print("Mejora elegida: Velocidad")

		"weapon":
			# Desbloquear o mejorar pistola.
			player.upgrade_gun()
			print("Mejora elegida: Arma")

		_:
			# Ignorar una opción no reconocida.
			return

	# Consumir la XP necesaria y aumentar nivel.
	player.complete_level_up()

	# Cerrar menú actual.
	level_up_screen.hide()

	# Comprobar si hay XP para otra mejora.
	if player.level_up_pending:

		# Mantener el juego pausado.
		# Abrir el menú nuevamente.
		show_level_up()

	else:

		# No quedan mejoras pendientes.
		# Reanudar la partida.
		get_tree().paused = false
		

# ----------------------------------
# BARRA DE EXPERIENCIA
# ----------------------------------

func update_xp_hud(current: int, required: int) -> void:

	xp_bar.max_value = required
	xp_bar.value = current

	xp_label.text = "Nivel %d - XP: %d / %d" % [
		player.player_level,
		current,
		required
	]


# ----------------------------------
# ARMAS Y MUNICIÓN
# ----------------------------------

func update_weapon_hud() -> void:

	knife_label.text = "CUCHILLO: INFINITO"

	# Pistola todavía bloqueada.
	if not player.has_gun:

		gun_label.text = "PISTOLA: BLOQUEADA"
		ammo_label.text = "MUNICION: 0 / 0"
		return

	# Pistola desbloqueada.
	gun_label.text = "PISTOLA - NIVEL %d" % player.gun_level

	ammo_label.text = "MUNICION: %d / %d" % [
		player.current_ammo,
		player.reserve_ammo
	]


# ----------------------------------
# ESTADO DE LA OLEADA
# ----------------------------------

func on_wave_started() -> void:
	wave_label.text = "OLEADA 1"


func on_boss_spawned() -> void:
	wave_label.text = "¡JEFE: TACO SUPREMO!"


func on_boss_defeated() -> void:
	wave_label.text = "JEFE DERROTADO..."


func on_wave_cleared() -> void:
	wave_label.text = "¡OLEADA 1 COMPLETADA!"
