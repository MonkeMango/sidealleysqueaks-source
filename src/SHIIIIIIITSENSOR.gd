extends Area2D


# Declare member variables here. Examples:
onready var player = get_tree().get_root().get_node("WLA00/Player")

# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_body_entered(body:Node):
	if body.name == "Player":
		player._enter_boss();
		$SHIIIIIIIIT.play()
		Globals.boss_unlock = true;

