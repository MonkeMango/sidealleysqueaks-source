extends CanvasLayer


signal transition_in_done
signal transition_out_done

onready var anim = $ColorRect/AnimationPlayer


func transition_in():
	anim.play("trans_in")

func transition_out():
	anim.play("trans_out")



func _on_AnimationPlayer_animation_finished(anim_name:String):
	if anim_name == "trans_in":
		emit_signal("transition_in_done")
	elif anim_name == "trans_out":
		emit_signal("transition_out_done")
