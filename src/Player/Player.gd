extends KinematicBody2D
const UP := Vector2(0, -1)
var inAir = false

#i'm gonna blow my brains out
const FLOOR_NORMAL = Vector2.UP
const SNAP_DIRECTION = Vector2.DOWN
const SNAP_LENGTH = 10.0
const FLOOR_MAX_ANGLE = deg2rad(40)
var snap_vector = SNAP_DIRECTION * SNAP_LENGTH
var normalGravity = 100
export var speed = 150
export var accel = 10
var friction = 10
var xval = speed
var health : int = 3
var ouch_timer
var ow = false
# FIXME: For the full release we're gonna need a state machine so fucking badly it's not even funny 💀
# NOTE: Basically this fixes the idle animations overriding the attack animation
var attack : bool = false
var hurt : bool = false

#air related properties
var fastfall = 1800
export var MAXFALLSPEED = 220
var speedAir = 120
export var jumpPeak : float = 0.3
export var jumpHeight : float = 70
var jumpBuffer:float
export var jumpBuffUSSY:float = 0.12
var jumpWindow:float # coyote jump variable
export var jumpWindowUSSY:float = 0.2
export var jumpDiminish:float = 0.6 # what to multiply the velocity when jump is let go early
var canShortJump:bool = true # (can short jump currently)
var perfect_wavedash_modifier = 1.11
var pounding : bool = false

var velocity := Vector2()
var yoyoSavedX:float = 1
var yoyoVector := Vector2(yoyoSavedX, 0)
var isWalking:bool = false
onready var gravity:float = (2*jumpHeight)/pow(jumpPeak,2)
onready var JUMPFORCE:float = gravity * jumpPeak

# Oog....
onready var loadyoyo : Area2D
onready var blink = $blink

# NOTE: i will be replacing this extremely dogshit implementation soon™
var sprite_direction = true

# TODO: put this shit into a state machine :f4rplol:

func _ready():
	$AnimatedSprite.play("idle")

func _physics_process(delta):
	#jelqin...
	if !pounding:
		velocity.y += gravity * delta

	if health <= 0:
		death()
	#do not move when hitting the reset button!!!!
	if OS.is_debug_build():
		if Input.is_action_pressed("reset"):
			 var _success = get_tree().reload_current_scene()
	
	if sprite_direction:
		$AnimatedSprite.scale.x = -1
	else:
		$AnimatedSprite.scale.x = 1
	
	if velocity.y > MAXFALLSPEED:
		velocity.y += MAXFALLSPEED * delta
	
	isWalking = true

	#NOTE: I'm so sorry to Cooling and any other programmers who come here to look at this shit 😭😭😭😭😭😭
	if !pounding:
		if !hurt:
			if Input.is_action_pressed("ui_right"):
				velocity.x = min(velocity.x + accel, xval)
				$AnimatedSprite.play("run")
				sprite_direction = true
				yoyoSavedX = 1
				attack = false
			elif Input.is_action_pressed("ui_left"):
				if !hurt:
					$AnimatedSprite.play("run")
				velocity.x = max(velocity.x - accel, -xval)
				sprite_direction = false
				yoyoSavedX = -1
				attack = false
			else:
				if !attack:
					$AnimatedSprite.play("idle")
				velocity.x = lerp(velocity.x, 0, 0.3)
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
			
			if is_on_floor():
				inAir = false
				xval = speed
				jumpWindow = jumpWindowUSSY
			else:
				inAir = true
				xval = speedAir
				attack = false
				if velocity.y > 0:
					$AnimatedSprite.play("fall")
				else:
					$AnimatedSprite.play("jump")
	
	if $BonkCast.is_colliding():
		var hit_collider = $BonkCast.get_collider()
		if hit_collider is TileMap:
			print("bonk")
			if $SoundEffects/Bonk.is_playing() == false:
				$SoundEffects/Bonk.play()
		
	

	
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
		if !hurt:
			if !is_instance_valid(loadyoyo):
				loadyoyo = preload("res://src/Yoyo/Yoyo.tscn").instance()
				loadyoyo.startpos = $AnimatedSprite/YoyoHand.global_position
				loadyoyo.vector = yoyoVector.normalized()
				add_child(loadyoyo)
				loadyoyo.yoyo_ready()
				$SoundEffects/YoyoThrow.play()
				attack = true
				if !hurt:
					$AnimatedSprite.play("throw")
		

	
	jumpBuffer -= delta
	jumpWindow -= delta
	if jumpBuffer > 0 && jumpWindow > 0:
		snap_vector = Vector2.ZERO
		move_and_slide_with_snap(velocity, Vector2.UP)
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
	
	velocity.y = move_and_slide_with_snap(velocity, snap_vector, FLOOR_NORMAL, true, 4, 60).y

	if is_on_floor() and snap_vector == Vector2.ZERO:
		reset_snap()

