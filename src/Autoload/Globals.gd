extends Node


var camera = null

var spawn_point = Vector2()

var buttonTimer

var checkpoint_check : bool = false

var breed_unlock : bool = false

func update_spawn(new_point):
	spawn_point = new_point
	yield(get_tree().create_timer(0.05), "timeout")
	checkpoint_check = true
	
#NOTE: I am geniunely mentally ill
