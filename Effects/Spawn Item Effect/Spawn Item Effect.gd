extends Sprite

func fade():
	$AnimationPlayer.play("Fade")
	
	yield($AnimationPlayer, "animation_finished")
	
	queue_free()
