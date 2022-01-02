extends KinematicBody2D

const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect/EnemyDeathEffect.tscn")

export var ACCELERATION = 200
export var MAX_SPEED = 40
export var FRICTION = 200

enum {
	IDLE,
	WANDER,
	CHASE
}
var state = CHASE

onready var sprite = $AnimatedSprite
onready var stats = $Stats
onready var playerDetectionZone = $PlayerDectionZone
onready var hurtBox = $hurtBox
onready var softCollisiotn = $softCollision

var velocity = Vector2.ZERO
var knockback = Vector2.ZERO


func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
		WANDER:
			pass
			
		CHASE:
			var player = playerDetectionZone.player
			if player != null:
				var direction = (player.global_position - global_position).normalized()
				velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
			else:
				state = IDLE
			sprite.flip_h = velocity.x < 0
	if softCollisiotn.is_colliding():
		velocity += softCollisiotn.get_push_vector() * delta * 400
	velocity = move_and_slide(velocity)


func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE


func _on_hurtBox_area_entered(area):
	stats.health -= area.damage
	hurtBox.start_invincibility(0.5)
	knockback = area.knockback_vector * 150
	hurtBox.create_hit_effect()


func _no_health():
	queue_free()
	var enemyDeathEffect = EnemyDeathEffect.instance()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position
