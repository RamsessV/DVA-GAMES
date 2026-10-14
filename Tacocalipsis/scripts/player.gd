
extends CharacterBody2D


# Avisar cuando cambia la salud del Taquero.
signal health_changed(current: float, maximum: float)

# Avisar cuando el Taquero se queda sin vida.
signal player_died


# Se emite al obtener experiencia.
signal xp_changed(current: int, required: int)

# Avisará cuando se alcance la XP necesaria
# para abrir el menú de mejoras.
signal level_up_ready

signal weapon_changed

# -----------------------------
# CONFIGURACIÓN DEL TAQUERO
# -----------------------------

@export var move_speed: float = 220.0

# Velocidad cuando transporta el carrito.
@export var push_speed: float = 140.0

# Distancia máxima para poder agarrarlo.
@export var interact_distance: float = 90.0

# Salud del Taquero.
@export var max_health: float = 100.0

var current_health: float = 100.0


# ----------------------------------
# EXPERIENCIA Y NIVEL
# ----------------------------------

# Nivel inicial.
var player_level: int = 1

# Experiencia acumulada para el siguiente nivel.
var current_xp: int = 0

# Experiencia requerida para subir de nivel.
var xp_to_next_level: int = 50

# Evita activar varias veces la subida de nivel.
var level_up_pending: bool = false


# -----------------------------
# CONFIGURACIÓN DEL CUCHILLO
# -----------------------------

# Daño causado por cada ataque.
@export var melee_damage: float = 25.0

# Referencia al área del cuchillo.
@onready var melee_hitbox: Area2D = $MeleeHitbox

# Temporizador entre ataques.
@onready var melee_cooldown: Timer = $MeleeCooldown



# ----------------------------------
# CONFIGURACIÓN DE LA PISTOLA
# ----------------------------------

# El Taquero empieza sin pistola.
var has_gun: bool = false

# Daño que causa cada bala.
@export var gun_damage: float = 20.0

# Balas máximas del cargador.
@export var magazine_size: int = 12

# Balas actuales del cargador.
var current_ammo: int = 0

# Balas guardadas en reserva.
var reserve_ammo: int = 0

# Nivel de mejora de la pistola.
var gun_level: int = 0

# Escena que utilizaremos para las balas.
const BULLET_SCENE: PackedScene = preload(
    "res://scenes/bullet.tscn"
)

# Temporizador de disparos.
@onready var shoot_cooldown: Timer = $ShootCooldown


# -----------------------------
# REFERENCIA AL CARRITO
# -----------------------------

var cart: CharacterBody2D = null

# ¿Está agarrando el carrito?
var is_pushing_cart: bool = false


# -----------------------------
# INICIALIZACIÓN
# -----------------------------

func _ready() -> void:

	current_health = max_health

	add_to_group("player")

	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING

	# Buscar el carrito usando su grupo.
	cart = get_tree().get_first_node_in_group("cart") as CharacterBody2D


# -----------------------------
# MOVIMIENTO
# -----------------------------

func _physics_process(delta: float) -> void:

	# Comprobar interacción.
	if Input.is_action_just_pressed("interact"):
		toggle_cart()
	
	
	# Orientar el cuchillo hacia el cursor.
	var mouse_direction: Vector2 = (
		get_global_mouse_position() - global_position
	)

	if mouse_direction.length_squared() > 0.001:
		melee_hitbox.rotation = mouse_direction.angle()

	# Detectar el ataque con Espacio.
	if Input.is_action_just_pressed("melee_attack"):
		melee_attack()

	
	# Disparar con clic izquierdo.
	if Input.is_action_pressed("shoot"):
		shoot()


	# Leer WASD.
	var direction := Input.get_vector(
		"move_left",
		"move_right",
		"move_up",
        "move_down"
	)

	# Elegir velocidad.
	var current_speed: float = move_speed

	if is_pushing_cart:
		current_speed = push_speed

	velocity = direction * current_speed

	# Movimiento normal.
	if not is_pushing_cart:
		move_and_slide()
		return

	# Movimiento transportando carrito.
	move_with_cart(delta)


# -----------------------------
# AGARRAR / SOLTAR
# -----------------------------


func toggle_cart() -> void:

	# Buscar el carrito cada vez que presionamos E.
	if not is_instance_valid(cart):
		cart = get_tree().get_first_node_in_group("cart") as CharacterBody2D

	# Comprobar que realmente encontramos el carrito.
	if cart == null:
		print("ERROR: No se encontró el carrito.")
		return

	# Si ya lo estamos empujando, soltarlo.
	if is_pushing_cart:
		release_cart()
		return

	# Calcular la distancia entre Taquero y carrito.
	var distance := global_position.distance_to(
		cart.global_position
	)

	print("Distancia al carrito: ", distance)

	# Comprobar si estamos suficientemente cerca.
	if distance > interact_distance:
		print("Estás demasiado lejos del carrito.")
		return

	# Agarrar el carrito.
	is_pushing_cart = true
	cart.set("is_attached", true)

	add_collision_exception_with(cart)
	cart.add_collision_exception_with(self)

	print("¡Carrito agarrado correctamente!")



