extends Node2D

func _ready():
	modulate.a = 0
	
	$"Level Transition".interpolate_property(self, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1),
	0.4, Tween.TRANS_SINE, Tween.EASE_OUT)
	$"Level Transition".start()

func _process(_delta):
	update()

func next_level():
	global.current_level += 1
	
	$"Level Transition".interpolate_property(self, "modulate", modulate, Color(1, 1, 1, 0),
	0.4, Tween.TRANS_SINE)
	$"Level Transition".start()
	
	yield($"Level Transition", "tween_completed")
	if get_tree().change_scene("res://Levels/Level%s.tscn" % global.current_level) != OK:
		print_debug("An error occured while changing scene.")

func _draw():
	for button in get_tree().get_nodes_in_group("Buttons"):
		var button_lowest_pos = button.position + Vector2(0, 40)
		var connected_lowest_pos = button_lowest_pos + Vector2((button.connected_node.position - button.position).x, 0)
		
		var colour = Color.gray
		if button.pushed:
			colour = Color(1, 1, 0.13)
		
		draw_line(button.position, button_lowest_pos, colour, 5, true)
		draw_line(button_lowest_pos, connected_lowest_pos, colour, 5, true)
		draw_line(connected_lowest_pos, button.connected_node.position + button.connected_node.wire_offset, colour, 5, true)
