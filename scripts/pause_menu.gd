extends Control

@onready var resume = $"Resume Button"
@onready var quit = $"Quit Button"
@onready var confirm = $"return confirm"
@onready var gm = get_tree().current_scene

func _ready() -> void:
	confirm.set_visible(false)

func unpause() -> void:
	gm.is_paused = false

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
