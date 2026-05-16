extends Node3D

@onready var dialogue = $DialogueCom

func interact():
	dialogue.start(self)
