tool
extends RigidBody2D

signal delay_finished

export (String, "Book", "Blue Book", "Bouncy Ball") var type = "Book" setget set_texture

onready var item_properties = {
	"Bouncy Ball" : [1, false, 1, false]
}

func _ready() -> void:
	$Sprite.texture = global.item_textures[type]
	
	if not Engine.editor_hint:
		var properties = item_properties.get(type)
		if properties:
			physics_material_override.friction = properties[0]
			physics_material_override.rough = properties[1]
			physics_material_override.bounce = properties[2]
			physics_material_override.absorbent = properties[3]

func set_texture(test):
	type = test
	if Engine.editor_hint and has_node("Sprite"):
		$Sprite.texture = global.item_textures[type]

func _on_Area2D_body_entered(body) -> void:
	queue_free()
	body.pick_up_item(type)

func delay() -> void:
	$Area2D/CollisionShape2D.disabled = true
	gravity_scale = 0
	
	$Tween.interpolate_property($Sprite, "modulate",
	Color(1, 1, 1, 1), Color(1, 1, 1, 0), 0.5)
	$Tween.start()
	
	yield($Tween, "tween_completed")
	
	$Area2D/CollisionShape2D.disabled = false
	gravity_scale = 1
	
	emit_signal("delay_finished")
	
	$Tween.interpolate_property($Sprite, "modulate",
	Color(1, 1, 1, 0), Color(1, 1, 1, 1), 0.5)
	$Tween.start()
