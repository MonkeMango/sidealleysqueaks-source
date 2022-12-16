extends Area2D


var speed : float = 700

onready var player = get_parent().get_parent().get_node("Player")

func _physics_process(delta):
	var direction = Vector2.RIGHT.rotated(rotation)
	global_position += speed * direction * delta
	


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_BulletCheese_body_entered(body):
	if body.has_method("damage"):
		body.damage(position)
