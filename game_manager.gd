class_name GameManager
extends Node

@onready var play= $Player
@onready var pause= $"Pause menu"
@onready var game_over =$"Game Over Screen"
@onready var hud = $"In Game HUD"
@onready var spot = $spotlight
@onready var spot_model =$spotlight/spot_model
@onready var spot_detect = $spotlight/CollisionShape3D
@onready var spot_sound = $spotlight/AudioStreamPlayer3D
@onready var world_light =$DirectionalLight3D
var spot_open: float
var spot_change: float
@export var set_open = 10.0
@export var set_change = 5.0

@export var game_time= 180.0
var is_changing= false

var pps= 3.0
var is_game_up= true
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

func play_audio():
	spot_sound.playing = true

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pause.set_visible(false)
	game_over.set_visible(false)
	hud.set_visible(true)
	change_spot()
	is_changing = true
	spot_open = set_open
	spot_change = set_change
	spot_model.set_visible(false)
	spot_detect.set_disabled(true)
	is_game_up= true
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if game_time <=0:
		is_game_up = false;
	if is_game_up:
		if Input.is_action_just_pressed("pause"):
			is_paused = !is_paused
			spot_sound.playing = !spot_sound.playing
		if play.inLight && !is_paused:
			play.points += (pps*delta)
		if is_paused:
			pause.set_visible(true)
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		if !is_paused:
			game_time -= delta
			pause.set_visible(false)
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			if !is_changing:
				spot_open -= delta
				if spot_open<= 0:
					is_changing = true
					spot_model.set_visible(false)
					world_light.set_visible(true)
					spot_detect.set_disabled(true)
					change_spot()
					spot_change = set_change
			if is_changing:
				spot_change -= delta
				if spot_change<= 0:
					is_changing = false
					spot_model.set_visible(true)
					world_light.set_visible(false)
					spot_detect.set_disabled(false)
					spot_open = set_open
	if !is_game_up:
		is_paused = true
		spot_sound.playing = false
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		hud.set_visible(false)
		game_over.update_score()
		game_over.set_visible(true)
