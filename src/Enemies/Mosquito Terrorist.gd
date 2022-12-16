extends "res://src/Enemies/Mosquito.gd"

onready var remote2d = $CollisionShape2D/RemoteTransform2D
onready var bomb = get_parent().get_node("Bomb")

func deattach():
	if is_instance_valid(bomb) and not bomb.deattached:
		remote2d.remote_path = @""
		bomb.visible = true
		bomb.deattached = true

func yoyo_hit(vector:Vector2):
	deattach()

	return .yoyo_hit(vector)


func _on_spotlight_body_entered(body):
	if body.name.to_lower() == 'player': # bbb bo bod body dot dotd ot nnnnname????!!>!
		deattach()
		WALK = 'fly'
		sprite.play(WALK)
