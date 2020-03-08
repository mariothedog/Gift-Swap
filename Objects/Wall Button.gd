extends Node2D

export (NodePath) var connected_node_path
onready var connected_node = get_node(connected_node_path)

var pushed = false

var not_pressing_timer = 0

var modulate_rgb = Vector3(1, 1, 1)

var pushed_colour = 0.9

func _physics_process(delta):
	if $"Press Detection".get_overlapping_bodies():
		not_pressing_timer = 0.21
		modulate_rgb = modulate_rgb.move_toward(Vector3(pushed_colour, pushed_colour, pushed_colour), 0.02)
		update_modulate()
	else:
		if not_pressing_timer >= 0:
			modulate_rgb = modulate_rgb.move_toward(Vector3(pushed_colour, pushed_colour, pushed_colour), 0.02)
			update_modulate()
		else:
			modulate_rgb = modulate_rgb.move_toward(Vector3(1, 1, 1), 0.02)
			update_modulate()
	
	if modulate_rgb.x <= pushed_colour:
		if not pushed:
			pushed = true
			get_node(connected_node_path).activate()
	else:
		if pushed:
			pushed = false
			get_node(connected_node_path).unactivate()
	
	not_pressing_timer -= delta

func update_modulate():
	$"Press Detection/Sprite".modulate.r = modulate_rgb.x
	$"Press Detection/Sprite".modulate.g = modulate_rgb.y
	$"Press Detection/Sprite".modulate.b = modulate_rgb.z
