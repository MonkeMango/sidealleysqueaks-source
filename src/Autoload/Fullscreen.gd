extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


func _physics_process(_delta):
	if Input.is_action_just_pressed("toggle_fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen
