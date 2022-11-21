extends KinematicBody2D
const UP := Vector2(0, -1)
var inAir = false

#i'm gonna blow my brains out
var normalGravity = 100
var speed = 150
var accel = 24
var friction = 10
var xval = speed

#air related properties
var fastfall = 500
export var MAXFALLSPEED = 220
var speedAir = 120
export var jumpPeak = 10
export var jumpHeight = 3000
var jumpBuffer:float
export var jumpBuffUSSY:float = 0.2
var jumpWindow:float # coyote jump variable
export var jumpWindowUSSY:float = 0.2
export var jumpDiminish:float = 0.5 # what to multiply the velocity when jump is let go early

var velocity := Vector2()
onready var gravity:float = (2*jumpHeight)/pow(jumpPeak,2)
onready var JUMPFORCE:float = gravity * jumpPeak

# NOTE: i will be replacing this extremely dogshit implementation soon™
var sprite_direction = true

# TODO: put this shit into a state machine :f4rplol:

func _ready():
	$AnimatedSprite.play("idle")

func _physics_process(delta):
	#jelqin...
	velocity.y += gravity
	#do not move when hitting the reset button!!!!
	if OS.is_debug_build():
		if Input.is_action_pressed("reset"):
			 var success = get_tree().reload_current_scene()
	
	if sprite_direction:
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
	
	if is_on_floor():
		inAir = false
		xval = speed
		jumpWindow = jumpWindowUSSY
	else:
		inAir = true
		xval = speedAir
<<<<<<< HEAD
		jumpwindow -= _delta
		if velocity.y > 0:
			$AnimatedSprite.play("fall")
=======
		jumpWindow -= delta
		$AnimatedSprite.play("jump")
>>>>>>> fc2fa7aa378918093af51fa7f8134d09ff1c7b6f
	
	print(jumpBuffer)
	# FIXME: Least schizophrenic David code
	if Input.is_action_just_pressed("jump"):
		jumpBuffer = jumpBuffUSSY
	# NOTE: Testing jump height shit ong, if this doesn't work with coyote jump (I haven't checked I've been awake for nearly 20 hours now) then CoolingTool will do it for me yubbayubbayubba...
<<<<<<< HEAD
	if Input.is_action_just_pressed("jump") && velocity.y < 0:
		velocity.y = 0

	# NOTE: Shouldn't of gotten ahead of myself in all the glory
	if velocity.y < 0:
		$AnimatedSprite.play("jump")
	
	jumpBuffer -= _delta
	if jumpBuffer > 0 && jumpwindow > 0:
=======
	# yeah it does
	if Input.is_action_just_released("jump") && velocity.y < 0:
		velocity.y *= jumpDiminish
	
	# FIXME: I cannot wait to clean up this actual braindead shit I've created 
	if Input.is_action_just_pressed("ui_down") && is_on_floor() == false:
		velocity.y = fastfall
		
	jumpBuffer -= delta
	if jumpBuffer > 0 && jumpWindow > 0:
>>>>>>> fc2fa7aa378918093af51fa7f8134d09ff1c7b6f
		if $SoundEffects/Jump.playing == false:
			$SoundEffects/Jump.play()
		jumpWindow = 0
		jumpBuffer = 0
		velocity.y = -JUMPFORCE
	
	velocity = move_and_slide(velocity, UP)
