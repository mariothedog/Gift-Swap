extends KinematicBody2D

# Preload resources
var item_scene = preload("res://Items/Item.tscn")
var block_item_effect_scene = preload("res://Effects/Block Item Effect/Block Item Effect.tscn")
var spawn_item_effect_scene = preload("res://Effects/Spawn Item Effect/Spawn Item Effect.tscn")

# Movement constants
const SPEED = 250
const JUMP_SPEED = 400
const GROUND_FRICTION = 0.8

# Movement variables
var velocity = Vector2()
var jump = false

# Item variables
var held_item = null setget _update_hud

func _physics_process(delta) -> void:
	_get_input()
	_movement(delta)
	_animate()

func _get_input() -> void:
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

func _input(event) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT and held_item != null:
		var blocked = false
		
		var spawn_position = event.position
		
		var space = get_world_2d().direct_space_state
		for intersection in space.intersect_point(spawn_position):
			if intersection.collider.is_in_group("Blocks Drop"):
				blocked = true
		
		if not blocked:
			if spawn_position < Vector2.ZERO or spawn_position.x > 1024 or spawn_position.y > 600:
				blocked = true
			
			var dir_blocked = []
			
			var item_texture_size = global.item_textures[held_item].get_size()
			
			var offset_x = Vector2(item_texture_size.x / 2 + 5, 0)
			var offset_y = Vector2(0, item_texture_size.y / 2)
			
			for i in range(-1, 2, 2):
				for intersection in space.intersect_point(event.position + i * offset_x):
					if intersection.collider.is_in_group("Blocks drop"):
						dir_blocked.append(true)
						
						spawn_position.x += -i * 15 # So the item doesn't get stuck in walls
				
				for intersection in space.intersect_point(event.position + i * offset_y):
					if intersection.collider.is_in_group("Blocks drop") and not intersection.collider.get_parent().is_in_group("Buttons"):
						dir_blocked.append(true)
						
						spawn_position.y += -i * 8 # So the item doesn't get stuck in the floor or the ceiling
			
			if len(dir_blocked) >= 2:
				blocked = true
		
		if not blocked:
			_spawn_item(held_item, spawn_position)
			self.held_item = null
		else:
			_spawn_block_item_effect(event.position)

func _movement(delta) -> void:
	velocity.y += global.GRAVITY * delta
	
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if jump and is_on_floor():
		velocity.y = -JUMP_SPEED

func _animate() -> void:
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

func _update_hud(item) -> void:
	held_item = item
	if item == null:
		$"HUD/MarginContainer/Held Item Image".texture = null
	else:
		$"HUD/MarginContainer/Held Item Image".texture = global.item_textures[held_item]

func pick_up_item(item_type) -> void:
	self.held_item = item_type

func _spawn_item(item, pos) -> void:
	# Spawn portal at the player
	var spawn_item_effect_player = spawn_item_effect_scene.instance()
	var offset = Vector2()
	if $AnimatedSprite.flip_h:
		offset = Vector2(-25, 0)
	else:
		offset = Vector2(25, 0)
	spawn_item_effect_player.position = position + offset
	get_parent().get_node("Effects").add_child(spawn_item_effect_player)
	
	# Spawn portal at the item spawn location
	var spawn_item_effect = spawn_item_effect_scene.instance()
	spawn_item_effect.position = pos
	get_parent().get_node("Effects").add_child(spawn_item_effect)
	
	var item_instance = item_scene.instance()
	item_instance.type = item
	item_instance.position = position + offset
	get_parent().get_node("Items").add_child(item_instance)
	item_instance.delay()
	
	yield(item_instance, "delay_finished")
	
	item_instance.position = pos
	
	# Remove portals
	spawn_item_effect_player.fade()
	spawn_item_effect.fade()

func _spawn_block_item_effect(pos) -> void:
	var block_item_effect = block_item_effect_scene.instance()
	block_item_effect.position = pos
	get_parent().get_node("Effects").add_child(block_item_effect)
