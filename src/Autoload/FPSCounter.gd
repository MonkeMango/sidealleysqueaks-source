extends Node2D

func _process(delta):
	$CanvasLayer/Label.text = str(Engine.get_frames_per_second())
	
	if Engine.get_frames_per_second() < 30:
		$CanvasLayer/Label.self_modulate = Color(255, 0, 0, 1)
	else:
		$CanvasLayer/Label.self_modulate = Color(255, 255, 255, 1)
