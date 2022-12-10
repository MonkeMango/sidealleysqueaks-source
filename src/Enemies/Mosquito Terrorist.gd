extends "res://src/Enemies/Mosquito.gd"

onready var remote2d = $CollisionShape2D/RemoteTransform2D
onready var bomb = get_parent().get_node("Bomb")

func deattach():
	if not bomb.deattached:
		remote2d.remote_path = @""
		bomb.visible = true
		bomb.scale.y = abs(bomb.scale.y)
		bomb.deattached = true

func yoyo_hit(vector:Vector2):
	var ret = .yoyo_hit(vector)
	if ret: deattach()
	return ret
