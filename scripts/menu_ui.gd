extends Control

@onready var menu = $"Main Menu Screen"
@onready var help = $"Help Screen"
@onready var quit = $"Quit Confirm"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	help.set_visible(false)
	quit.set_visible(false)
	menu.set_visible(true)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func load_level():
	get_tree().change_scene_to_file("res://Scenes/main_level.tscn")

func quit_game():
	get_tree().quit()

func main_to_help():
	menu.set_visible(false)
	help.set_visible(true)

func help_to_main():
	menu.set_visible(true)
	help.set_visible(false)

func main_to_confirm():
	menu.set_visible(false)
	quit.set_visible(true)

func confirm_to_main():
	menu.set_visible(true)
	quit.set_visible(false)
