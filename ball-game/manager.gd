extends Node
@onready var ball_sink: AudioStreamPlayer = $ballSink
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var audio_stream_player_2: AudioStreamPlayer = $AudioStreamPlayer2

@export var scores=[0,0,0,0,0,0,0,0,0]
@export var pars=[2,2,3,3,3,742,3,5,6]
@export var curLevel=0


func playBallSink()->void:
	ball_sink.play()

func stopMusic()->void:
	audio_stream_player.stop()
	audio_stream_player_2.stop()
