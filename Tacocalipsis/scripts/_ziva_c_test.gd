extends Node2D

# PRUEBA TEMPORAL: disparar mientras se mueve (se elimina al terminar).

func _ready() -> void:
	var p: CharacterBody2D = $World/Player
	p.set("has_gun", true)
	p.set("current_ammo", 999)
	_report(p)


func _report(p: CharacterBody2D) -> void:
	for i in range(8):
		await get_tree().create_timer(0.5).timeout
		print(
			"C-TEST t=", (i + 1) * 0.5,
			" pos=", p.global_position,
			" balas=", $World/Bullets.get_child_count()
		)
	print("=== FIN C-TEST ===")