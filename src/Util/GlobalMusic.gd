extends Node

onready var level_name = get_tree().current_scene.name
onready var audio_file = load("res://assets/%s/music/%s.mp3" % [level_name, level_name])
onready var music_player : Node = $AudioStreamPlayer


func _ready():
	if audio_file != null:
		music_player.stream = audio_file
		music_player.stream.set_loop(true)
		music_player.volume_db = -12
		music_player.play()

# func _physics_process(delta):
# 	print("audio file being played: %s" % [audio_file])

func play(new_song : String):
	music_player.stream = new_song
