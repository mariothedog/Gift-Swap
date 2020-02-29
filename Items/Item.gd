extends RigidBody2D

var type = "Book"

func _on_Area2D_body_entered(body):
	queue_free()
	body.pick_up_item(self)

func delay():
	$Area2D/CollisionShape2D.disabled = true
	$"Pickupable Timer".start()

func _on_Pickupable_Timer_timeout():
	$Area2D/CollisionShape2D.disabled = false
