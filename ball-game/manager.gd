extends Node
@onready var ball_sink: AudioStreamPlayer = $ballSink
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var audio_stream_player_2: AudioStreamPlayer = $AudioStreamPlayer2

@export var scores=[0,0,0,0,0,0,0,0,0]
@export var pars=[2,2,3,4,3,6,5,6,742]
@export var curLevel=0
func _process(delta: float) -> void:
	audio_stream_player.pitch_scale-=0.0001


func playBallSink()->void:
	ball_sink.play()

func stopMusic()->void:
	audio_stream_player.stop()
	audio_stream_player_2.stop()
