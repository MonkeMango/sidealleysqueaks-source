extends CanvasLayer


signal transition_in_done
signal transition_out_done
export (String, FILE, "*.tscn") var target_scene
onready var anim = $ColorRect/AnimationPlayer

func _ready():
	anim.play("trans_out")

func transition_in(_next_scene := target_scene):
	anim.play("trans_in")
	yield(anim, "animation_finished")
	# Changes the scene
	get_tree().change_scene(_next_scene)
	anim.play("trans_out")



func transition_out():
	anim.play("trans_out")



