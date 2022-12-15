extends KinematicBody2D


enum{IDLE, JUMP, HURT, SHOOT};

var velocity = Vector2.ZERO
var state = IDLE;
var health : int = 10;
var wait_timer : float = 0;
var gravity : float = 100;
var speed : float = 120;
var can_hurt : bool = true;

var max_fall_speed : float = 100;

var jump_force : float = 6000;

onready var bullet_cheese
onready var pablo : AnimatedSprite = $AnimatedSprite
onready var left_raycast : RayCast2D = $DreamCasts/left
onready var player = get_parent().get_parent().get_node("Player")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _physics_process(delta):
	if Globals.boss_unlock:
		velocity = move_and_slide(velocity, Vector2.UP)
		velocity.y += gravity * delta
		
		
		if velocity.y > max_fall_speed:
			velocity.y = max_fall_speed;
		
		if player.position.x > position.x:
			pablo.scale.x = -1
			$Gunhand1.scale.x = -1
			$Gunhand2.scale.x = -1
		else:
			$Gunhand1.scale.x = 1
			$Gunhand2.scale.x = 1
			pablo.scale.x = 1
		
		wait_timer += delta
		
		print ("wait timer... %s" % [wait_timer])
		
		print (is_on_floor())
		match state:
			IDLE:
				pablo.play("idle")
				var randomNumber = rand_range(0,1)
				velocity.x = lerp(velocity.x, 0, 0.3)
				if wait_timer >= 2.6:
					if is_on_floor():
						if randomNumber <= 0.50: # takes 50%
							$SoundEffects/PABLO.play()
							jump(delta)
							state = JUMP
						else:
							$SoundEffects/FELIPE.play()
							state = SHOOT
					wait_timer = 0
			JUMP:
				print("velocity.y = %s" % [velocity.y])
				if is_on_floor():
					state = IDLE
					$SoundEffects/Land.play()
					Globals.camera.shake(0.25,1)
					
				pablo.play("jump")
				
			SHOOT:
				if !is_instance_valid(bullet_cheese):
					bullet_cheese = preload("res://src/Enemies/Expired Cheese.tscn").instance()
					add_child(bullet_cheese)
					
					var bullet_rotation = self.global_position.direction_to(player.global_position).angle()
					bullet_cheese.rotation = bullet_rotation
				else:
					state = IDLE
					
				
			HURT:
				pablo.play("ow")

func jump(delta):
	state = JUMP
	velocity.y = -jump_force * delta;
	if player.position.x > position.x:
		velocity.x += speed
	if player.position.x < position.x:
		velocity.x -= speed
	$SoundEffects/Jump.play()
#	velocity.x -= 20 * delta;

func yoyo_hit(vector:Vector2):
	if !state == JUMP and can_hurt:
		can_hurt = false
		$Gunhand1.visible = false
		$Gunhand2.visible = false
		velocity.x = lerp(velocity.x, 0, 0.3)
		health -= 1
		state = HURT
		$SoundEffects/Ow.play()
		yield(get_node("AnimatedSprite"), "animation_finished")
		if health <= 0:
			queue_free()
		else:
			can_hurt = true
			$Gunhand1.visible = true
			$Gunhand2.visible = true
			state = IDLE

func _on_Area2D_body_entered(body):
	if body.get_collision_layer_bit(15):
		if !body.pounding:
				body.damage(position)
