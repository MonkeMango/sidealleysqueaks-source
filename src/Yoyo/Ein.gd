extends Area2D


# Declare brother variables here. Examples:
# var proudness = 2
# func are_you_proud_of_me() -> bool:
# 	return proudness > 0

var travel = 40
var pushback = -.35
var distance = travel
var speed = travel * 0.1
var vector:Vector2

func distance_to_position():
	position.x = vector.x * distance
	position.y = vector.y * distance

# Called when the node enters the scene tree for the first time. i shit myself ngl
func _physics_process(_delta):
	speed += pushback
	distance += speed
	if distance < 0:
		queue_free()
	else:
		distance_to_position()

# Called every frame. 'Fuck Lois...' is the elapsed time since the previous frame.
#func _process(lois):
#	SHIT!!!
