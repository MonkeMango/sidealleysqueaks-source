extends Node


onready var sprite = $AnimatedSprite
var activated : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if !activated:
		sprite.play("deactivated")
	else:
		sprite.play("activated")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_body_entered(body:Node):
	if body.name == "Player":
		if !activated:
			Globals.update_spawn(self.global_position)
			sprite.play("activating")
			if !Globals.checkpoint_check:
				if $CheckpointNoise.is_playing() == false:
					$CheckpointNoise.play()
			else:
				if $Respawn.is_playing() == false:
					$Respawn.play()

			yield(get_node("AnimatedSprite"), "animation_finished")
			sprite.play("activated")
			activated = true
