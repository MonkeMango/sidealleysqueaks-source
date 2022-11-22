extends Node

onready var loadyoyo = preload("res://src/Yoyo/Yoyo.tscn")
# Declare member variables here. Examples:
# Yubbayubba...

func _process(delta):
	if Input.is_action_just_pressed("attack"):
		var yoyo = loadyoyo.instance()
		yoyo.global_position = $YoyoPos.position
		get_parent().get_parent().add_child(yoyo)
		yoyo.set_as_toplevel(true)
