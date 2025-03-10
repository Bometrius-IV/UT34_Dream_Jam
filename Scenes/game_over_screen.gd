extends Control

@onready var play = get_tree().current_scene.get_node("Player")
@onready var score_text= $final_score

# Called when the node enters the scene tree for the first time.
func update_score():
	score_text.text = "Final Score: " + str(int(play.points))

func restart_level():
	get_tree().reload_current_scene()

func quit_to_menu():
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
