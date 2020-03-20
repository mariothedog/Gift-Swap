tool
extends RigidBody2D

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
	$"Pickupable Timer".start()

func _on_Pickupable_Timer_timeout() -> void:
	$Area2D/CollisionShape2D.disabled = false
