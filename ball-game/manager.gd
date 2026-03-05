extends Node
@onready var ball_sink: AudioStreamPlayer = $ballSink
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var audio_stream_player_2: AudioStreamPlayer = $AudioStreamPlayer2
@onready var audio_stream_player_3: AudioStreamPlayer = $AudioStreamPlayer3

@export var scores=[0,0,0,0,0,0,0,0,0]
@export var pars=[2,2,3,4,3,6,5,6,743]
@export var curLevel=0
	

func stopMenu()->void:
	audio_stream_player_3.stop()

func startMusic()->void:
	await get_tree().create_timer(0.2).timeout
	audio_stream_player.play()

func playBallSink()->void:
	ball_sink.play()

func stopMusic()->void:
	audio_stream_player.stop()
	audio_stream_player_2.stop()
