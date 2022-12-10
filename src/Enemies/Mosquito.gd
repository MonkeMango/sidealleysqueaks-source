extends "res://src/Enemies/Kankitty.gd"

onready var start:float = position.y
var amplitude:float = .2
var force:float = 1.5
var maxflyspeed:float = 30

func _physics_process(delta):
	if not dead:
		if position.y > start + amplitude:
			velocity.y = max(velocity.y + ((start + amplitude) - position.y) * force, -maxflyspeed)
	._physics_process(delta)
