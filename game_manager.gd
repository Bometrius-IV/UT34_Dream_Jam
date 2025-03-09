class_name GameManager
extends Node

@onready var play= $Player
@onready var pause= $"Pause menu"
var pps= 3.0
@export var is_paused = false

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pause.set_visible(false)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		is_paused = !is_paused
	if play.inLight && !is_paused:
		play.points += (pps*delta)
	if is_paused:
		pause.set_visible(true)
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if !is_paused:
		pause.set_visible(false)
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		
