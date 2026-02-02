extends Node3D
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var area_3d: Area3D = $ExplosionParticles/Area3D
var soundglitch:=false

func _process(delta: float) -> void:
	if soundglitch:
		audio_stream_player.play(audio_stream_player.get_playback_position()-0.01)

func _ready() -> void:
	audio_stream_player.play(4.0)


func _on_area_3d_body_entered(body: Node3D) -> void:
	animation_player.play("new_animation")
	body.linear_velocity*=0
	body.global_position.z=area_3d.global_position.z
	body.global_position.x=area_3d.global_position.x
	soundglitch=true


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name=="new_animation":
		get_tree().change_scene_to_file("res://404.tscn")
