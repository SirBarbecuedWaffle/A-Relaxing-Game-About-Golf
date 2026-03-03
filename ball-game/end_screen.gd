extends Node2D
@onready var label_2: Label = $Label2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	label_2.text="Look for the\nglitched tree"


func _on_button2_pressed() -> void:
	get_tree().change_scene_to_file("res://menuStuff/menu.tscn")
