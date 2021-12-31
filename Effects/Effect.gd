extends AnimatedSprite


func _ready():
# warning-ignore:return_value_discarded
	connect("animation_finished", self, "_animation_finished")
	play("animate")

func _animation_finished():
	queue_free()
