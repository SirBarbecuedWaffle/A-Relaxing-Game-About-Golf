extends Node2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _process(delta: float) -> void:
	animated_sprite_2d.global_position.x+=3
	if animated_sprite_2d.global_position.x>2200:
		animated_sprite_2d.global_position.x=-100


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://levels/level2.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()
