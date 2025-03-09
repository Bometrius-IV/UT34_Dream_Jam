extends Control

@onready var resume = $"Resume Button"
@onready var quit = $"Quit Button"
@onready var gm = get_tree().current_scene

func unpause() -> void:
	gm.is_paused = false
