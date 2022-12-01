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

var air_state := DOWNWARD
var travel:float = 75
var pushback:float = -.35

var startpos:Vector2
var vector:Vector2
var orientation:float = 0
var speed:float = 0
var speedmodifer:float = 1
var peakdistance:float = 0
var distance:float = 0
var hit:bool = false

# Player node grabber
onready var player = get_parent().get_parent().get_node("Player")

func yoyo_ready():
	orientation = vector.angle()
	$Cast.cast_to.x = travel
	$Cast.rotation = orientation
	$Cast.force_raycast_update()
	var polo = $Cast.get_collider()
	if polo:
		#travel = startpos.distance_to($Cast.get_collision_point())
		_on_yoyo_body_entered(polo)
	speed = sqrt(travel * 0.1)
	speedmodifer = 1
	distance = travel * 0.9
	peakdistance = distance
	distance_to_position()

func distance_to_position():
	peakdistance = max(distance, peakdistance)
	var p := startpos + Vector2(vector.x * peakdistance, vector.y * peakdistance)
	if peakdistance > distance:
		# boy what the hellllll oh my god no wayaaeaaeaaaaaeeeaaaaay
		p = p.linear_interpolate(player.global_position, 1 - distance/peakdistance)
		speedmodifer = 1/(p.distance_to(player.global_position)/distance)
	global_position = p

# Called when the node enters the scene tree for the first time. i shit myself ngl
func _physics_process(_delta):
	speed += pushback
	distance += speed * speedmodifer
	if distance < 0:
		queue_free()
	else:
		distance_to_position()

	# Player control stuff
	#var vector_check = "yoyoVector.y = %s yoyoVector.x = %s" % [player.yoyoVector.y, player.yoyoVector.x]
	#print(vector_check)
	if vector.y > 0 && vector.x == 0:
		air_state = DOWNWARD

func layer(flag, i) -> bool:
	# I FUCKING LOVE BINARY FLAGS!!!!!
	return flag & (1 << (i-1)) != 0 

func _on_yoyo_body_entered(body):
	var layers = body.get_collision_layer()
	if layer(layers, 2): # enemies
		pass
	elif layer(layers, 1): # ground
		#GAY PORN!!!!
		match air_state:
			DOWNWARD:
				if player.is_on_floor() == false:
					player.velocity.y = player.fastfall
					player.velocity.x = 0
					queue_free()

# Called every frame. 'Fuck Lois...' is the elapsed time since the previous frame.
#func _process(lois):
#	SHIT!!!