func release_cart() -> void:

	is_pushing_cart = false
	cart.set("is_attached", false)

	# Restaurar las colisiones entre ambos.
	remove_collision_exception_with(cart)
	cart.remove_collision_exception_with(self)

	print("Carrito soltado. Puedes volver a atacar.")


# -----------------------------
# MOVER TAQUERO Y CARRITO
# -----------------------------

func move_with_cart(delta: float) -> void:

	if cart == null:
		is_pushing_cart = false
		return

	if velocity == Vector2.ZERO:
		return

	# Movimiento solicitado para este frame.
	var requested_motion: Vector2 = velocity * delta

	# Antes de mover al jugador comprobamos
	# si el carrito chocaría con un obstáculo.
	if cart.test_move(
		cart.global_transform,
		requested_motion
	):
		velocity = Vector2.ZERO
		return

	# Guardar posición previa del Taquero.
	var previous_position: Vector2 = global_position

	# Mover Taquero respetando obstáculos.
	move_and_slide()

	# Obtener el desplazamiento real del Taquero.
	var actual_motion: Vector2 = global_position - previous_position

	# Aplicar ese mismo desplazamiento al carrito.
	# move_and_collide respeta las colisiones físicas.
	cart.move_and_collide(actual_motion)


# -----------------------------
# PERMISO DE ATAQUE
# -----------------------------

func can_attack() -> bool:

	# Solo podremos atacar cuando NO llevamos carrito.
	return not is_pushing_cart
	
	

# -----------------------------
# SISTEMA DE SALUD
# -----------------------------

func take_damage(amount: float) -> void:

	# No recibir daño si ya está derrotado.
	if current_health <= 0.0:
		return

	# Restar vida sin permitir valores negativos.
	current_health = max(
		current_health - amount,
		0.0
	)

	# Comunicar el cambio de salud.
	health_changed.emit(current_health, max_health)

	print("Vida del Taquero: ", current_health)

	# Comprobar si murió.
	if current_health <= 0.0:
		player_died.emit()


func heal(amount: float) -> void:

	# No curar si ya murió.
	if current_health <= 0.0:
		return

	# Aumentar vida sin superar el máximo.
	current_health = min(
		current_health + amount,
		max_health
	)

	health_changed.emit(current_health, max_health)


func increase_max_health(percentage: float) -> void:

	# Para la recompensa del jefe del Sprint 3.
	max_health *= 1.0 + percentage

	# Aumentar también la vida actual.
	current_health = min(
		current_health + max_health * percentage,
		max_health
	)

	health_changed.emit(current_health, max_health)
	
	

# -----------------------------
# ATAQUE CUERPO A CUERPO
# -----------------------------

func melee_attack() -> void:

	# No atacar si transportamos el carrito.
	if not can_attack():
		print("No puedes atacar mientras empujas el carrito.")
		return

	# No atacar si el Taquero está muerto.
	if current_health <= 0.0:
		return

	# Comprobar que el cooldown haya terminado.
	if not melee_cooldown.is_stopped():
		print("Cuchillo en cooldown.")
		return

	# Iniciar tiempo de espera para el siguiente golpe.
	melee_cooldown.start()

	print("¡Ataque con cuchillo!")

	# Buscar todos los cuerpos dentro del área.
	var bodies = melee_hitbox.get_overlapping_bodies()

	# Revisar cada cuerpo detectado.
	for body in bodies:

		# Solo podemos dañar enemigos.
		if not body.is_in_group("enemies"):
			continue

		# Comprobar que tenga una función para recibir daño.
		if body.has_method("take_damage"):

			# Aplicar daño.
			body.take_damage(melee_damage)

			print("Cuchillo impactó a: ", body.name)
			
			

# ----------------------------------
# DISPARAR PISTOLA
# ----------------------------------

