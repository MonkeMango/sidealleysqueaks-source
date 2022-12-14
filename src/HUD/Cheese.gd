extends Area2D

#NOTE: player preload
onready var player = get_parent().get_parent().get_node("Player");




func _on_Cheese_body_entered(body):
	if body.name == "Player":
		player.yummy.play();
		player.cheese += 1;
		player.brother_meter += 1;
		queue_free();
		if player.brother_meter >= 10 and player.health < 3:
			player.health_up.play();
			player.brother_meter = 0;
			player.health += 1;

