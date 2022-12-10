extends "res://src/Enemies/Kankitty.gd"

onready var start:float = position.y
var amplitude:float = .2
var force:float = 1.5
var maxflyspeed:float = 30
var deadmaxflyspeed:float = 300

func _physics_process(delta):
	var flyforce:float = 0
	if not dead and position.y > start + amplitude:
		flyforce = ((start + amplitude) - position.y) * force
	velocity.y = max(velocity.y + flyforce, -(deadmaxflyspeed if dead else maxflyspeed))
	._physics_process(delta)
