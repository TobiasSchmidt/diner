extends Node3D

@onready var anim = $Visual/AnimationPlayer
@onready var skeleton: Skeleton3D = $Visual/Armature/Skeleton3D
@onready var dialog_light: OmniLight3D = $DialogLight
@onready var dialogue = $DialogueComponent

var player = null
var is_talking := false
var dialogue_file := "res://assets/dialogue/opez.json"

enum State {
	INTRO,
	WAITING_FOR_COFFEE,
	COFFEE_DELIVERED
}

var state := State.INTRO

func _ready() -> void:
	dialogue.init(dialogue_file)
	sit()
	dialog_light.light_energy = 0.0


func sit() -> void:
	anim.play("Sit")


func interact() -> void:
	if is_talking:
		return

	player = get_tree().get_first_node_in_group("player")
	is_talking = true

	turn_head()
	enable_dialog_light()

	DialogueManager.start_dialogue(self)

func get_dialogue_key() -> String:
	match state:
		State.INTRO:
			return "intro"

		State.WAITING_FOR_COFFEE:
			return "waiting_for_coffee"

		State.COFFEE_DELIVERED:
			return "coffee_delivered"

	return "intro"	

func on_dialogue_finished() -> void:
	is_talking = false
	reset_head()
	disable_dialog_light()

	# gameplay progression
	if state == State.INTRO:
		if dialogue.is_finished(get_dialogue_key()):
			state = State.WAITING_FOR_COFFEE

			GlobalSignals.coffee_requested.emit()

func receive_coffee(player) -> void:
	# consume held item
	if player.held_item:
		player.held_item.queue_free()
		player.held_item = null

	state = State.COFFEE_DELIVERED

	DialogueManager.start_dialogue(self)


func enable_dialog_light() -> void:
	var tween = get_tree().create_tween()

	tween.tween_property(
		dialog_light,
		"light_energy",
		0.1,
		0.05
	)

func disable_dialog_light() -> void:
	var tween = get_tree().create_tween()

	tween.tween_property(
		dialog_light,
		"light_energy",
		0.0,
		0.15
	)

func turn_head() -> void:
	var bone_name = "mixamorig_Head"
	var bone_idx = skeleton.find_bone(bone_name)

	if bone_idx == -1:
		print("Head bone not found")
		return

	var rotation_amount = deg_to_rad(90)
	var yaw_rot = Quaternion(
		Vector3.UP,
		-rotation_amount
	)

	var current_pose = skeleton.get_bone_pose_rotation(bone_idx)
	var new_rotation = current_pose * yaw_rot

	skeleton.set_bone_pose_rotation(
		bone_idx,
		new_rotation
	)

func reset_head() -> void:
	var bone_name = "mixamorig_Head"
	var bone_idx = skeleton.find_bone(bone_name)

	if bone_idx == -1:
		return
	var tween = get_tree().create_tween()

	tween.tween_method(
		func(v):
			skeleton.set_bone_pose_rotation(
				bone_idx,
				v
			),
		skeleton.get_bone_pose_rotation(
			bone_idx
		),
		Quaternion.IDENTITY,
		0.2
	)
