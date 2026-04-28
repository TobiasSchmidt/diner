extends CharacterBody3D

var speed := 5.0
var mouse_sensitivity := 0.2

@onready var camera = $Camera3D
@onready var ray = $InteractRay

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))
		camera.rotate_x(deg_to_rad(-event.relative.y * mouse_sensitivity))
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-80), deg_to_rad(80))

func _physics_process(delta):
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
		var hit = ray.get_collider()
		print('get collider')
	
		if hit and hit.has_method("interact"):
			print('get hit')
			hit.interact()
