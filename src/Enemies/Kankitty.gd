extends KinematicBody2D

const UP := Vector2(0, -1)

export var gravity:float = 20
export var maxfallspeed:float = 340
export var numsteps:int = 31
export var speed:float = 30
export var offstepspeed:float = 0.005
export var turnprecision:float = .5e-2

var velocity := Vector2()
var targetxspeed:float = 0
var steps:int = ceil(float(numsteps) / 2)

onready var collider := $CollisionShape2D
onready var wallcast := $CollisionShape2D/Wallcast

func _ready():
	wallcast.add_exception(self)

func _physics_process(delta):
	# strokin...
	velocity.y = min(velocity.y + gravity, maxfallspeed)
	
	velocity.x = lerp(velocity.x, targetxspeed, 1 - pow(turnprecision, delta))
	
	velocity = move_and_slide(velocity, UP)

func calc_xspeed():
	targetxspeed = speed * -sign(collider.scale.x)
	if steps % 2 != 0:
		targetxspeed *= offstepspeed

func smart_turn() -> bool:
	return wallcast.is_colliding()

func _on_AnimatedSprite_frame_changed():
	calc_xspeed()
	var turn = steps > numsteps
	var instant_turn = !turn and smart_turn()
	if turn or instant_turn:
		steps = 0
		collider.scale.x *= -1
		if instant_turn:
			calc_xspeed()
	steps += 1
