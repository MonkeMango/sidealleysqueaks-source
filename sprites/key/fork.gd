extends StaticBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_fork_body_entered(body):
	if body.name == "Player":
		if Globals.key_grabbed:
			$fork/disappear.play("fork lift")
			yield(get_node("fork/disappear"), "animation_finished")
			queue_free()
