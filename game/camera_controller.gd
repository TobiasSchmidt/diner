extends Node3D

@onready var cam: Camera3D = $"../Camera3D"

var default_fov := 75.0
var dialogue_fov := 40.0
var in_dialogue := false


func enter_dialogue(target: Node3D):
	in_dialogue = true
	var head_pos = target.get_node("HeadTarget").global_position

	var tween = get_tree().create_tween()
	tween.tween_property(cam, "fov", dialogue_fov, 0.25)

	cam.look_at(head_pos, Vector3.UP)


func exit_dialogue():
	in_dialogue = false
	
	var tween = get_tree().create_tween()
	tween.tween_property(cam, "fov", default_fov, 0.25)
