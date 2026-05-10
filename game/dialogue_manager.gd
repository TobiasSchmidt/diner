extends Node3D

var dialogue_scene = preload("res://scenes/Dialogue.tscn")
var dialogue_ui = null

var current_npc = null


func _ready():
	dialogue_ui = dialogue_scene.instantiate()
	get_tree().root.call_deferred("add_child", dialogue_ui)

	# connect UI signal
	dialogue_ui.dialogue_finished.connect(_on_dialogue_finished)

func start_dialogue(npc):
	current_npc = npc

	var data = load_dialogue(npc.dialogue_file)
	var lines = npc.get_dialogue_lines(data)

	var player = get_tree().get_first_node_in_group("player")
	player.lock_player(current_npc)

	dialogue_ui.start_lines(lines)
	
func advance_dialogue():
	if dialogue_ui:
		dialogue_ui.next_page()	

func load_dialogue(path: String) -> Dictionary:
	var file = FileAccess.open(path, FileAccess.READ)

	if file == null:
		print("Failed to load dialogue:", path)
		return {}

	var json_text = file.get_as_text()

	var json = JSON.new()
	var result = json.parse(json_text)

	if result != OK:
		print("JSON parse error")
		return {}

	return json.data

func _on_dialogue_finished():
	if current_npc:
		current_npc.on_dialogue_finished()

	var player = get_tree().get_first_node_in_group("player")
	player.unlock_player()

	current_npc = null
