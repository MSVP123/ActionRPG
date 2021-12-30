extends Node2D

export var hitable = true
var GrassEffect = preload("res://Effects/Grass/GrassEffect.tscn")


func create_grass_effect():
	var grassEffect = GrassEffect.instance()
	get_parent().add_child(grassEffect)
	grassEffect.global_position = global_position
	queue_free()

func _on_hurtBox_area_entered(_area):
	if hitable:
		create_grass_effect()
		queue_free()
