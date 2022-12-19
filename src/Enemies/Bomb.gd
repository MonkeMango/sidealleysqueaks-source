extends RigidBody2D

export var deattached:bool = false

onready var boom = get_parent().get_node("Explosion")
onready var brother = get_parent().get_node("Mosquito/SoundEffects/ExplosionSound")

func _ready():
	add_collision_exception_with(get_parent().get_node("Mosquito"))
	boom.set_process(false)

func _process(_delta):
	sleeping = not deattached

func _on_body_entered(_body):
	if deattached:
		boom.get_node("CPUParticles2D").emitting = true
		brother.play()
		boom.monitoring = true
		boom.start_party = true
		queue_free()
