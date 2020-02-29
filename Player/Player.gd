extends KinematicBody2D

var item_scene = load("res://Items/Item.tscn")

const SPEED = 250
const JUMP_SPEED = 400
const GROUND_FRICTION = 0.8

var velocity = Vector2()
var jump = false

var held_item = null setget update_hud

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

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT and held_item != null:
		var blocked = false
		
		var space = get_world_2d().direct_space_state
		for intersection in space.intersect_point(event.position):
			if intersection.collider.is_in_group("Blocks Drop"):
				blocked = true
		
		if not blocked:
			spawn_item(held_item, event.position)
			self.held_item = null
		else:
			pass

func movement(delta):
	velocity.y += global.GRAVITY * delta
	
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if jump and is_on_floor():
		velocity.y = -JUMP_SPEED

func animate():
	if abs(velocity.x) > 0:
		$AnimatedSprite.flip_h = velocity.x < 0
	
	if jump:
		$AnimatedSprite.play("jump")
	else:
		if is_on_floor():
			if abs(velocity.x) > 0:
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

func spawn_item(item, pos):
	var item_instance = item_scene.instance()
	# TODO different item types
	#item_instance.type = held_item.type
	
	item_instance.position = pos
	get_parent().add_child(item_instance)
	if pos.distance_to(position) <= 70:
		item_instance.delay()
