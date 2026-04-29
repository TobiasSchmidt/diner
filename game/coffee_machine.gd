extends StaticBody3D

@export var coffee_sound: AudioStream
@export var mug_scene: PackedScene
@onready var spawn_point = $MugSpawnPoint

enum State {
	IDLE,
	BREWING,
	READY
}

var state = State.IDLE
var player = null
var mug_instance = null

func interact():
	if state != State.IDLE:
		return
	if player == null:
		player = get_tree().get_first_node_in_group("player")
	print("Making coffee...")
	make_coffee()

func make_coffee():
	state = State.BREWING
	player.can_move = false
	
	mug_instance = mug_scene.instantiate()
	add_child(mug_instance)
	mug_instance.global_position = spawn_point.global_position
	mug_instance.global_rotation = spawn_point.global_rotation
	
	var audio = AudioStreamPlayer3D.new()
	audio.stream = coffee_sound
	add_child(audio)
	audio.play()
	
	await get_tree().create_timer(6.0).timeout
	
	finish_coffee(audio)
	
func finish_coffee(audio):
	mug_instance.fill_coffee()
	audio.stop()
	player.can_move = true
	# TODO give mug to player	
	hand_to_player()

func hand_to_player():
	player.hold_item(mug_instance)
