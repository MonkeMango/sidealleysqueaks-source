extends Camera2D


var shake_amount : float = 0
var default_offset = offset
onready var tween = $Tween
onready var timer = $Timer 

func _ready():
	Globals.camera = self
	set_process(false)
	randomize()

func _process(delta):
	offset = Vector2(rand_range(-1, 1) * shake_amount, rand_range(-1, 1) * shake_amount)

func shake(time, amount):
	timer.wait_time = time
	shake_amount = amount
	set_process(true)
	timer.start()

func _on_Timer_timeout():
	set_process(false)
	tween.interpolate_property(self, "offset", offset, default_offset, 0.1, 6, 2)
