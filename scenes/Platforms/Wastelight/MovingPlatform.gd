extends StaticBody2D


enum {
	PLATFORMFORWARD
	PLATFORMBACK
}

#state controller
var platform_state := PLATFORMFORWARD

var if_hit: bool = false;
var speed : float = 0;
var distance : float = 0;
var vector:Vector2;

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
