extends Node2D

# PRUEBA TEMPORAL DE ROTACIÓN (se elimina al terminar el diagnóstico).

func _ready() -> void:
	var rots: Array[float] = [0.0, -PI / 2.0, -PI, PI / 2.0]
	var i: int = 0
	for p in get_children():
		if p is CharacterBody2D:
			p.set_physics_process(false)
			var spr: AnimatedSprite2D = p.get_node("AnimatedSprite2D")
			spr.rotation = rots[i]
			print("Player ", i, " rot=", rots[i])
			i += 1