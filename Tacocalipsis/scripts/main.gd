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
# POPUP DE RECOMPENSA DEL JEFE
# ----------------------------------

@onready var boss_reward_screen: Control = $HUD/BossRewardScreen

@onready var health_up_button: Button = $HUD/BossRewardScreen/CenterContainer/PanelContainer/VBoxContainer/HealthUpButton

@onready var cart_up_button: Button = $HUD/BossRewardScreen/CenterContainer/PanelContainer/VBoxContainer/CartUpButton


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


# ----------------------------------
# BARRA DE VIDA DEL JEFE
# ----------------------------------

@onready var boss_health_ui: VBoxContainer = $HUD/BossHealthUI
@onready var boss_label: Label = $HUD/BossHealthUI/BossLabel
@onready var boss_health_bar: ProgressBar = $HUD/BossHealthUI/BossHealthBar


# ----------------------------------
# MENSAJES DE OLEADA / JEFE
# ----------------------------------

@onready var wave_announcement: Label = $HUD/WaveAnnouncement


# ----------------------------------
# PANTALLA DE VICTORIA
# ----------------------------------

@onready var victory_screen: Control = $HUD/VictoryScreen

@onready var victory_retry_button: Button = $HUD/VictoryScreen/CenterContainer/PanelContainer/VBoxContainer/RetryButton

@onready var victory_menu_button: Button = $HUD/VictoryScreen/CenterContainer/PanelContainer/VBoxContainer/MenuButton


# ----------------------------------
# MENÚ DE PAUSA
# ----------------------------------

@onready var pause_menu: Control = $HUD/PauseMenu

@onready var pause_resume_button: Button = $HUD/PauseMenu/CenterContainer/PanelContainer/VBoxContainer/ResumeButton

@onready var pause_options_button: Button = $HUD/PauseMenu/CenterContainer/PanelContainer/VBoxContainer/OptionsButton

@onready var pause_menu_button: Button = $HUD/PauseMenu/CenterContainer/PanelContainer/VBoxContainer/MenuButton

@onready var pause_options_menu: Control = $HUD/PauseMenu/OptionsMenu


# Escena del menú principal.
const MAIN_MENU_SCENE: String = "res://scenes/main_menu.tscn"

# Nombre del jefe actual (para la barra del HUD).
var boss_display_name: String = "Jefe"

# Tween del mensaje central (evita solapamientos).
var _announce_tween: Tween = null


func _ready() -> void:

	# Aplicar el cursor personalizado.
	Settings.apply_cursor()

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
	wave_manager.all_waves_completed.connect(on_all_waves_completed)

	# Mostrar el estado inicial de la oleada.
	# (El WaveManager ya inició la primera oleada en su _ready).
	refresh_wave_label()

	wave_announcement.hide()

	# ----------------------------------
	# CONECTAR POPUP DE RECOMPENSA DEL JEFE
	# ----------------------------------

	health_up_button.pressed.connect(
		func(): select_boss_reward("player")
	)

	cart_up_button.pressed.connect(
		func(): select_boss_reward("cart")
	)

	# Mantener oculto el popup al iniciar.
	boss_reward_screen.hide()

	# Mantener oculta la barra de vida del jefe al iniciar.
	boss_health_ui.hide()

	# ----------------------------------
	# CONECTAR PANTALLA DE VICTORIA
	# ----------------------------------

	victory_retry_button.pressed.connect(restart_game)
	victory_menu_button.pressed.connect(go_to_main_menu)

	victory_screen.hide()

	# ----------------------------------
	# CONECTAR MENÚ DE PAUSA
	# ----------------------------------

	pause_resume_button.pressed.connect(toggle_pause)
	pause_options_button.pressed.connect(on_pause_options)
	pause_menu_button.pressed.connect(go_to_main_menu)

	pause_menu.hide()



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


func go_to_main_menu() -> void:

	# Quitar la pausa y volver al menú principal.
	get_tree().paused = false

	get_tree().change_scene_to_file(MAIN_MENU_SCENE)



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
# MENÚ DE PAUSA
# ----------------------------------

func _unhandled_input(event: InputEvent) -> void:

	if not event.is_action_pressed("pause"):
		return

	# Si las opciones están abiertas, cerrarlas primero.
	if pause_options_menu.visible:
		pause_options_menu.on_back()
		return

	toggle_pause()


func toggle_pause() -> void:

	# No permitir pausar sobre pantallas de fin o menús modales.
	if victory_screen.visible or game_over_screen.visible:
		return

	if level_up_screen.visible or boss_reward_screen.visible:
		return

	# Alternar la pausa.
	if pause_menu.visible:

		pause_menu.hide()
		get_tree().paused = false

	else:

		pause_menu.show()
		get_tree().paused = true
		pause_resume_button.grab_focus()


