extends Node2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var audio_stream_player_2: AudioStreamPlayer = $AudioStreamPlayer2

func _process(delta: float) -> void:
	animated_sprite_2d.global_position.x+=3
	if animated_sprite_2d.global_position.x>2200:
		animated_sprite_2d.global_position.x=-100


func _on_start_pressed() -> void:
	if animation_player.current_animation!="fadeOut":
		Manager.stopMenu()
		audio_stream_player_2.play()
		animation_player.play("fadeOut")
		await get_tree().create_timer(2.5).timeout
		Manager.startMusic()
		get_tree().change_scene_to_file("res://levels/level2.tscn")


func _on_quit_pressed() -> void:
	if animation_player.current_animation!="fadeOut":
		Manager.stopMenu()
		audio_stream_player.play()
		animation_player.play("fadeOut")
		await get_tree().create_timer(2.5).timeout
		get_tree().quit()
