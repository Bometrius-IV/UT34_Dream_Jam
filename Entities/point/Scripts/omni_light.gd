@tool
#A basic script I made to have the data sent from Trenchbroom to be applied in Godot
#I ended up not using the omni light entity made and mainly used trenchbroom for level design
extends OmniLight3D
class_name LightOmni
#The dictionary used to hold the data from the entity from Func_Godot and Trenchbroom
#it has to be named this way in order for the data from Func_Godot entities to populate
@export var func_godot_properties: Dictionary


#function to add in the data from the dictionary to the related node spawned by the entity
#Also has to be named this way for Func_Godot to properly work with it
func _func_godot_apply_properties(props: Dictionary) ->void:
	light_color = props["color"]
	omni_range = props["range"]
	light_energy = props["energy"]
	shadow_enabled = true
