# AudioManager - Autoload para sonido y música.
# Un reproductor de música con fundidos y un pool de reproductores para SFX.
# Los botones de todas las escenas suenan solos (clic y hover).
extends Node

const SFX_PATH: String = "res://assets/audio/sfx/"
const MUSIC_PATH: String = "res://assets/audio/musica/"
const EXTENSIONS: Array = [".mp3", ".ogg", ".wav"]
const SFX_POOL_SIZE: int = 12

signal music_changed(current: float, maximum: float)

var music_player: AudioStreamPlayer
var sfx_pool: Array[AudioStreamPlayer] = []

var _loop_players: Dictionary = {}
var _cache: Dictionary = {}
var _current_music: String = ""
var _music_tween: Tween = null


func _ready() -> void:
	# Debe seguir funcionando con el juego en pausa.
	process_mode = Node.PROCESS_MODE_ALWAYS

	_ensure_bus("Musica", -6.0)
	_ensure_bus("SFX", 0.0)

	music_player = AudioStreamPlayer.new()
	music_player.name = "MusicPlayer"
	music_player.bus = "Musica"
	add_child(music_player)

	for i in range(SFX_POOL_SIZE):
		var player: AudioStreamPlayer = AudioStreamPlayer.new()
		player.name = "SFX_" + str(i)
		player.bus = "SFX"
		add_child(player)
		sfx_pool.append(player)

	# Sonido automático para todos los botones del juego.
	get_tree().node_added.connect(_on_node_added)


# ---------- Buses ----------

func _ensure_bus(bus_name: String, default_db: float) -> void:
	if AudioServer.get_bus_index(bus_name) != -1:
		return

	AudioServer.add_bus()
	var idx: int = AudioServer.bus_count - 1
	AudioServer.set_bus_name(idx, bus_name)
	AudioServer.set_bus_send(idx, "Master")
	AudioServer.set_bus_volume_db(idx, default_db)


func set_music_volume_db(volume_db: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Musica"), volume_db)


func set_sfx_volume_db(volume_db: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), volume_db)


# ---------- Carga ----------

func _get_stream(folder: String, track: String, loop: bool) -> AudioStream:
	var key: String = folder + track + str(loop)

	if _cache.has(key):
		return _cache[key]

	for ext in EXTENSIONS:
		var path: String = folder + track + ext
		if ResourceLoader.exists(path):
			var stream: AudioStream = load(path)
			if stream != null:
				stream = stream.duplicate()
				_set_loop(stream, loop)
				_cache[key] = stream
				return stream

	push_warning("Audio no encontrado: " + folder + track)
	_cache[key] = null
	return null


func _set_loop(stream: AudioStream, loop: bool) -> void:
	if stream is AudioStreamMP3:
		stream.loop = loop
	elif stream is AudioStreamOggVorbis:
		stream.loop = loop
	elif stream is AudioStreamWAV:
		if loop:
			stream.loop_mode = AudioStreamWAV.LOOP_FORWARD
		else:
			stream.loop_mode = AudioStreamWAV.LOOP_DISABLED


# ---------- Música ----------

func play_musica(track: String, fade_time: float = 0.6) -> void:
	# Si ya suena esa pista, no reiniciarla.
	if track == _current_music and music_player.playing:
		return

	var stream: AudioStream = _get_stream(MUSIC_PATH, track, true)
	if stream == null:
		return

	_current_music = track

	if _music_tween != null and _music_tween.is_valid():
		_music_tween.kill()

	_music_tween = create_tween()

	# Si ya hay música, bajarla primero.
	if music_player.playing:
		_music_tween.tween_property(music_player, "volume_db", -80.0, fade_time * 0.5)

	_music_tween.tween_callback(_start_stream.bind(stream))
	_music_tween.tween_property(music_player, "volume_db", 0.0, fade_time)

	music_changed.emit(1.0, 1.0)


func _start_stream(stream: AudioStream) -> void:
	music_player.stream = stream
	music_player.volume_db = -80.0
	music_player.play()


func stop_musica(fade_out_time: float = 0.3) -> void:
	_current_music = ""

	if not music_player.playing:
		return

	if _music_tween != null and _music_tween.is_valid():
		_music_tween.kill()

	_music_tween = create_tween()
	_music_tween.tween_property(music_player, "volume_db", -80.0, fade_out_time)
	_music_tween.tween_callback(music_player.stop)

	music_changed.emit(0.0, 1.0)


func pause_musica(pause: bool = true) -> void:
	music_player.stream_paused = pause


# ---------- Efectos ----------

func play_sfx(sfx_name: String, loop: bool = false, pitch_offset: float = 0.0) -> void:
	# Un sonido en bucle no se vuelve a iniciar si ya está sonando.
	if loop and _loop_players.has(sfx_name):
		if _loop_players[sfx_name].playing:
			return

	var stream: AudioStream = _get_stream(SFX_PATH, sfx_name, loop)
	if stream == null:
		return

	var player: AudioStreamPlayer = _get_free_player()
	player.stream = stream
	player.pitch_scale = maxf(0.1, 1.0 + pitch_offset)
	player.play()

	if loop:
		_loop_players[sfx_name] = player


# Igual que play_sfx, con variación de tono para evitar repetición.
func play_sfx_random(sfx_name: String) -> void:
	play_sfx(sfx_name, false, randf_range(-0.1, 0.1))


func stop_sfx(sfx_name: String) -> void:
	if _loop_players.has(sfx_name):
		_loop_players[sfx_name].stop()
		_loop_players.erase(sfx_name)


func _get_free_player() -> AudioStreamPlayer:
	for p in sfx_pool:
		if not p.playing:
			return p

	# Si todos están ocupados, robar uno que no sea un bucle.
	for p in sfx_pool:
		if not _loop_players.values().has(p):
			p.stop()
			return p

	return sfx_pool[0]


# ---------- Botones ----------

func _on_node_added(node: Node) -> void:
	if node is BaseButton:
		node.pressed.connect(_on_button_pressed)
		node.mouse_entered.connect(_on_button_hover)


func _on_button_pressed() -> void:
	play_sfx("boton_clic")


func _on_button_hover() -> void:
	play_sfx("boton_hover")
