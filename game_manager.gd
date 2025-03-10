class_name GameManager
extends Node

@onready var play= $Player
@onready var pause= $"Pause menu"
@onready var spot = $spotlight
@onready var spot_detect = $spotlight/CollisionShape3D
@onready var world_light =$DirectionalLight3D
var spot_open= 5.0
var spot_change= 3.0
var is_changing= false;
var pps= 3.0
@export var is_paused = false
@export var spot_loc: Array[Node3D]
var past = [0,0]

func change_spot():
	var changed = false
	while !changed:
		var pot_spot = randi_range(1, spot_loc.size())
		var used= false
		for n in past.size():
			if pot_spot == past[n]:
				used = true
		if !used:
			spot.position = spot_loc[pot_spot-1].position
			past[1]=past[0]
			past[0]=pot_spot
			changed=true

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pause.set_visible(false)
	change_spot()
	is_changing = true
	spot.set_visible(false)
	spot_detect.set_disabled(true)
	
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
		if !is_changing:
			spot_open -= delta
			if spot_open<= 0:
				is_changing = true
				spot.set_visible(false)
				world_light.set_visible(true)
				spot_detect.set_disabled(true)
				change_spot()
				spot_change = 3.0
		if is_changing:
			spot_change -= delta
			if spot_change<= 0:
				is_changing = false
				spot.set_visible(true)
				world_light.set_visible(false)
				spot_detect.set_disabled(false)
				spot_open = 5.0
