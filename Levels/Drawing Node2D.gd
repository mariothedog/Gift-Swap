extends Node2D

func _process(_delta):
	update()

func _draw():
	for button in get_tree().get_nodes_in_group("Buttons"):
		var button_lowest_pos = button.position + Vector2(0, 40)
		var connected_lowest_pos = button_lowest_pos + Vector2((button.connected_node.position - button.position).x, 0)
		draw_line(button.position, button_lowest_pos, Color.red, 5, true)
		draw_line(button_lowest_pos, connected_lowest_pos, Color.red, 5, true)
		draw_line(connected_lowest_pos, button.connected_node.position + button.connected_node.wire_offset, Color.red, 5, true)
