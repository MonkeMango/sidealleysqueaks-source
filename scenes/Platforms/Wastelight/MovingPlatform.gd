extends KinematicBody2D


enum {
	#        
	MOMMY
	PLATFORMFORWARD
	PLATFORMBACK
}

#state controller
var platform_state := MOMMY

var if_hit: bool = false;
export var speed : float = 5;
const ACCELERATION = 500
var distance : float = 20;
var vector:Vector2;
export(NodePath) onready var pos_1 = get_node_or_null(pos_1)
export(NodePath) onready var pos_2 = get_node_or_null(pos_2)

func _ready():
	position = pos_1.global_position

func _physics_process(delta):

	# if Input.is_action_just_pressed("ui_accept"):
	# 	yoyo_hit()
	match platform_state:
		PLATFORMFORWARD:
			position = position.linear_interpolate(pos_2.position, delta * speed)
		PLATFORMBACK:
			position = position.linear_interpolate(pos_1.position, delta * speed)


func platform_hit():
	print (platform_state)
	match platform_state:
		MOMMY:
			platform_state = PLATFORMFORWARD
		PLATFORMFORWARD:
			if position.is_equal_approx(pos_2.position):
				platform_state = PLATFORMBACK
		PLATFORMBACK:
			if position.is_equal_approx(pos_1.position):
				platform_state = PLATFORMFORWARD
			
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
