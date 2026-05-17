extends Node2D

@onready var dialogue_box = $CanvasLayer/DialogueBox
@onready var dialogue_text = $CanvasLayer/DialogueBox/RichTextLabel
@onready var text_blip = $CanvasLayer/DialogueBox/TextBlip

signal dialogue_finished

var typing_speed := 0.05

var lines: Array = []
var current_index := 0
var is_typing := false
var active := false

func start_lines(input_lines: Array):
	lines = input_lines
	current_index = 0
	active = true

	dialogue_box.visible = true

	show_page()

func show_page():
	if current_index >= lines.size():
		end_dialogue()
		return

	await type_text(lines[current_index])

func type_text(text: String) -> void:
	is_typing = true

	dialogue_text.text = text
	dialogue_text.visible_characters = 0

	for i in text.length():

		# stop loop if skipped
		if !is_typing:
			dialogue_text.visible_characters = -1
			return

		dialogue_text.visible_characters += 1

		if text[i] != " ":
			text_blip.pitch_scale = randf_range(0.95, 1.05)
			text_blip.play()

		await get_tree().create_timer(typing_speed).timeout

	is_typing = false

func next_page():
	if !active:
		return

	# skip typing
	if is_typing:
		dialogue_text.visible_characters = -1
		is_typing = false
		return

	current_index += 1
	show_page()

func end_dialogue():
	active = false
	lines.clear()
	current_index = 0

	dialogue_box.visible = false
	
	emit_signal("dialogue_finished")
