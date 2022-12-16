extends StaticBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func _ready():
	if Globals.key_grabbed:
		queue_free()


func _on_fork_body_entered(body):
	if body.name == "Player":
		if Globals.key_grabbed:
			$fork/disappear.play("fork lift")
			yield(get_node("fork/disappear"), "animation_finished")
			queue_free()
