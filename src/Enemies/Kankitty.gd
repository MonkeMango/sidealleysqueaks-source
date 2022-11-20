extends KinematicBody2D

const UP := Vector2(0, -1)

export var gravity:float = 20
export var maxfallspeed:float = 340
export var numsteps:int = 20
export var speed:float = 25
export var offstepspeed:float = .2
export var turnprecision:float = .1e-2

var velocity := Vector2()
var targetxspeed:float = 0
var steps:int = 0

onready var sprite := $AnimatedSprite

func _physics_process(delta):
	# strokin...
	velocity.y = min(velocity.y + gravity, maxfallspeed)
	
	velocity.x = lerp(velocity.x, targetxspeed, 1 - pow(turnprecision, delta))
	
	velocity = move_and_slide(velocity, UP)

func _on_AnimatedSprite_frame_changed():
	if steps % 2 == 0:
		targetxspeed = speed * -sign(sprite.scale.x)
	else:
		targetxspeed *= offstepspeed
	if steps > numsteps:
		steps = 0
		sprite.scale.x *= -1
	steps += 1
