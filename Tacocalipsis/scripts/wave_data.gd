class_name WaveData
extends Resource

# ----------------------------------
# CONFIGURACIÓN DE UNA OLEADA
# ----------------------------------
# Cada instancia de este recurso describe una oleada
# completa (enemigos, jefe, duración y recompensas).
# El WaveManager recorre una lista de WaveData para
# soportar varias oleadas encadenadas.

# Nombre visible de la oleada (p. ej. "Tacos").
@export var wave_name: String = "Oleada"

# Escena del enemigo común de la oleada.
@export var enemy_scene: PackedScene

# Escena del jefe de la oleada.
@export var boss_scene: PackedScene

# Nombre del jefe para los mensajes del HUD.
@export var boss_display_name: String = "Jefe"

# Duración de la oleada antes de invocar al jefe.
@export var wave_duration: float = 60.0

# Tiempo entre apariciones de enemigos comunes.
@export var spawn_interval: float = 2.0

# Máximo de enemigos comunes vivos a la vez.
@export var max_enemies: int = 8

# Cantidad de XP que entrega cada enemigo común.
@export var xp_per_enemy: int = 10

# Probabilidad de soltar munición al morir un enemigo.
@export_range(0.0, 1.0) var ammo_drop_chance: float = 0.20

# Balas que contiene cada paquete de munición.
@export var ammo_per_drop: int = 6

# Posición donde aparecerá el jefe.
@export var boss_spawn_position: Vector2 = Vector2(640, 120)
