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
export var jumpHeight = 4000
var jumpBuffer:float
export var jumpBuffUSSY:float = 0.2
var jumpWindow:float # coyote jump variable
export var jumpWindowUSSY:float = 0.2
export var jumpDiminish:float = 0.6 # what to multiply the velocity when jump is let go early
var canShortJump:bool = true # (can short jump currently)
var perfect_wavedash_modifier = 1.11

var velocity := Vector2()
var yoyoSavedX:float = 1
var yoyoVector := Vector2(yoyoSavedX, 0)
var isWalking:bool = false
onready var gravity:float = (2*jumpHeight)/pow(jumpPeak,2)
onready var JUMPFORCE:float = gravity * jumpPeak

# Oog....
onready var loadyoyo : Area2D

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
			 var _success = get_tree().reload_current_scene()
	
	if sprite_direction:
		$AnimatedSprite.scale.x = -1
	else:
		$AnimatedSprite.scale.x = 1
	
	if velocity.y > MAXFALLSPEED:
		velocity.y = MAXFALLSPEED
	
	isWalking = true
	if Input.is_action_pressed("ui_right"):
		velocity.x = min(velocity.x + accel, xval)
		$AnimatedSprite.play("run")
		sprite_direction = true
		yoyoSavedX = 1
	elif Input.is_action_pressed("ui_left"):
		$AnimatedSprite.play("run")
		velocity.x = max(velocity.x - accel, -xval)
		sprite_direction = false
		yoyoSavedX = -1
	else:
		velocity.x = lerp(velocity.x, 0, 0.3)
		$AnimatedSprite.play("idle")
		isWalking = false
	if Input.is_action_pressed("ui_up"):
		yoyoVector.y = -1
	elif Input.is_action_pressed("ui_down"):
		yoyoVector.y = 1
	else:
		yoyoVector.y = 0
	
	if (!isWalking and yoyoVector.y != 0):
		yoyoVector.x = 0
	else:
		yoyoVector.x = yoyoSavedX
	
	if $BonkCast.is_colliding():
		print("bonk")
		if $SoundEffects/Bonk.is_playing() == false:
			$SoundEffects/Bonk.play()
		
	
	if is_on_floor():
		inAir = false
		xval = speed
		jumpWindow = jumpWindowUSSY
	else:
		inAir = true
		xval = speedAir
		if velocity.y > 0:
			$AnimatedSprite.play("fall")
		else:
			$AnimatedSprite.play("jump")
	
	# FIXME: Least schizophrenic David code
	if Input.is_action_just_pressed("jump"):
		jumpBuffer = jumpBuffUSSY
	# NOTE: Testing jump height shit ong, if this doesn't work with coyote jump (I haven't checked I've been awake for nearly 20 hours now) then CoolingTool will do it for me yubbayubbayubba...
	# it do be working with the coyote jump
	if Input.is_action_just_pressed("jump") && velocity.y < 0:
		velocity.y = 0

	if Input.is_action_just_released("jump") && velocity.y < 0 && canShortJump:
		velocity.y *= jumpDiminish
		canShortJump = false
	
	if Input.is_action_just_pressed("attack"):
		if !is_instance_valid(loadyoyo):
			loadyoyo = preload("res://src/Yoyo/Yoyo.tscn").instance()
			loadyoyo.startpos = global_position
			loadyoyo.vector = yoyoVector.normalized()
			add_child(loadyoyo)
			loadyoyo.yoyo_ready()
			$SoundEffects/YoyoThrow.play()
		
	if Input.is_action_just_pressed("ui_down") && is_on_floor() == false:
		velocity.y = fastfall

	jumpBuffer -= delta
	jumpWindow -= delta
	if jumpBuffer > 0 && jumpWindow > 0:
		if $SoundEffects/Jump.playing == false:
			$SoundEffects/Jump.play()
		jumpWindow = 0
		jumpBuffer = 0
		velocity.y = -JUMPFORCE
		if !Input.is_action_pressed("jump"):
			# short jump via jump buffer
			if canShortJump:
				velocity.y *= jumpDiminish
				canShortJump = false
		else:
			canShortJump = true
	
	velocity = move_and_slide(velocity, UP)

func wavedash():
	velocity.x *= perfect_wavedash_modifier 
