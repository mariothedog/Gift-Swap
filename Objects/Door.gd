extends Area2D

var wire_offset = Vector2(0, 40)

onready var open_vector = Vector2(64, 120)
onready var closed_vector = Vector2(64, 15)

func activate():
	$"Slide Tween".interpolate_method(self, "_tween_region_rect", $Sprite.region_rect.size, closed_vector,
	0.8, Tween.TRANS_CUBIC, Tween.EASE_IN)
	$"Slide Tween".start()

func unactivate():
	$"Slide Tween".interpolate_method(self, "_tween_region_rect", $Sprite.region_rect.size, open_vector,
	0.8, Tween.TRANS_CUBIC, Tween.EASE_IN)
	$"Slide Tween".start()

func _tween_region_rect(size):
	var rect = $Sprite.region_rect
	rect.size = size
	$Sprite.region_rect = rect
