extends KinematicBody2D

onready var stats = $Stats

var knockBack = Vector2.ZERO

func _ready():
	print(stats.health)

func _physics_process(delta):
	knockBack = knockBack.move_toward(Vector2.ZERO, 250 * delta)
	knockBack = move_and_slide(knockBack)

func _on_hurtBox_area_entered(area):
	stats.health -= area.damage
	knockBack = area.knockback_vector * 120


func _no_health():
	queue_free()
