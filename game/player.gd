extends CharacterBody3D

var speed := 3.0
var mouse_sensitivity := 0.2
var can_move := true

var in_dialogue := false
var current_npc = null

@onready var camera = $Camera3D
@onready var ray = $Camera3D/InteractRay
@onready var hand = $Camera3D/Hand
@onready var camera_controller = $CameraController

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if in_dialogue:
		return
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))
		camera.rotate_x(deg_to_rad(-event.relative.y * mouse_sensitivity))
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-80), deg_to_rad(80))

func _physics_process(delta):
	if in_dialogue:
		if Input.is_action_just_pressed("interact"):
			DialogueManager.advance_dialogue()
		return
	if not can_move:
		return
	var direction = Vector3.ZERO
	if Input.is_action_pressed("ui_up"):
		direction -= transform.basis.z
	if Input.is_action_pressed("ui_down"):
		direction += transform.basis.z
	if Input.is_action_pressed("ui_left"):
		direction -= transform.basis.x
	if Input.is_action_pressed("ui_right"):
		direction += transform.basis.x
	if Input.is_action_just_pressed("interact"):
		try_interact()	

	direction = direction.normalized()

	# horizontal movement
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed

	# simple gravity
	if not is_on_floor():
		velocity.y -= 9.8 * delta
	else:
		velocity.y = 0

	move_and_slide()
	
func try_interact():
	if ray.is_colliding():
		print(ray.get_collider())
		var hit = ray.get_collider()
		if hit and hit.has_method("interact"):
			hit.interact()
			
func hold_item(item):
	item.reparent(hand)
	item.transform = Transform3D.IDENTITY
	#item.scale = Vector3(1.5, 1.5, 1.5)
	

# called by DialogueManager
func lock_player(npc):
	in_dialogue = true
	camera_controller.enter_dialogue(npc)

# called by DialogueManager
func unlock_player():
	in_dialogue = false
	camera_controller.exit_dialogue()
	
