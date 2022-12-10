extends "res://src/Enemies/Mosquito.gd"

onready var remote2d = $CollisionShape2D/RemoteTransform2D
onready var bomb = get_parent().get_node("Bomb")

func _ready():
	._ready()
	bomb.visible = false

func yoyo_hit(vector:Vector2):
	var ret = .yoyo_hit(vector)
	if ret:
		bomb.visible = true
		bomb.scale.y = abs(bomb.scale.y)
		remote2d.remote_path = @""
	return ret
