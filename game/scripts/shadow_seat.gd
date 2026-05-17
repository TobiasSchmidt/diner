extends Node3D

@onready var player = get_tree().get_first_node_in_group("player")
@onready var camera = player.get_node("Camera3D")

@export var character_scene: PackedScene
@export var spawn_target: Node3D  # area or marker you look at for visibility check
@export var spawn_distance: float = 15.0
@export var despawn_distance: float = 3.0
@export var look_dot_threshold: float = 0.6
@export var respawn_delay: float = 5.0

@onready var spawn_anchor: Node3D = $SeatAnchor

var npc: Node3D = null
var can_spawn := true
var shadow_shader = load("res://materials/shadow/shadow_shader.gdshader")

func _process(_delta: float) -> void:
	if not player:
		return

	if npc == null:
		if can_spawn and should_spawn():
			spawn_character()
	else:
		if should_despawn():
			despawn_character()

func should_spawn() -> bool:
	return (
		not is_camera_looking_at(spawn_target) and
		player_distance() > spawn_distance
	)

func should_despawn() -> bool:
	return player_distance_to_npc() < despawn_distance

func is_camera_looking_at(target: Node3D) -> bool:
	if PlayerTracker.camera == null or target == null:
		return false

	var camera_pos = PlayerTracker.camera.global_transform.origin
	var camera_forward = -PlayerTracker.camera.global_transform.basis.z.normalized()

	var to_target = (target.global_transform.origin - camera_pos).normalized()

	return camera_forward.dot(to_target) > 0.6

func spawn_character():
	can_spawn = false

	npc = character_scene.instantiate()
	get_tree().current_scene.add_child(npc)
	npc.global_transform = spawn_anchor.global_transform
	
	make_shadow(npc)

	print("Shadow spawned")

func despawn_character():
	if npc:
		npc.queue_free()
		npc = null

	print("Shadow despawned")

	# cooldown before it can appear again
	await get_tree().create_timer(respawn_delay).timeout
	can_spawn = true
	
func make_shadow(node: Node):

	if node is MeshInstance3D:

		var material := StandardMaterial3D.new()

		material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED

		# Almost black
		material.albedo_color = Color(0.02, 0.02, 0.02)

		# This is the important part
		material.rim_enabled = true
		material.rim = 0.15
		material.rim_tint = 0.0

		# No shiny reflections
		material.metallic = 0.0
		material.roughness = 1.0

		node.material_override = material

	for child in node.get_children():
		make_shadow(child)

func player_distance() -> float:
	return player.global_position.distance_to(spawn_anchor.global_position)

func player_distance_to_npc() -> float:
	if npc == null:
		return INF
	return player.global_position.distance_to(npc.global_position)
