extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var travel = 50
var pushback = -.35
var distance = travel
var speed = travel * 0.1
var vector:Vector2

func distance_to_position():
	position.x = vector.x * distance
	position.y = vector.y * distance

# Called when the node enters the scene tree for the first time.
func _physics_process(_delta):
	speed += pushback
	distance += speed
	if distance < 0:
		queue_free()
	else:
		distance_to_position()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
