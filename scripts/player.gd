extends CharacterBody3D

#player speed, jump velocity, and mouse sensitivity
const SPEED = 10.0
const JUMP_VELOCITY = 4.5
const sens= 0.005

#bool detecting if the player is under the spotlight and the points variable
#Would be better in the game manager script in hindsight
#in order to decouple game logic from the player
@export var inLight= false;
@export var points=0.0

#Pulling the child nodes for camer movement and root node from MainLevel
@onready var head = $head
@onready var camera = $head/Camera3D
@onready var gm = get_tree().current_scene


#function that marks the player as inside of the spotlight
func in_light(body: Node3D):
	if body == self:
		inLight=true

#function that marks the player outside of the spotlight
func out_light(body: Node3D):
	if body == self:
		inLight=false
#These two functions would also be better placed in game manager
#since these relate to the gameplay logic


func _ready():
	points=0.0 #set's points to zero


#deals with mouse look in game as long as the game isn't paused
func _unhandled_input(event: InputEvent) -> void:
	if !gm.is_paused:
		if event is InputEventMouseMotion:
			head.rotate_y(-event.relative.x * sens)
			camera.rotate_x(-event.relative.y * sens)
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-40), deg_to_rad(60))

#deals with jump physics as long as the game ins't paused
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if !gm.is_paused:
		if not is_on_floor():
			velocity += get_gravity() * delta
	# Handle jump.
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
		var input_dir := Input.get_vector("left", "right", "up", "down")
		var direction : Vector3= (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)

		move_and_slide()
