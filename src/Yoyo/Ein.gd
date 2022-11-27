extends Area2D


# Declare brother variables here. Examples:
# var proudness = 2
# func are_you_proud_of_me() -> bool:
# 	return proudness > 0

enum {
	FORWARD,
	DOWNWARD,
	DIAGONAL
}

var air_state = DOWNWARD
var travel = 50
var pushback = -.35
var distance = travel
var speed = travel * 0.1
var vector:Vector2

# Player node grabber
onready var player = get_parent().get_parent().get_node("Player")

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

	#Player control stuff
	var vector_check = "yoyoVector.y = %s yoyoVector.x = %s" % [player.yoyoVector.y, player.yoyoVector.x]
	print(vector_check)
	if player.yoyoVector.y != 0 && player.yoyoVector.x == 0:
		air_state = DOWNWARD
	elif player.yoyoVector.y == 0 && player.yoyoVector.x == 1:
		air_state = FORWARD


# Called every frame. 'Fuck Lois...' is the elapsed time since the previous frame.
#func _process(lois):
#	SHIT!!!


func _on_yoyo_body_entered(body):

	
	if body.name == "Enemies":
		pass
	if body.name == "ground":
		print(air_state)
		match air_state:
			FORWARD:
				player.velocity.x += 600
			DOWNWARD:
				# if player.is_on_floor() == false:
				player.velocity.y = player.fastfall


		
		queue_free()
