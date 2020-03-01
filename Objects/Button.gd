extends KinematicBody2D

export (NodePath) var connected_node_path
onready var connected_node = get_node(connected_node_path)

var velocity = Vector2()

#func _draw():
#	var button_pos = get_global_transform_with_canvas().origin
#	var connected_node_pos = connected_node.get_global_transform_with_canvas().origin
#	print(button_pos)
#	print(connected_node_pos)
#	#draw_line(button_pos, connected_node_pos, Color.red, 5.0)
#	#draw_line(Vector2.ZERO, Vector2(100, 100), Color.black, 5.0)

func _physics_process(delta):
	#update()
	velocity.y += global.GRAVITY * delta
	
	velocity = move_and_slide(velocity, Vector2.UP)

func _on_Press_Detection_body_entered(_body):
	$Tween.interpolate_property($"Pushable Button", "position", Vector2.ZERO, Vector2(0, 10), 0.1)
	$Tween.start()
	
	get_node(connected_node_path).activate()

func _on_Press_Detection_body_exited(_body):
	$Tween.interpolate_property($"Pushable Button", "position", $"Pushable Button".position, Vector2.ZERO, 0.1)
	$Tween.start()
