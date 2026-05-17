extends Node

var dialogue_scene = preload("res://scenes/Dialogue.tscn")
var dialogue_ui: Node = null

var current_npc = null

func _ready():
	dialogue_ui = dialogue_scene.instantiate()
	get_tree().root.call_deferred("add_child", dialogue_ui)
	dialogue_ui.dialogue_finished.connect(_on_dialogue_finished)

func start_dialogue(npc):
	current_npc = npc
	var key = npc.get_dialogue_key()
	var lines = npc.dialogue.get_lines(key)
	var player = get_tree().get_first_node_in_group("player")

	player.lock_player(npc)
	dialogue_ui.start_lines(lines)


func advance_dialogue():
	if dialogue_ui:
		dialogue_ui.next_page()

func _on_dialogue_finished():
	if current_npc:
		current_npc.dialogue.increment_dialogue_progress(current_npc.get_dialogue_key())
		current_npc.on_dialogue_finished()

	var player = get_tree().get_first_node_in_group("player")
	player.unlock_player()

	current_npc = null
