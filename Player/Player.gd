extends KinematicBody2D

var item_scene = load("res://Items/Item.tscn")

const SPEED = 250
const JUMP_SPEED = 400
const GROUND_FRICTION = 0.8

var velocity = Vector2()
var jump = false

var held_item = null setget update_hud

func _ready():
	pass

func _physics_process(delta):
	input()
	movement(delta)
	animate()

func input():
	# Movement Input
	var dir = 0
	
	if Input.is_action_pressed("move_right"):
		dir += 1
	if Input.is_action_pressed("move_left"):
		dir -= 1
	
	jump = false
	if Input.is_action_just_pressed("jump"):
		jump = true
	
	velocity.x = dir * SPEED
	
	# Other Input
	#print(self.held_item)
	if Input.is_action_just_pressed("drop_item") and held_item != null:
		spawn_item(held_item)
		self.held_item = null

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

func update_hud(item):
	held_item = item
	if item == null:
		$"HUD/MarginContainer/Held Item Image".texture = null
	else:
		$"HUD/MarginContainer/Held Item Image".texture = load("res://Items/Book.png")

func pick_up_item(item):
	self.held_item = item

func spawn_item(item):
	var item_instance = item_scene.instance()
	#item_instance.type = held_item.type
	
	#var offset
	#if $AnimatedSprite.flip_h:
	#	offset = Vector2(-60, 0)
	#else:
	#	offset = Vector2(60, 0)
	item_instance.position = self.position# + offset
	get_parent().add_child(item_instance)
