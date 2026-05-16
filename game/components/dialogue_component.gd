extends Node
class_name DialogueComponent

@export var dialogue_file := ""

var data := {}
var dialogue_progress := {}
var initialized := false


func init(path: String) -> void:
	if initialized:
		return
	initialized = true
	dialogue_file = path
	load_dialogue()

func load_dialogue() -> void:
	if dialogue_file.is_empty():
		push_error("Dialogue file missing.")
		return

	var file = FileAccess.open(dialogue_file, FileAccess.READ)
	if file == null:
		push_error("Failed to load dialogue: " + dialogue_file)
		return

	var json := JSON.new()
	var result = json.parse(file.get_as_text())

	if result != OK:
		push_error("Dialogue JSON parse error in: " + dialogue_file)
		return

	data = json.data

func get_lines(dialogue_key: String) -> Array:
	if not data.has(dialogue_key):
		return []

	var conversations = data[dialogue_key]

	if conversations.is_empty():
		return []

	var index = dialogue_progress.get(dialogue_key, 0)
	index = clamp(index, 0, conversations.size() - 1)

	return conversations[index].duplicate(true)

func increment_dialogue_progress(dialogue_key: String) -> void:
	if not data.has(dialogue_key):
		return

	var conversations = data[dialogue_key]
	var current = dialogue_progress.get(dialogue_key, 0)

	# only increment if NOT last
	if current < conversations.size() - 1:
		current += 1

	dialogue_progress[dialogue_key] = current

func is_finished(dialogue_key: String) -> bool:
	if not data.has(dialogue_key):
		return true

	var conversations = data[dialogue_key]
	var index = dialogue_progress.get(dialogue_key, 0)

	return index >= conversations.size() - 1
