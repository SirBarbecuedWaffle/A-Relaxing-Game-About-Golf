extends Node2D
@onready var gateways: Node2D = $SubViewportContainer/SubViewport/gateways
@onready var char: CharacterBody2D = $SubViewportContainer/SubViewport/char
@onready var animated_sprite_2d: AnimatedSprite2D = $SubViewportContainer/SubViewport/char/AnimatedSprite2D
@onready var movetimer: Timer = $SubViewportContainer/SubViewport/char/movetimer
@onready var camera_2d: Camera2D = $SubViewportContainer/SubViewport/char/Camera2D
@onready var color_rect: ColorRect = $SubViewportContainer/SubViewport/ColorRect
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var foot_sound: AudioStreamPlayer = $footSound
@onready var audio_stream_player_2: AudioStreamPlayer = $AudioStreamPlayer2
@onready var portal_1_dest: Marker2D = $SubViewportContainer/SubViewport/gateway1/portal1Dest
@onready var gateway_29: GPUParticles2D = $SubViewportContainer/SubViewport/gateways/gateway29

var distTrans:=false
var startDistort:=false
var xDirection:=0
var yDirection:=0
var distortion:=0.2
var shadeStrength:=0.025
var glitching:=false

func _process(delta: float) -> void:
	if glitching:
		char.global_position=gateway_29.global_position
		audio_stream_player.pitch_scale=randi_range(0.005,0.25)
		audio_stream_player.volume_db=10
		audio_stream_player.play(audio_stream_player.get_playback_position()-0.1)
	for f in gateways.get_children():
		f.connect("teleported",_on_disttrigg_area_exited)
	if startDistort:
		if shadeStrength<0.08:
			distortion-=0.025
			shadeStrength+=0.001
			audio_stream_player.pitch_scale+=0.05
			audio_stream_player_2.pitch_scale-=0.01
	else:
		if shadeStrength>0.025:
			distortion+=0.025
			shadeStrength-=0.001
			audio_stream_player.pitch_scale-=0.05
			audio_stream_player_2.pitch_scale+=0.01
		
	if color_rect.material is ShaderMaterial:
		var shader_mat = color_rect.material
		shader_mat.set_shader_parameter("distortion_amount", distortion)
		shader_mat.set_shader_parameter("strength", shadeStrength)
		color_rect.material=shader_mat
	color_rect.global_position.x=camera_2d.global_position.x-(1152/6)
	color_rect.global_position.y=camera_2d.global_position.y-(648/6)
	if !distTrans:
		xDirection = Input.get_axis("rot_left", "rot_right")
		yDirection = Input.get_axis("boost", "down")
		if xDirection!=0 || yDirection!=0 && animated_sprite_2d.animation!="spawn":
			animated_sprite_2d.play("walk")
		else:
			if animated_sprite_2d.animation!="spawn":
				animated_sprite_2d.play("idle")
		if xDirection!=0:
			animated_sprite_2d.flip_h=xDirection==-1
		char.move_and_slide()
	else:
		xDirection=0
		yDirection=0



func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite_2d.animation=="spawn":
		animated_sprite_2d.play("idle")


func _on_movetimer_timeout() -> void:
	movetimer.start()
	if animated_sprite_2d.animation!="spawn" && !glitching:
		if xDirection!=0 || yDirection!=0:
			foot_sound.play()
			if animated_sprite_2d.frame<11:
				animated_sprite_2d.frame+=4
			else:
				animated_sprite_2d.frame=0
		char.global_position.x+=8*xDirection
		char.global_position.y+=8*yDirection







func _on_disttrigg_area_entered(area: Area2D) -> void:
	startDistort=true


func _on_disttrigg_area_exited(area: Area2D) -> void:
	await get_tree().create_timer(0.1).timeout
	startDistort=false


func _on_portal_body_entered(body: Node2D) -> void:
	glitching=true
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://End.tscn")
