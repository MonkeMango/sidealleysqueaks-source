extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalMusic.play("res://scenes/Menus/Title Screen/credits_theme.mp3")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Credits":
		Transition.transition_in(self, "res://mainmenu.tscn");
		GlobalMusic.music_player.stop();
		Globals.reset_everything();
