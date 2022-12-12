extends Area2D

export var varname:String = 'cogs'

onready var start := Vector2(position.x, position.y)

func _process(_delta):
	position.y = start.y + sin(OS.get_ticks_msec() * .004) * 1.2

func collected(body):
	var current = body.get(varname)
	if current != null:
		body.set(varname, current + 1)
		# TODO: ad cool particle
		queue_free()

func _on_body_entered(body):
	if body.get_collision_layer_bit(15):
		collected(body)
