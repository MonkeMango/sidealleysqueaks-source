extends Node


# Declare member variables here. Examples:
# var ein = 1
# var b = "oles..."


func _physics_process(_delta):
	if Input.is_action_just_pressed("toggle_fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen
