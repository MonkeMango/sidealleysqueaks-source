extends Node


var camera = null

var spawn_point = Vector2()

var checkpoint_check : bool = false

func update_spawn(new_point):
	spawn_point = new_point
	checkpoint_check = true
