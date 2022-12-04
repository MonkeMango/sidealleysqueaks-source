extends KinematicBody2D

const UP := Vector2(0, -1)

export var gravity:float = 10
export var maxfallspeed:float = 340
export var numsteps:int = 16
export var speed:float = 20
export var turnprecision:float = .5e-2

var velocity := Vector2()
var targetxspeed:float = 0
var steps:int = numsteps
var dead:bool = false
var startedwalk:bool = false
onready var ready:bool = true

onready var collider := $CollisionShape2D
onready var sprite := $CollisionShape2D/AnimatedSprite
onready var wallcast := $CollisionShape2D/Wallcast

# Player node grabber
onready var player = get_parent().get_parent().get_node("Player")

#preload particle
onready var hurt_particle := preload("res://src/Yoyo/HitParticles.tscn")

#on ready????
func _ready():
	wallcast.add_exception(self)
	sprite.play('walk')

func _physics_process(delta):
	# strokin...s
	if not dead:
		velocity.x = lerp(velocity.x, targetxspeed, 1 - pow(turnprecision, delta))
	elif dead:
		rotation += deg2rad(270) * delta
	velocity.y = min(velocity.y + gravity, maxfallspeed)
	velocity = move_and_slide(velocity, UP)

func _frame_changed():
	if ready and sprite.animation == 'walk' and not dead:
		if numsteps >= 0 and steps > numsteps * 2 or smart_turn():
			steps = 0
			collider.scale.x *= -1
			if !startedwalk:
				sprite.play('turn')
		else:
			startedwalk = false
		steps += 1 
		targetxspeed = speed * -sign(collider.scale.x)

func _animation_finished():
	if sprite.animation != 'walk' and not dead:
		sprite.play('walk')
		startedwalk = true

# for blueberry kankitty to extend
func smart_turn() -> bool:
	return wallcast.is_colliding()

func yoyo_hit(vector:Vector2):
	if not dead:
		dead = true
		$SoundEffects/Ow.play()
		sprite.play('die')
		collision_layer = 0
		collision_mask = 0
		velocity += vector * 100;
		velocity.y -= 200
		var effect := hurt_particle.instance()
		effect.global_position = global_position
		get_tree().current_scene.add_child(effect)
		return true
	return false

func _on_screen_exited():
	if dead:
		print('she dead')
		queue_free()


func _on_Area2D_body_entered(body):
	if body.name == "Player":
		player.damage(position)
		
