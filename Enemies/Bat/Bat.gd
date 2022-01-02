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
onready var wanderContoller = $wanderController
onready var animation_player = $AnimationPlayer


var velocity = Vector2.ZERO
var knockback = Vector2.ZERO


func _ready():
	sprite.frame = rand_range(0, 4)

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
			
			if wanderContoller.get_time_left() == 0:
				update_wander()
		WANDER:
			seek_player()
			
			if wanderContoller.get_time_left() == 0:
				update_wander()
			
			
			accelerate_toward_point(wanderContoller.target_position, delta)
			
			if global_position.distance_to(wanderContoller.target_position) <= MAX_SPEED * delta * 2:
				update_wander()
				
			sprite.flip_h = velocity.x < 0
		CHASE:
			var player = playerDetectionZone.player
			if player != null:
				accelerate_toward_point(player.global_position, delta)
			else:
				state = IDLE
			
	if softCollisiotn.is_colliding():
		velocity += softCollisiotn.get_push_vector() * delta * 400
	

	velocity = move_and_slide(velocity)


func accelerate_toward_point(point, delta):
	var direction = global_position.direction_to(point)
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	sprite.flip_h = velocity.x < 0


func update_wander():
		state = pick_random_state([WANDER, IDLE])
		wanderContoller.start_timer(rand_range(1, 2))


func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE


func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()


func _on_hurtBox_area_entered(area):
	stats.health -= area.damage
	hurtBox.start_invincibility(0.5)
	knockback = area.knockback_vector * 150
	hurtBox.create_hit_effect()
	hurtBox.start_invincibility(0.4)


func _no_health():
	queue_free()
	var enemyDeathEffect = EnemyDeathEffect.instance()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position


func _on_hurtBox_invincibility_started():
	animation_player.play("start")


func _on_hurtBox_invincibility_ended():
	animation_player.play("end")
