extends KinematicBody2D

const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect/EnemyDeathEffect.tscn")

onready var stats = $Stats

var knockBack = Vector2.ZERO

func _physics_process(delta):
	knockBack = knockBack.move_toward(Vector2.ZERO, 250 * delta)
	knockBack = move_and_slide(knockBack)

func _on_hurtBox_area_entered(area):
	stats.health -= area.damage
	knockBack = area.knockback_vector * 120


func _no_health():
	queue_free()
	var enemyDeathEffect = EnemyDeathEffect.instance()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position
