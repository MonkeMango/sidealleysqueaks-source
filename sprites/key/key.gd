extends Area2D


func _on_Node2D_body_entered(body):
	if body.name == "Player":
		$AnimatedSprite.play("greasy");
		$AudioStreamPlayer.play();
		Globals.key_grabbed = true;
		yield(get_node("AnimatedSprite"), "animation_finished");
		queue_free();
