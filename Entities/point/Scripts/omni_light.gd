@tool
extends OmniLight3D
class_name LightOmni
@export var func_godot_properties: Dictionary

func _func_godot_apply_properties(props: Dictionary) ->void:
	light_color = props["color"]
	omni_range = props["range"]
	light_energy = props["energy"]
	shadow_enabled = true
