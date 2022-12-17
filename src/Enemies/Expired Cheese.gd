extends Area2D

onready var pablo = get_tree().get_root().get_node("WLA00/Enemies/Pablo")

var hurt_speed : float = 1000
var speed : float = 500


func _physics_process(delta):
	var direction = Vector2.RIGHT.rotated(rotation)
	if pablo.health <= 5:
		global_position += hurt_speed * direction * delta
	else:
		global_position += speed * direction * delta


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_BulletCheese_body_entered(body):
	if body.has_method("damage"):
		body.damage(position, 1, 150, true)
		queue_free()
