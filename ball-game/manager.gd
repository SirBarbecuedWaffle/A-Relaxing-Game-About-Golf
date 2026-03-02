extends Node
@onready var ball_sink: AudioStreamPlayer = $ballSink
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var audio_stream_player_2: AudioStreamPlayer = $AudioStreamPlayer2


func playBallSink()->void:
	ball_sink.play()

func stopMusic()->void:
	audio_stream_player.stop()
	audio_stream_player_2.stop()
