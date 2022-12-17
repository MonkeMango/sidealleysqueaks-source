extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():	
	get_tree().set_current_scene(self)
	if !GlobalMusic.music_player.is_playing():
		GlobalMusic.play("res://assets/WLA00/music/WLA00.mp3")
		GlobalMusic.music_player.volume_db = -8

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
