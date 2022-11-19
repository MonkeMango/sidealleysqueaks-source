extends KinematicBody2D


export var gravity = 20
export var speed = 100
const MAXFALLSPEED = 200
var motion = Vector2()

func _reay():
	pass # Replace with function body.


func _physics_process(delta):
	motion.y += gravity
	
	if motion.y > MAXFALLSPEED:
		motion.y = MAXFALLSPEED
	
	if Input.is_action_pressed("ui_right"):
		motion.x = speed
	elif Input.is_action_pressed("ui_left"):
		motion.x = -speed
	else:
		motion.x = 0
		
	motion = move_and_slide(motion)
