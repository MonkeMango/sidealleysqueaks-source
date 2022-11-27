extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const UP := Vector2(0, -1)
var velocity := Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	$CollisionShape2D/AnimatedSprite.play('idle')
	velocity.x = 300
	velocity = move_and_slide(velocity, UP)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
