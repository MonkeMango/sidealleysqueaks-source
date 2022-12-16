extends Area2D

export var start_party = false

onready var party = $CPUParticles2D

func _process(_delta):
	monitoring = party.emitting
	
	# this cuts off the particles animation grrrrr
	#if monitoring == false and start_party == true:
	#	queue_free()

func _on_body_entered(body):
	if body.has_method('damage'):
		body.damage(global_position)
	if body.has_method('yoyo_hit'):
		body.yoyo_hit((body.global_position - global_position).normalized())
