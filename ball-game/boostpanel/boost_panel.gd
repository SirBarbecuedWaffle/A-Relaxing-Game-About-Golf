extends Area3D
@export var launchforce:=400
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

func _on_body_entered(body: Node3D) -> void:
	body.linear_velocity*=0.3
	body.apply_central_force(-global_transform.basis.x*launchforce*10)
	if visible:
		audio_stream_player.play(0.1)
		audio_stream_player.pitch_scale=randf_range(0.9,1.2)
