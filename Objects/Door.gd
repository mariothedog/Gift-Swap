extends Area2D

var wire_offset = Vector2(0, 40)

onready var open_vector = Vector2(64, 120)
onready var closed_vector = Vector2(64, 15)

const MINIMUM_TIME_ON_DOOR_TO_USE = 0.2
var time_on_door = 0
var door_entered = false

func _process(delta):
	if get_overlapping_bodies():
		time_on_door += delta
	
	if time_on_door >= MINIMUM_TIME_ON_DOOR_TO_USE and not door_entered:
		door_entered = true
		get_parent().next_level()

func activate() -> void:
	$"Slide Tween".stop_all()
	$"Slide Tween".interpolate_method(self, "_tween_region_rect", $Sprite.region_rect.size, closed_vector,
	0.8, Tween.TRANS_CUBIC, Tween.EASE_IN)
	$"Slide Tween".start()
	
	yield($"Slide Tween", "tween_completed")
	if $Sprite.region_rect.size.y == 15:
		$CollisionShape2D.disabled = false

func unactivate() -> void:
	$"Slide Tween".stop_all()
	$"Slide Tween".interpolate_method(self, "_tween_region_rect", $Sprite.region_rect.size, open_vector,
	0.8, Tween.TRANS_CUBIC, Tween.EASE_IN)
	$"Slide Tween".start()
	
	$CollisionShape2D.disabled = true

func _tween_region_rect(size) -> void:
	var rect = $Sprite.region_rect
	rect.size = size
	$Sprite.region_rect = rect

func _on_Door_body_exited(_body) -> void:
	time_on_door = 0
