extends Node2D
@onready var animated_sprite_2d: AnimatedSprite2D = $SubViewportContainer/SubViewport/char/AnimatedSprite2D
@onready var kill_sound: AudioStreamPlayer = $SubViewportContainer/SubViewport/killSound
@onready var game_over: AudioStreamPlayer = $SubViewportContainer/SubViewport/gameOver

func _ready() -> void:
	await get_tree().create_timer(4.8).timeout
	animated_sprite_2d.play("die")
	await get_tree().create_timer(5.5).timeout
	kill_sound.play()
	await get_tree().create_timer(0.3).timeout
	game_over.play()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	get_tree().quit()
	
