extends "res://src/Enemies/Kankitty.gd"

onready var floorcast := $CollisionShape2D/Floorcast

func smart_turn() -> bool:
	return .smart_turn() or !floorcast.is_colliding()
