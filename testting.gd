extends Node2D


onready var diamond_trans = $trans


# Called when the node enters the scene tree for the first time.
func _ready():
	diamond_trans.transition_out()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
