extends KinematicBody2D
const UP = Vector2(0, -1)
export var gravity = 20
export var speed = 100
export var accel = 24
export var friction = 10
export var MAXFALLSPEED = 600
export var speedAir = 100
var xval
export var JUMPFORCE = 400
var velocity = Vector2()
# true = right, false = left very stupid Yubbayubba
var sprite_direction = true
func _ready():
	pass




func _physics_process(_delta):
	#jelqin...
	velocity.y += gravity
	if OS.is_debug_build():
		if Input.is_action_pressed("reset"):
			get_tree().reload_current_scene()		


	
	if sprite_direction == true:
		$AnimatedSprite.scale.x = -1
	else:
		$AnimatedSprite.scale.x = 1
	
	if velocity.y > MAXFALLSPEED:
		velocity.y = MAXFALLSPEED
	
	if Input.is_action_pressed("ui_right"):
		velocity.x = min(velocity.x + accel, xval)
		$AnimatedSprite.play("run")
		sprite_direction = true
	elif Input.is_action_pressed("ui_left"):
		$AnimatedSprite.play("run")
		velocity.x = max(velocity.x - accel, -xval)
		sprite_direction = false
	else:
		velocity.x = lerp(velocity.x, 0, 0.3)
		$AnimatedSprite.play("idle")
#	if is_on_floor():
# 		 x_vel = SPEED
#	else:
 # 		x_vel = AIRSPEED
	
	if is_on_floor():
		xval = speed
		if Input.is_action_just_pressed("jump"):
			velocity.y = -JUMPFORCE
	else:
		xval = speedAir
		if velocity.y > 0:
			$AnimatedSprite.play("jump")
		
	velocity = move_and_slide(velocity, UP)
