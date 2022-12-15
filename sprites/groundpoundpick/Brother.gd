extends Area2D

onready var player = get_parent().get_parent().get_node("Player");

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	if Globals.breed_unlock:
		queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_body_entered(body):
	if body.name == "Player":
		player.power_up.play()
		player.blink.play("blink (copy)")
		Globals.breed_unlock = true
		queue_free()
