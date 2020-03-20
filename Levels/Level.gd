extends Node2D

const GRASS_TILE = 1

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
		var button_tile_x = stepify(button.position.x, 32) # Snaps the button's x position to the TileMap.
		var top_grass_tile_y
		for cell_pos in $TileMap.get_used_cells():
			var cell_world_pos = $TileMap.map_to_world(cell_pos)
			var tile = $TileMap.get_cellv(cell_pos)
			if cell_world_pos.x == button_tile_x and tile == GRASS_TILE:
				if top_grass_tile_y == null or cell_world_pos.y < top_grass_tile_y:
					top_grass_tile_y = cell_world_pos.y
		
		var button_lowest_pos = Vector2(button.position.x, top_grass_tile_y) + Vector2(0, 16)
		
		var connected_lowest_pos = button_lowest_pos + Vector2((button.connected_node.position - button.position).x, 0)
		
		var colour = Color.gray
		if button.pushed:
			colour = Color(1, 1, 0.13)
		
		draw_line(button.position, button_lowest_pos, colour, 5, true)
		draw_line(button_lowest_pos, connected_lowest_pos, colour, 5, true)
		draw_line(connected_lowest_pos, button.connected_node.position + button.connected_node.wire_offset, colour, 5, true)
