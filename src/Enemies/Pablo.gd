extends KinematicBody2D


enum{IDLE, JUMP, HURT, SHOOT};

var velocity = Vector2.ZERO
var state = IDLE;
var health : int = 10;
var wait_timer : float = 0;
var gravity : float = 130;
var hurt_gravity : float = 200;
var speed : float = 120;
var hurt_speed : float = 300
var can_hurt : bool = true;

var max_fall_speed : float = 300;

var jump_force : float = 6000;

onready var bullet_cheese
onready var pablo : AnimatedSprite = $AnimatedSprite
onready var hurt_particle := preload("res://src/Yoyo/HitParticles.tscn")
onready var cheese_particle := preload("res://src/Yoyo/BrotherParticle.tscn")
onready var left_raycast : RayCast2D = $DreamCasts/left
onready var player = get_tree().get_root().get_node("WLA00/Player")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _physics_process(delta):
	if Globals.boss_unlock:
		$ProgressBar.value = health * 10
		velocity = move_and_slide(velocity, Vector2.UP)
		if health >= 5:
			velocity.y += gravity * delta
		else:
			velocity.y += hurt_gravity * delta
		
		
		if velocity.y > max_fall_speed:
			velocity.y = max_fall_speed;
		
		#NOTE: Yubba Yubba
		if player.position.x > position.x:
			pablo.scale.x = -1
			$Gunhand1.scale.x = -1
			$Gunhand2.scale.x = -1
		else:
			$Gunhand1.scale.x = 1
			$Gunhand2.scale.x = 1
			pablo.scale.x = 1
		
		wait_timer += delta
		
		#NOTE: State shit lol
		match state:
			IDLE:
				#FIXME: There's gotta be a better way of doing this... too bad it's the end of the jam :trollface:
				$Gunhand1.visible = true
				$Gunhand2.visible = true
				pablo.play("idle")
				
				#NOTE: Decides which state Pablo goes into
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
				if is_on_floor():
					state = IDLE
					$SoundEffects/Land.play()
					Globals.camera.shake(0.25,1)
					
				pablo.play("jump")
				
			SHOOT:
				$Gunhand1.visible = true
				$Gunhand2.visible = true
				if !is_instance_valid(bullet_cheese):
					$SoundEffects/Shoot.play()
					bullet_cheese = preload("res://src/Enemies/Expired Cheese.tscn").instance()
					if health <= 5:
						bullet_cheese.speed = speed * 1.2
					add_child(bullet_cheese)
					
					var bullet_rotation = self.global_position.direction_to(player.global_position).angle()
					bullet_cheese.rotation = bullet_rotation
				else:
					state = IDLE
					
				
			HURT:
				pablo.play("ow")
				velocity.x = lerp(velocity.x, 0, 0.3)
				if health <= 0:
					velocity.x = 0;
					player._brother_freeze(0.4, 1)
					var effect := hurt_particle.instance()
					effect.global_position = self.global_position
					get_tree().current_scene.add_child(effect)
					

func jump(delta):
	state = JUMP
	velocity.y = -jump_force * delta;
	$Gunhand1.visible = false
	$Gunhand2.visible = false
	if health <= 5:
		if player.position.x > position.x:
			velocity.x += hurt_speed
		if player.position.x < position.x:
			velocity.x -= hurt_speed
	else:
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
		$blink.play("blink")
		health -= 1
		state = HURT
		var effect := hurt_particle.instance()
		effect.global_position = self.global_position
		get_tree().current_scene.add_child(effect)
		$SoundEffects/Ow.play()
		yield(get_node("AnimatedSprite"), "animation_finished")
		if health <= 0:
			$SoundEffects/OOG.play()
			yield(get_node("SoundEffects/OOG"), "finished")
			queue_free()
			Transition.transition_in(get_tree().current_scene, "res://gameend.tscn")
		else:
			can_hurt = true
			$Gunhand1.visible = true
			$Gunhand2.visible = true
			state = IDLE

func _on_Area2D_body_entered(body):
	if !state == HURT:
		if health != 0:
			if body.get_collision_layer_bit(15):
					body.damage(position)


func _on_AnimatedSprite_animation_finished(anim_name):
	if anim_name == "ow":
		can_hurt = true
