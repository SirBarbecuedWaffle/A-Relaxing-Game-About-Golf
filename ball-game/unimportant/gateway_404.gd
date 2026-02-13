extends GPUParticles2D
@onready var portal_1_dest: Marker2D = $portal1Dest
signal teleported
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

func _on_portal_body_entered(body: Node2D) -> void:
	body.global_position=portal_1_dest.global_position
	teleported.emit()
	audio_stream_player.play()
