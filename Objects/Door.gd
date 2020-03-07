extends Area2D

var wire_offset = Vector2(0, 40)

onready var open_vector = Vector2(64, 120)
onready var closed_vector = Vector2(64, 15)

var open = false

func activate():
	$"Slide Tween".interpolate_method(self, "_tween_region_rect", $Sprite.region_rect.size, closed_vector,
	0.8, Tween.TRANS_CUBIC, Tween.EASE_IN)
	$"Slide Tween".start()
	
	yield($"Slide Tween", "tween_completed")
	if $Sprite.region_rect.size.y == 15:
		open = true

func unactivate():
	$"Slide Tween".interpolate_method(self, "_tween_region_rect", $Sprite.region_rect.size, open_vector,
	0.8, Tween.TRANS_CUBIC, Tween.EASE_IN)
	$"Slide Tween".start()
	
	open = false

func _tween_region_rect(size):
	var rect = $Sprite.region_rect
	rect.size = size
	$Sprite.region_rect = rect

func _on_Door_body_entered(_body):
	if open:
		print("Door used")
		# TODO Go to next level
