extends Node3D

@onready var coffee = $Sketchfab_model/Root/Cylinder/CoffeeMesh

func _ready() -> void:
	coffee.visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