func shoot() -> void:

	# No disparar mientras empujamos el carrito.
	if not can_attack():
		return

	# No disparar si estamos muertos.
	if current_health <= 0.0:
		return

	# No disparar si aún no tenemos pistola.
	if not has_gun:
		return

	# Respetar el tiempo entre disparos.
	if not shoot_cooldown.is_stopped():
		return

	# Comprobar munición.
	if current_ammo <= 0:
		reload_gun()

		if current_ammo <= 0:
			return

	# Consumir una bala.
	current_ammo -= 1
	weapon_changed.emit()
	# Iniciar cooldown.
	shoot_cooldown.start()

	# Dirección desde el Taquero hacia el mouse.
	var direction: Vector2 = (
		get_global_mouse_position() - global_position
	).normalized()

	if direction == Vector2.ZERO:
		return

	# Obtener el contenedor de proyectiles.
	var bullets_container: Node2D = get_tree().current_scene.get_node(
        "World/Bullets"
	)

	# Crear la bala.
	var bullet = BULLET_SCENE.instantiate()

	# Añadir al escenario.
	bullets_container.add_child(bullet)

	# Colocarla delante del Taquero.
	bullet.global_position = global_position + direction * 26.0

	# Configurar trayectoria y daño.
	bullet.setup(direction, gun_damage)

	print(
		"Disparo | Munición: ",
		current_ammo,
		" / ",
		reserve_ammo
	)


# ----------------------------------
# RECARGAR PISTOLA
# ----------------------------------

func reload_gun() -> void:

	if not has_gun:
		return

	# No podemos recargar sin balas de reserva.
	if reserve_ammo <= 0:
		return

	# Calcular espacio disponible en cargador.
	var missing_ammo: int = magazine_size - current_ammo

	# Tomar solo las balas necesarias.
	var ammo_to_load: int = min(
		missing_ammo,
		reserve_ammo
	)

	current_ammo += ammo_to_load
	reserve_ammo -= ammo_to_load

	print(
		"Pistola recargada: ",
		current_ammo,
		" / ",
		reserve_ammo
	)
	
	weapon_changed.emit()


# ----------------------------------
# RECOGER MUNICIÓN
# ----------------------------------

func add_ammo(amount: int) -> void:

	# Los drops se guardarán en la reserva.
	reserve_ammo += amount

	print("Munición de reserva: ", reserve_ammo)

	# Recargar automáticamente si está vacío.
	if current_ammo <= 0:
		reload_gun()

	weapon_changed.emit()
# ----------------------------------
# DESBLOQUEAR O MEJORAR PISTOLA
# ----------------------------------

func upgrade_gun() -> void:

	# Primera mejora: desbloqueo.
	if not has_gun:

		has_gun = true
		gun_level = 1

		current_ammo = magazine_size

		print("¡Pistola desbloqueada!")
		return

	# Mejoras posteriores: aumentar daño.
	gun_level += 1
	gun_damage += 5.0

	print(
		"Pistola nivel ",
		gun_level,
		" | Daño: ",
		gun_damage
	)


# ----------------------------------
# RECOLECTAR EXPERIENCIA
# ----------------------------------

func add_xp(amount: int) -> void:

	if current_health <= 0.0:
		return

	# Evitar valores negativos.
	current_xp += max(amount, 0)

	print(
		"XP obtenida | Nivel: ",
		player_level,
		" | XP: ",
		current_xp,
		" / ",
		xp_to_next_level
	)

	# Avisar al HUD que cambió la experiencia.
	xp_changed.emit(current_xp, xp_to_next_level)

	# Detectar experiencia suficiente.
	if current_xp >= xp_to_next_level and not level_up_pending:

		level_up_pending = true

		print("¡XP COMPLETA! Mejora disponible.")

		level_up_ready.emit()


# ----------------------------------
# COMPLETAR SUBIDA DE NIVEL
# ----------------------------------

func complete_level_up() -> void:

	# Evitar subir de nivel sin XP suficiente.
	if not level_up_pending:
		return

	# Consumir solamente la XP necesaria.
	# La experiencia sobrante se conserva.
	current_xp -= xp_to_next_level

	# Aumentar el nivel.
	player_level += 1

	# Aumentar 25% el requisito del siguiente nivel.
	xp_to_next_level = ceili(
		xp_to_next_level * 1.25
	)

	# Restablecer el indicador de mejora pendiente.
	level_up_pending = false

	# Comunicar los nuevos valores al HUD.
	xp_changed.emit(current_xp, xp_to_next_level)

	print(
		"Nuevo nivel: ",
		player_level,
		" | XP: ",
		current_xp,
		" / ",
		xp_to_next_level
	)

	# Si sobró XP suficiente para otro nivel,
	# preparar otra selección de mejora.
	if current_xp >= xp_to_next_level:
		level_up_pending = true


# ----------------------------------
# MEJORA DE VELOCIDAD
# ----------------------------------

func upgrade_speed() -> void:

	# Aumentar la velocidad normal un 10%.
	move_speed *= 1.10

	# Aumentar también la velocidad al empujar.
	push_speed *= 1.10

	print(
		"¡Velocidad mejorada! Nueva velocidad: ",
		move_speed
	)
