extends KinematicBody2D

const UP := Vector2(0, -1)

export var gravity:float = 20
export var maxfallspeed:float = 340
export var numsteps:int = 16
export var speed:float = 20
export var turnprecision:float = .5e-2

var velocity := Vector2()
var targetxspeed:float = 0
var steps:int = numsteps
onready var ready:bool = true

onready var collider := $CollisionShape2D
onready var sprite := $CollisionShape2D/AnimatedSprite
onready var wallcast := $CollisionShape2D/Wallcast

func _ready():
	wallcast.add_exception(self)

func _physics_process(delta):
	# strokin...
	velocity.y = min(velocity.y + gravity, maxfallspeed)
	
	velocity.x = lerp(velocity.x, targetxspeed, 1 - pow(turnprecision, delta))
	
	velocity = move_and_slide(velocity, UP)

func _frame_changed():
	if ready and sprite.animation == 'walk':
		if steps > numsteps * 2 or smart_turn():
			steps = 0
			collider.scale.x *= -1
			sprite.play('turn')
		steps += 1
		targetxspeed = speed * -sign(collider.scale.x)

func _animation_finished():
	if sprite.animation != 'walk':
		sprite.play('walk')

# for blueberry kankitty
func smart_turn() -> bool:
	return wallcast.is_colliding()
