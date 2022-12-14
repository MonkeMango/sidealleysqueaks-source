extends Area2D


# Declare brother variables here. Examples:
# var proudness = 2
# func are_you_proud_of_me() -> bool:
# 	return proudness > 0

enum {
	FORWARD,
	DOWNWARD,
	DIAGONAL,
	UNHANDLED
}

var air_state := UNHANDLED
var travel:float = 100
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
onready var hand = player.get_node('AnimatedSprite/YoyoHand')
onready var string = $Line2D
onready var strshape = $CollisionLine2D

func yoyo_ready():
	#print("yoyoVector.y = %s yoyoVector.x = %s" % [player.yoyoVector.y, player.yoyoVector.x])	
	if vector.y > 0 and vector.x == 0:
		air_state = DOWNWARD
	orientation = vector.angle()
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
	stringthestring()

func stringthestring():
	string.set_point_position(1, hand.global_position - global_position)
	strshape.shape.b = hand.global_position - global_position

# Called when the node enters the scene tree for the first time. i shit myself ngl
func _physics_process(_delta):
	speed += pushback
	distance += speed * speedmodifer
	if distance < 0:
		queue_free()
	else:
		distance_to_position()

func _on_yoyo_body_entered(body):

	var yoyo_platform : bool = false

	if body.has_method('platform_hit'):	
		yoyo_platform = true
		body.platform_hit()
		queue_free()

	if body.get_collision_layer_bit(1): # enemies
		if body.has_method('yoyo_hit'):		
			if body.yoyo_hit(vector):
				player._brother_freeze(0.1, 0.25)
				Globals.camera.shake(0.25,1)
	elif body.get_collision_layer_bit(0): # ground
		#GAY PORN!!!!
		match air_state:
			DOWNWARD:
				if !yoyo_platform:
					if player.is_on_floor() == false:
						player.groundpussy()
						queue_free()

# Called every frame. 'Fuck Lois...' is the elapsed time since the previous frame.
#func _process(lois):
#	SHIT!!!
