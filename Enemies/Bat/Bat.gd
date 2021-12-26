extends KinematicBody2D

var knockBack = Vector2.ZERO

func _physics_process(delta):
	knockBack = knockBack.move_toward(Vector2.ZERO, 250 * delta)
	knockBack = move_and_slide(knockBack)

func _on_hurtBox_area_entered(area):
	knockBack = Vector2.RIGHT * 120
