extends RigidBody2D

export var deattached:bool = false

func _on_body_entered(body):
	if body.get_collision_layer_bit(15) and !body.pounding:
		body.damage(position)
