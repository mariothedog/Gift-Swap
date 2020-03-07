extends RigidBody2D

export (String, "Book", "Blue Book", "Bouncy Ball") var type

func _ready():
	$Sprite.texture = global.item_textures[type]

func _on_Area2D_body_entered(body):
	queue_free()
	body.pick_up_item(type)

func delay():
	$Area2D/CollisionShape2D.disabled = true
	$"Pickupable Timer".start()

func _on_Pickupable_Timer_timeout():
	$Area2D/CollisionShape2D.disabled = false