func on_pause_options() -> void:

	pause_options_menu.open()


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

func refresh_wave_label() -> void:

	var number: int = wave_manager.get_current_wave_number()
	var wave_name: String = wave_manager.get_current_wave_name()

	if wave_name == "":
		wave_label.text = "PREPARANDO..."
		return

	wave_label.text = "OLEADA %d — %s" % [number, wave_name]


func on_wave_started(wave_index: int, wave_name: String) -> void:

	wave_label.text = "OLEADA %d — %s" % [wave_index + 1, wave_name]

	announce(
		"¡OLEADA %d: %s!" % [wave_index + 1, wave_name.to_upper()]
	)


func on_boss_spawned() -> void:

	# Nombre del jefe de esta oleada.
	if wave_manager.current_wave != null:
		boss_display_name = wave_manager.current_wave.boss_display_name

	wave_label.text = "¡JEFE: %s!" % boss_display_name

	announce("¡JEFE: %s!" % boss_display_name.to_upper())

	# Recuperar al jefe que acaba de crear el gestor de oleadas.
	var boss: TacoEnemy = wave_manager.boss as TacoEnemy

	if boss == null:
		return

	# Conectar la vida del jefe a la barra del HUD.
	boss.health_changed.connect(update_boss_health)

	# Inicializar y mostrar la barra con su vida actual.
	update_boss_health(boss.current_health, boss.max_health)

	boss_health_ui.show()


# ----------------------------------
# BARRA DE VIDA DEL JEFE
# ----------------------------------

func update_boss_health(current: float, maximum: float) -> void:

	boss_health_bar.max_value = maximum
	boss_health_bar.value = current

	boss_label.text = "%s — %d / %d HP" % [
		boss_display_name,
		ceili(current),
		ceili(maximum)
	]


func on_boss_defeated() -> void:

	wave_label.text = "JEFE DERROTADO..."

	# Ocultar la barra de vida del jefe.
	boss_health_ui.hide()

	# Regenerar por completo el carrito.
	cart.restore_full_health()

	# Ofrecer la recompensa de mejora al jugador.
	show_boss_reward()


func on_wave_cleared() -> void:

	wave_label.text = "¡OLEADA COMPLETADA!"


func on_all_waves_completed() -> void:

	show_victory()


# ----------------------------------
# PANTALLA DE VICTORIA
# ----------------------------------

func show_victory() -> void:

	# Evitar abrir la victoria varias veces.
	if victory_screen.visible:
		return

	print("¡VICTORIA! Todas las oleadas superadas.")

	victory_screen.show()

	get_tree().paused = true

	victory_retry_button.grab_focus()


# ----------------------------------
# MENSAJES CENTRALES
# ----------------------------------

func announce(message: String) -> void:

	wave_announcement.text = message
	wave_announcement.modulate.a = 1.0
	wave_announcement.show()

	# Cancelar el mensaje anterior si aún está animándose.
	if _announce_tween != null and _announce_tween.is_valid():
		_announce_tween.kill()

	_announce_tween = create_tween()

	_announce_tween.tween_interval(1.6)
	_announce_tween.tween_property(
		wave_announcement, "modulate:a", 0.0, 0.6
	)
	_announce_tween.tween_callback(wave_announcement.hide)


# ----------------------------------
# RECOMPENSA DEL JEFE
# ----------------------------------

func show_boss_reward() -> void:

	# No mostrar la recompensa si la partida terminó.
	if game_over_screen.visible:
		return

	# Evitar abrir el popup dos veces.
	if boss_reward_screen.visible:
		return

	print("¡Recompensa del jefe disponible!")

	# Mostrar el popup.
	boss_reward_screen.show()

	# Pausar la lógica del juego (igual que el menú de nivel).
	get_tree().paused = true

	# Dar foco al primer botón.
	health_up_button.grab_focus()


func select_boss_reward(reward_type: String) -> void:

	# Solo aceptar recompensas cuando el popup está abierto.
	if not boss_reward_screen.visible:
		return

	# Aplicar la recompensa seleccionada.
	match reward_type:

		"player":
			# +20% a la vida máxima del Taquero y cura esa cantidad.
			player.increase_max_health(0.20)
			print("Recompensa del jefe: +20% HP Taquero")

		"cart":
			# +20% a la vida máxima del carrito y cura esa cantidad.
			cart.increase_max_health(0.20)
			print("Recompensa del jefe: +20% HP Carrito")

		_:
			# Ignorar una opción no reconocida.
			return

	# Ocultar el popup.
	boss_reward_screen.hide()

	# Reanudar el flujo del juego.
	get_tree().paused = false

	# Avanzar a la siguiente oleada (o terminar la partida).
	wave_manager.start_next_wave()
