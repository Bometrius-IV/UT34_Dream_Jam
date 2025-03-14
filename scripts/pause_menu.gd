extends Control

#pull child nodes and main node
@onready var resume = $"Resume Button"
@onready var quit = $"Quit Button"
@onready var confirm = $"return confirm"
@onready var gm = get_tree().current_scene

func _ready() -> void:
	#hide confirm window
	confirm.set_visible(false)

func unpause() -> void: #unpause the game when hitting the resume button
	gm.is_paused = false
	gm.play_audio()

func load_menu():
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

func pause_to_confirm():
	resume.set_visible(false)
	quit.set_visible(false)
	confirm.set_visible(true)

func confirm_to_pause():
	resume.set_visible(true)
	quit.set_visible(true)
	confirm.set_visible(false)
