class_name GameManager
extends Node

#child nodes being referenced for gameplay
#player character
@onready var play= $Player
#ui scenes
@onready var pause= $"Pause menu" 
@onready var game_over =$"Game Over Screen"
@onready var hud = $"In Game HUD"
#spotlight node, model and lights, detection area, and sound effect respectively
@onready var spot = $spotlight
@onready var spot_model =$spotlight/spot_model
@onready var spot_detect = $spotlight/CollisionShape3D
@onready var spot_sound = $spotlight/AudioStreamPlayer3D
#directional light
@onready var world_light =$DirectionalLight3D

#timers used to count down the time left when the spotlight is active/inactive
var spot_open: float
var spot_change: float
#variables used to reset the timers to the max time
#can be edited in the inspector window for MainLevel node
@export var set_open = 10.0
@export var set_change = 5.0

#game time in seconds and variable checking if the game time is over 0
#time can be edited in inspector window
@export var game_time= 180.0
var is_game_up= true

#points per second when under the spotlight
var pps= 3.0
#bool used to let the game know if the spotlight is changing
var is_changing= false
#bool used to let the game know if it's paused or not
@export var is_paused = false
#array of the possible spotlight locations
@export var spot_loc: Array[Node3D]
#past array used to lock the spotlight from using the last two spots. Unused now
#var past = [0,0]
#array populated with unused spots after rolling the first location
var avail_spot = []
#int used to take note of the last spot to add it back into avail_spot
var last_spot = 0

func change_spot():
	#new spotlight logic based on Alejandro's suggested change
	
	if !avail_spot.is_empty(): #Once avail_spot is full
		var pot_spot = randi_range(0, avail_spot.size()-1) #choose between 0 and avail_spot size-1
		spot.position = spot_loc[avail_spot[pot_spot]-1].position #change spotlight position to rolled spot
		var buffer = avail_spot[pot_spot] #hold the current spot number
		avail_spot[pot_spot] = last_spot #replaced the rolled spot in the array with the last spot
		last_spot = buffer #set last spot to the held spot number
	if avail_spot.is_empty(): #on the first roll
		var pot_spot = randi_range(1, spot_loc.size()) #choose between 1 through spot_loc array size
		for n in range(1,spot_loc.size()+1): #for loop going through 1 to spot_loc array size 
			if n != pot_spot: #if n is not the rolled spot
				avail_spot.append(n) #add n to the array list
		spot.position = spot_loc[pot_spot-1].position #set the spotlight position to the rolled spot
		last_spot = pot_spot #set last_spot to the rolled spot number
	
	#previous spotlight logic
	#the game could have locked up if it kept rolling numbers in the past array
	#var changed = false
	#while !changed:
		#var pot_spot = randi_range(1, spot_loc.size())
		#var used= false
		#for n in past.size():
			#if pot_spot == past[n]:
				#used = true
		#if !used:
			#spot.position = spot_loc[pot_spot-1].position
			#past[1]=past[0]
			#past[0]=pot_spot
			#changed=true

func play_audio():
	spot_sound.playing = true

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) #hides the mouse and allows it for mouse look
	pause.set_visible(false) #hides the pause menu
	game_over.set_visible(false) #hides the game over menu
	hud.set_visible(true) # displays the HUD
	change_spot() #does the first roll for the spotlight
	is_changing = true # lets the game know that the spotlight is changing
	#sets both timers to the determined values
	spot_open = set_open
	spot_change = set_change
	#hides the model for the spotlight and disables the detection area
	spot_model.set_visible(false)
	spot_detect.set_disabled(true)
	is_game_up= true #sets the game as running
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if game_time <=0: #if the timer hits 0 or below
		is_game_up = false; #set the game as over
	if is_game_up: #while the game is running
		if Input.is_action_just_pressed("pause"): #if the pause button was hit
			#set the pause variable to the opposite of its current state
			#this can allow the user to press pause again to resume
			is_paused = !is_paused
			#set the playing bool for the spotlight sound opposite to its current state
			#similar thought process as is_paused
			spot_sound.playing = !spot_sound.playing
		if play.inLight && !is_paused: #if the player is in the spotlight and the game isn't paused
			play.points += (pps*delta) #add the points per second multiplied by delta to the player's points variable
		if is_paused: #if the game is paused
			pause.set_visible(true) #show the pause menu
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE) #display the mouse cursor
		if !is_paused: #when the game isn't paused
			game_time -= delta #remove delta from the timer
			pause.set_visible(false) #hide the pause menu
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) #hide and recature the mouse inputs again
			if !is_changing: #if the spotlight isn't changing
				spot_open -= delta #remove delta from the active timer
				if spot_open<= 0: #if the active timer hits 0 or below
					is_changing = true #notify the game that the spotlight is changing
					spot_model.set_visible(false) #hide the spotlight model
					world_light.set_visible(true) #turn on the world light
					spot_detect.set_disabled(true) #disable the spotlight's detection box
					change_spot() #reroll a new spot
					spot_change = set_change #reset the hidden timer
			if is_changing: #if the spotlight is changing
				spot_change -= delta #remove delta from the hidden timer
				if spot_change<= 0: #if the hidden timer hits 0 or below
					is_changing = false #notify the game the the spotlight is visible
					spot_model.set_visible(true) #display the spotlight model
					world_light.set_visible(false) #hide the world light
					spot_detect.set_disabled(false) #enable the detection area
					spot_open = set_open #reset the active timer
	if !is_game_up: #when the game is over
		is_paused = true #pause the game
		spot_sound.playing = false #stop playing the audio
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE) #display the mouse
		hud.set_visible(false) #hide the hud
		game_over.update_score() #display the score on the results text box
		game_over.set_visible(true) #display the game over screen
