extends Node2D

# PRUEBA TEMPORAL DE DAÑOS (se elimina al terminar el diagnóstico).

const ENEMY_SCENE: PackedScene = preload("res://scenes/taco_enemy.tscn")
const BULLET_SCENE: PackedScene = preload("res://scenes/bullet.tscn")


func _ready() -> void:
	_run()


func _run() -> void:
	var player: CharacterBody2D = $World/Player
	var cart: CharacterBody2D = $World/Cart
	var wm: Node = $WaveManager
	var drops: Node2D = $World/Drops
	var enemies: Node2D = $World/Enemies

	# Detener la generación automática de oleadas.
	wm.set("wave_active", false)
	wm.get_node("SpawnTimer").stop()
	wm.get_node("WaveTimer").stop()
	for c in enemies.get_children():
		c.free()

	player.set("has_gun", true)
	player.set("current_ammo", 50)
	player.set_physics_process(false)

	await get_tree().create_timer(0.3).timeout

	# ---------- TEST 1: CUCHILLO -> ENEMIGO ----------
	var e1: CharacterBody2D = ENEMY_SCENE.instantiate()
	enemies.add_child(e1)
	e1.global_position = player.global_position + Vector2(55, 0)
	e1.set_physics_process(false)
	player.get_node("MeleeHitbox").rotation = 0.0
	await get_tree().create_timer(0.4).timeout
	var hp1_before: float = e1.current_health
	player.call("melee_attack")
	await get_tree().create_timer(0.2).timeout
	print("TEST1 CUCHILLO->ENEMIGO | antes=", hp1_before, " despues=", e1.current_health, " => ", _verdict(e1.current_health < hp1_before))

	# ---------- TEST 2: BALA -> ENEMIGO ----------
	var e2: CharacterBody2D = ENEMY_SCENE.instantiate()
	enemies.add_child(e2)
	e2.global_position = player.global_position + Vector2(0, 160)
	e2.set_physics_process(false)
	await get_tree().create_timer(0.2).timeout
	var hp2_before: float = e2.current_health
	var bullet: Area2D = BULLET_SCENE.instantiate()
	$World/Bullets.add_child(bullet)
	bullet.global_position = e2.global_position - Vector2(160, 0)
	bullet.call("setup", Vector2.RIGHT, 20.0)
	await get_tree().create_timer(0.6).timeout
	print("TEST2 BALA->ENEMIGO | antes=", hp2_before, " despues=", e2.current_health, " => ", _verdict(e2.current_health < hp2_before))

	# ---------- TEST 3: ENEMIGO -> TAQUERO (contacto) ----------
	var php_before: float = player.current_health
	var e3: CharacterBody2D = ENEMY_SCENE.instantiate()
	enemies.add_child(e3)
	e3.global_position = player.global_position + Vector2(38, 0)
	await get_tree().create_timer(2.4).timeout
	print("TEST3 ENEMIGO->TAQUERO | antes=", php_before, " despues=", player.current_health, " => ", _verdict(player.current_health < php_before))

	# ---------- TEST 4: ENEMIGO -> CARRITO (contacto) ----------
	var chp_before: float = cart.current_health
	var e4: CharacterBody2D = ENEMY_SCENE.instantiate()
	enemies.add_child(e4)
	e4.global_position = cart.global_position + Vector2(46, 0)
	await get_tree().create_timer(2.4).timeout
	print("TEST4 ENEMIGO->CARRITO | antes=", chp_before, " despues=", cart.current_health, " => ", _verdict(cart.current_health < chp_before))

	# ---------- TEST 5: MUERTE -> DROPS ----------
	e2.enemy_died.connect(wm.on_enemy_died)
	var drops_before: int = drops.get_child_count()
	e2.current_health = 1.0
	e2.call("take_damage", 999.0)
	await get_tree().create_timer(0.3).timeout
	print("TEST5 MUERTE->DROPS | drops antes=", drops_before, " despues=", drops.get_child_count(), " => ", _verdict(drops.get_child_count() > drops_before))

	print("=== FIN TEST ===")


func _verdict(ok: bool) -> String:
	return "OK" if ok else "FALLO"