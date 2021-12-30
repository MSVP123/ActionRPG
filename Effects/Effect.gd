extends AnimatedSprite


func _ready():
	connect("animation_finished", self, "_animation_finished")
	play("animate")

func _animation_finished():
	queue_free()
