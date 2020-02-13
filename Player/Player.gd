extends KinematicBody2D

const SPEED = 250
const JUMP_SPEED = 400
const GROUND_FRICTION = 0.8

var velocity = Vector2()
var jump = false

func _ready():
	pass

func _physics_process(delta):
	input()
	movement(delta)
	animate()

func input():
	var dir = 0
	
	if Input.is_action_pressed("move_right"):
		dir += 1
	if Input.is_action_pressed("move_left"):
		dir -= 1
	
	jump = false
	if Input.is_action_just_pressed("jump"):
		jump = true
	
	velocity.x = dir * SPEED

func movement(delta):
	velocity.y += global.GRAVITY * delta
	
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if jump and is_on_floor():
		velocity.y = -JUMP_SPEED

func animate():
	if jump:
		$AnimatedSprite.play("jump")
	else:
		if is_on_floor():
			if abs(velocity.x) > 0:
				$AnimatedSprite.flip_h = velocity.x < 0
				$AnimatedSprite.play("walk")
			else:
				$AnimatedSprite.play("idle")
