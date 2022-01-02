extends KinematicBody2D

const ACCELERATION = 500
const MAX_SPEED = 75
const ROLL_SPEED = 90
const FRICTION = 500

const PlayerHurtSound = preload("res://Player/playerHurtsound.tscn")

var velocity = Vector2.ZERO
var roll_vector = Vector2.DOWN
var stats = PlayerStats
var state = MOVE
enum { MOVE, ROLL, ATTACK
}

onready var animation_player = $AnimationPlayer
onready var animation_tree = $AnimationTree
onready var animation_state = $AnimationTree.get("parameters/playback")
onready var swordHitBox = $HitBoxPiviot/SwordHitBox
onready var swordHitBoxCollision = $HitBoxPiviot/SwordHitBox/CollisionShape2D
onready var hurtBox = $hurtBox
onready var blink_animation_player = $Blinking 

func _ready():
	randomize()
	stats.connect("no_health", self, "queue_free")
	animation_tree.active = true
	swordHitBoxCollision.disabled = true
	swordHitBox.knockback_vector = roll_vector

func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		ROLL:
			roll_state()
		ATTACK:
			attack_state()

func move():
	velocity = move_and_slide(velocity)

func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input_vector.y = Input.get_action_strength("backwords") - Input.get_action_strength("forward")
	input_vector = input_vector.normalized()

	if input_vector != Vector2.ZERO:
		roll_vector = input_vector
		swordHitBox.knockback_vector = input_vector
		animation_tree.set("parameters/Idle/blend_position", input_vector)
		animation_tree.set("parameters/Run/blend_position", input_vector)
		animation_tree.set("parameters/Attack/blend_position", input_vector)
		animation_tree.set("parameters/Roll/blend_position", input_vector)
		animation_state.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animation_state.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	move()
	
	if Input.is_action_pressed("attack"):
		velocity = Vector2.ZERO
		state = ATTACK
	if Input.is_action_pressed("roll") or Input.is_action_just_released("roll"):
		state = ROLL


func attack_state():
	animation_state.travel("Attack")


func attack_animation_finished():
	state = MOVE


func roll_state():
	velocity = roll_vector * ROLL_SPEED 
	animation_state.travel("Roll")
	move()


func roll_animation_finished():
	velocity =  velocity / 2
	state = MOVE


func _on_hurtBox_area_entered(area):
	stats.health -= area.damage
	hurtBox.start_invincibility(0.75)
	hurtBox.create_hit_effect()
	var playerHurtSound = PlayerHurtSound.instance()
	get_tree().current_scene.add_child(playerHurtSound)


func _on_hurtBox_invincibility_started():
	blink_animation_player.play("start")


func _on_hurtBox_invincibility_ended():
	blink_animation_player.play("end")
