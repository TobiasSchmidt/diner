extends Node3D

@onready var player = get_node("../Player")
@onready var camera = player.get_node("Camera3D")
@onready var table = get_node("..diner/diner-wrapper/Seat_02")
@onready var seat_anchor = $SeatAnchor

@export var character_scene: PackedScene

var has_spawned = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$SpawnTimer.timeout.connect(_on_spawn_timer_timeout)

func _on_spawn_timer_timeout():
	if has_spawned:
		return
	if not is_camera_looking_at(table):
		# TODO		spawn_character()
		has_spawned = true
	else:
		await get_tree().create_timer(3).timeout
		_on_spawn_timer_timeout()		

func is_camera_looking_at(target: Node3D) -> bool:
	var camera_pos = camera.global_transform.origin
	var camera_forward = -camera.global_transform.basis.z.normalized()
	
	var to_target = (target.global_transform.origin -camera_pos).normalized()
	
	var dot = camera_forward.dot(to_target)
	
	return dot > 0.6

func spawn_character():
	var character = character_scene.instantiaite()
	
	character.global_transform = seat_anchor.global_transform
	
	get_tree().current_scene.add_child(character)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