func reset_snap():
	snap_vector = SNAP_DIRECTION * SNAP_LENGTH

func _brother_freeze(timeScale, duration):
	Engine.time_scale = timeScale
	yield(get_tree().create_timer(duration * timeScale), "timeout")
	Engine.time_scale = 1.0

func groundpussy():
	pounding = true
	velocity.y = 0
	$AnimatedSprite.play("spin")
	yield(get_tree().create_timer(0.3), "timeout")
	velocity.y = fastfall
	yield(get_node("AnimatedSprite"), "animation_finished")
	#FIXME: holy fuck I'm gonna hang myself with a belt
	_brother_freeze(0.4, 0.4)
	Globals.camera.shake(0.25,1)
	$SoundEffects/Fart.play()
	$AnimatedSprite.play("groundpound")
	yield(get_tree().create_timer(0.05), "timeout")
	$AnimatedSprite.play("idle")
	pounding = false
		


func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "throw":
		attack = false
	if $AnimatedSprite.animation == "hurt":
		hurt = false

func _on_timer_timeout():
	ow = false
func death(falling : bool = false):
	var scene_death = get_tree().current_scene.filename
	print(scene_death)
	$Camera2D.clear_current()
	Transition.transition_in(scene_death)

	if falling:
		if $SoundEffects/Falling.playing == false:
			$SoundEffects/Falling.play()

	
#TODO: This shit fucking sucks 😭😭

#Taking damage lmao
#--------------------------------------------------------
#point_from_knockback is the amount of health taken from the player
#amount is where or what you get knocked by
#knockback_force is the amount of knockback you take
#--------------------------------------------------------
func damage(point_from_knockback : Vector2, amount : int = 1, knockback_force : float = 100):
	#NOTE: Timer shit this is so bad
	if !hurt:
		ouch_timer = Timer.new()
		ouch_timer.connect("timeout",self,"_on_timer_timeout")
		ouch_timer.set_wait_time(1)
		add_child(ouch_timer)
		ouch_timer.start()
		#NOTE: hurt is for the animation so it doesn't get interrupted	
		#NOTE: ow decides if the player plays the hurt animation and decides if the hud will shake. i'm also probably gonna have it do something else in the future idfk 💀 
		hurt = true
		ow = true

		health -= amount

		#stuff that gets printed
		if OS.is_debug_build():
			print("health = %s" % [health])
			print("hurt = %s" % [hurt])
		
		#FIXME: This is a shit ass implementation of knockback I can do a lot better then this dawg...
		velocity = (Vector2(1,0).rotated(position.angle_to_point(point_from_knockback))*knockback_force)
		velocity.y = velocity.y/2
		velocity.y -= 50

		#NOTE: screen... SHIT!!!!
		_brother_freeze(0.4, 0.5)
		Globals.camera.shake(0.25,1)

		blink.play("blink")
		$SoundEffects/Ow.play()
		$AnimatedSprite.play("hurt")


func _on_owie_body_entered(body:Node):
	if pounding:
		if body.has_method('yoyo_hit'):
			body.yoyo_hit(velocity)
