extends CanvasLayer

onready var cheese = $cheese
onready var cheeselabel = $CheeseLabel

# Player node grabber
onready var player = get_parent().get_parent().get_node("Player")

var shake_amount : float = 1.0

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.


func _physics_process(_delta):

	if player.ow:
		set_offset(Vector2(rand_range(-1.0, 1.0) * shake_amount, rand_range(-1.0, 1.0) * shake_amount))


	cheeselabel.text = String(player.cheese)

	match player.health:
		3:
			cheese.play("full_health")
		2:
			cheese.play("health_2")
		1:
			cheese.play("health_3")
			if !player.ow:
				set_offset(Vector2(rand_range(-1.0, 1.0) * 0.3, rand_range(-1.0, 1.0) * 0.3))
	
