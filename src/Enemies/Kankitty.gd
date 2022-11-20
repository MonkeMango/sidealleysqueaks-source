extends KinematicBody2D

const UP := Vector2(0, -1)

export var gravity:float = 20
export var maxfallspeed:float = 340
export var numsteps:int = 20
export var speed:float = 25

var velocity := Vector2()
var steps:int = 0

onready var sprite := $AnimatedSprite

func _physics_process(_delta):
	# strokin...
	velocity.y = min(velocity.y + gravity, maxfallspeed)
	
	velocity = move_and_slide(velocity, UP)

func _on_AnimatedSprite_frame_changed():
	if steps > numsteps:
		steps = 0
		sprite.scale.x *= -1
	if steps % 2 == 0:
		velocity.x = speed * -sign(sprite.scale.x)
	else:
		velocity.x *= .4
	steps += 1
