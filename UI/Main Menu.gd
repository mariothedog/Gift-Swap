extends Control

func _on_Button_pressed():
	if get_tree().change_scene("res://Levels/Level0.tscn") != OK:
		print_debug("An error occured while changing scene.")
