extends RayCast2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(_delta):
	if is_colliding():
		$SoundEffects/Bonk.play()
		xddddsdsdas:
#		var hit_collider = get_collider()
#		if hit_collider is TileMap:
#			var tilemap = hit_collider
#			var hit_pos = get_collision_point()
#			var tile_pos = tilemap.world_to_map(hit_pos)
#			var tile_id = tilemap.get_cellv(tile_pos)
