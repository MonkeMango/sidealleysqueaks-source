extends CPUParticles2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


func _ready():
	emitting = true


func _process(delta):
	if !emitting:
		queue_free()
