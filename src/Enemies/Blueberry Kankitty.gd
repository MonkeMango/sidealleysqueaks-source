extends "res://src/Enemies/Kankitty.gd"

# dreamcast more like... yubbayubba...
#onready var floorcast := $CollisionShape2D/Floorcast

func smart_turn() -> bool:
	return .smart_turn() or (is_on_floor() and !floorcast.is_colliding())
