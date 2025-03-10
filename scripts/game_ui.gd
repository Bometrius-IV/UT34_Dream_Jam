extends Control

@onready var play = get_tree().current_scene.get_node("Player")
@onready var point_text = $"Point info/Label"
@onready var time_text = $Timer/timer_text
@onready var gm = get_tree().current_scene

func sing_sec(sec: int) -> String:
	if sec < 10:
		return "0"+str(sec)
	else:
		return str(sec)

func set_time():
	time_text.text = "Time: "+ str(int(gm.game_time/60)) + ":" + sing_sec(int(gm.game_time)%60)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	point_text.text = "Points: " + str(int(play.points))
	set_time()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	point_text.text = "Points: " + str(int(play.points))
	set_time()
