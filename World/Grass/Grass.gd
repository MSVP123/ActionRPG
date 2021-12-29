extends Node2D

export var hitable = true

func create_grass_effect():
	var GrassEffect = load("res://Effects/Grass/grassEffect.tscn")
	var grassEffect = GrassEffect.instance()
	var world = get_tree().current_scene
	world.add_child(grassEffect)
	grassEffect.global_position = global_position
	queue_free()

func _on_hurtBox_area_entered(area):
	if hitable:
		create_grass_effect()
		queue_free()
