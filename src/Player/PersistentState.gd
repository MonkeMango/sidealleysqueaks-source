# persistent_state.gd

extends KinematicBody2D

class_name PersistentState

var state
var state_factory

var velocity = Vector2()

func _ready():
	state_factory = StateFactory.new()
	change_state("idle")
	

# Input code was placed here for tutorial purposes.
func _physics_process(delta):
	if Input.is_action_pressed("ui_left"):
		move_left()
	elif Input.is_action_pressed("ui_right"):
		move_right()

func move_left():
	state.move_left()

func move_right():
	state.move_right()

func change_state(new_state_name):
	if state != null:
		state.queue_free()
	state = state_factory.get_state(new_state_name).new()
	state.setup(funcref(self, "change_state"), $AnimatedSprite, self)
	state.name = "current_state"
	add_child(state)
