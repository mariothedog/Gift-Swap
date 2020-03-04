extends KinematicBody2D

export (NodePath) var connected_node_path
onready var connected_node = get_node(connected_node_path)

var velocity = Vector2()

var pushed = false

func _physics_process(delta):
	velocity.y += global.GRAVITY * delta
	
	velocity = move_and_slide(velocity, Vector2.UP)

func _on_Press_Detection_body_entered(_body):
	$Tween.interpolate_property($"Pushable Button", "position", Vector2.ZERO, Vector2(0, 10), 0.1)
	$Tween.start()
	
	pushed = true
	
	get_node(connected_node_path).activate()

func _on_Press_Detection_body_exited(_body):
	$Tween.interpolate_property($"Pushable Button", "position", $"Pushable Button".position, Vector2.ZERO, 0.1)
	$Tween.start()
	
	pushed = false
