extends RigidBody2D

var type = "Book"

func _on_Area2D_body_entered(body):
	if body.name == "Player":
		queue_free()
		body.pick_up_item(self)

func _on_Delay_before_pickupable_timeout():
	$Area2D/CollisionShape2D.disabled = false
