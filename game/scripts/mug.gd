extends Node3D

@onready var coffee = $Visual/Sketchfab_Scene/Sketchfab_model/Root/Cylinder/Cylinder_1

var is_filled := true

func _ready() -> void:
	coffee.visible = false
	
func fill_coffee():
	is_filled = true
	coffee.visible = true	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
