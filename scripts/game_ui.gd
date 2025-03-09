extends Control

@onready var play = get_tree().current_scene.get_node("Player")
@onready var text = $"Point info/Label"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text.text = "Points: " + str(int(play.points))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	text.text = "Points: " + str(int(play.points))
