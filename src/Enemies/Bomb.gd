extends RigidBody2D

export var deattached:bool = false

func _ready():
	add_collision_exception_with(get_parent().get_node("Mosquito"))

func _on_body_entered(body):
	queue_free()
