extends RigidBody2D

export (String, "Book", "Blue Book", "Bouncy Ball") var type

onready var item_properties = {
	"Bouncy Ball" : [1, false, 0.8, false]
}

func _ready():
	$Sprite.texture = global.item_textures[type]
	
	var properties = item_properties.get(type)
	if properties:
		physics_material_override.friction = properties[0]
		physics_material_override.rough = properties[1]
		physics_material_override.bounce = properties[2]
		physics_material_override.absorbent = properties[3]

func _on_Area2D_body_entered(body):
	queue_free()
	body.pick_up_item(type)

func delay():
	$Area2D/CollisionShape2D.disabled = true
	$"Pickupable Timer".start()

func _on_Pickupable_Timer_timeout():
	$Area2D/CollisionShape2D.disabled = false
