extends Node2D

func _ready():
	$ColorRect.color = Color(0.57, 0.66, 0.73);
	
	modulate.a = 0
	
	$"Level Transition".interpolate_property(self, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1),
	0.4, Tween.TRANS_SINE, Tween.EASE_OUT)
	$"Level Transition".start()

func next_level():
	global.current_level += 1
	
	$"Level Transition".interpolate_property(self, "modulate", modulate, Color(1, 1, 1, 0),
	0.4, Tween.TRANS_SINE)
	$"Level Transition".start()
	
	yield($"Level Transition", "tween_completed")
	get_tree().change_scene("res://Levels/Level%s.tscn" % global.current_level)
	#if get_tree().change_scene("res://Levels/Level%s.tscn" % global.current_level) != OK:
	#	print_debug("An error occured while changing scene.")
