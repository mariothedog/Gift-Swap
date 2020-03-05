extends KinematicBody2D

export (NodePath) var connected_node_path
onready var connected_node = get_node(connected_node_path)

var velocity = Vector2()

var pushed = false

var not_pressing_timer = 0

func _physics_process(delta):
	velocity.y += global.GRAVITY * delta
	
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if $"Pushable Button/Press Detection".get_overlapping_bodies():
		not_pressing_timer = 0.15
		$"Pushable Button".position.y = move_toward($"Pushable Button".position.y, 10, 1.2)
	else:
		if not_pressing_timer >= 0:
			$"Pushable Button".position.y = move_toward($"Pushable Button".position.y, 10, 1.2)
		else:
			$"Pushable Button".position.y = move_toward($"Pushable Button".position.y, 0, 1.2)

	if $"Pushable Button".position.y >= 5:
		if not pushed:
			pushed = true

			get_node(connected_node_path).activate()
	else:
		pushed = false
	
	not_pressing_timer -= delta
