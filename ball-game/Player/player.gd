extends RigidBody3D
class_name Player
@export_range(5,25) var launchForce:=1000.0
@export_range(50,200) var turnSpeed:=100.0
var transitioning:=false
@onready var animation_player_2: AnimationPlayer = $CanvasLayer/Node2D/AnimationPlayer2
@onready var power_hud: Control = $CanvasLayer/powerHUD
@onready var success: AudioStreamPlayer = $success
@onready var explode: AudioStreamPlayer = $explode
@onready var boost: AudioStreamPlayer3D = $boost
@onready var _camera_pivot: Node3D = $camera_pivot
@export_range(0.0, 1.0) var mouse_sensitivity = 0.01
@export var tilt_limit = deg_to_rad(45)
@onready var ball_skin: Node3D = $ballSkin
@onready var ball_speen: RigidBody3D = $ballSkin/ballSpeen
@onready var power_bar: ColorRect = $CanvasLayer/powerHUD/powerBar
@onready var club_swing: AudioStreamPlayer = $clubSwing
@onready var hit: AudioStreamPlayer = $hit
@onready var wood_thud: AudioStreamPlayer = $woodThud
@onready var grass_thud: AudioStreamPlayer = $grassThud
@onready var glass_thud: AudioStreamPlayer = $glassThud
@onready var score_card: Sprite2D = $Control/scoreCard
@export var strokes:=0
@onready var hud: Control = $Control/HUD
@onready var par_lab: Label = $Control/HUD/parLab

const BASIC_GRASS_MATERIAL = preload("uid://brd42gst6v57f")
const GLASSMATERIAL = preload("uid://b3dqs55pbr37s")

const WOOD_MATERIAL = preload("uid://bp45eo2ayq38h")
const OUT_OF_BOUNDS_MATERIAL = preload("uid://cv7krxq7hmerw")
@onready var pars: Control = $Control/scoreCard/pars
@onready var scores: Control = $Control/scoreCard/scores

@onready var oob_lab: Label = $Control/OOBLab

@onready var hole_1_score: Label = $Control/scoreCard/Control/hole1Score
@onready var hole_2_score: Label = $Control/scoreCard/Control/hole2Score
@onready var hole_3_score: Label = $Control/scoreCard/Control/hole3Score
@onready var hole_4_score: Label = $Control/scoreCard/Control/hole4Score
@onready var hole_5_score: Label = $Control/scoreCard/Control/hole5Score
@onready var hole_6_score: Label = $Control/scoreCard/Control/hole6Score
@onready var hole_7_score: Label = $Control/scoreCard/Control/hole7Score
@onready var hole_8_score: Label = $Control/scoreCard/Control/hole8Score
@onready var hole_9_score: Label = $Control/scoreCard/Control/hole9Score

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var spring_arm_3d: SpringArm3D = $camera_pivot/SpringArm3D
@onready var club_deco: Node3D = $clubLocation/clubDeco

@onready var pause_lab: Label = $Control/pauseLab
@onready var club_location: Marker3D = $clubLocation
@onready var golf_ball: MeshInstance3D = $ballSkin/golfBall
@onready var camera_3d: Camera3D = $camera_pivot/SpringArm3D/Camera3D
var paused:=false
@onready var stroke_lab: Label = $Control/HUD/strokeLab
@onready var ball_messiah: MeshInstance3D = $ballSkin/ballMessiah
var clubDistance:=1.0
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion && !paused:
		_camera_pivot.rotation.x -= event.relative.y * mouse_sensitivity
		_camera_pivot.rotation.x = clampf(_camera_pivot.rotation.x, -tilt_limit, tilt_limit)
		_camera_pivot.rotation.y += -event.relative.x * mouse_sensitivity
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func showScore()->void:
	score_card.visible=true

func _process(delta: float) -> void:
	stroke_lab.text=str(strokes)
	par_lab.text="Par "+str(Manager.pars[Manager.curLevel])
	for i in range(Manager.curLevel+1):
		var chil=pars.get_children()
		chil[i].text=str(Manager.pars[i])
	for i in range(Manager.curLevel ):
		var chil=scores.get_children()
		chil[i].text=str(Manager.scores[i])
	var chile=scores.get_children()
	chile[Manager.curLevel].text=str(strokes)
	




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if abs(linear_velocity.x)>3 || abs(linear_velocity.y)>6:
		club_deco.visible=false
	power_hud.visible=club_deco.visible
	if clubDistance<2:
		power_bar.modulate=Color(0.0, 1.0, 0.0, 1.0)
	if power_bar!=null:
		
		power_bar.scale.y=clubDistance*clubDistance/72.25*3.681
		if clubDistance*clubDistance/72.25>0.3:
			var coltween = create_tween()
			coltween.set_trans(Tween.TRANS_SINE)
			coltween.tween_property(power_bar,"modulate",Color(1.0, 1.0, 0.0, 1.0),0.15)
		if clubDistance*clubDistance/72.25>0.6:
			var coltween = create_tween()
			coltween.set_trans(Tween.TRANS_SINE)
			coltween.tween_property(power_bar,"modulate",Color(1.0, 0.0, 0.0, 1.0),0.15)
		if clubDistance*clubDistance/72.25>0.9:
			if animation_player.current_animation!="new animation":
				animation_player.play("new_animation")
		else:
			animation_player.play("RESET")
	_camera_pivot.global_position=global_position
	club_deco.rotation.y=_camera_pivot.rotation.y-1.57
	var rollAxis: Vector3 = linear_velocity.cross(Vector3.UP).normalized()
	var angdistance: float = linear_velocity.length() * delta / 0.3
	ball_skin.rotate(rollAxis, -1*angdistance)
	#ball_skin.rotation.z=linear_velocity.x
	#ball_skin.rotation.x=-1*linear_velocity.z
	club_location.global_position.y=golf_ball.global_position.y
	var cameraRads=Vector2(camera_3d.global_position.z,camera_3d.global_position.x).angle_to(Vector2(global_position.z,global_position.x)) 
	var cameraAngle=rad_to_deg(cameraRads)

	club_location.global_position.x=golf_ball.global_position.x+(sin(_camera_pivot.rotation.y)*clubDistance*0.5)
	club_location.global_position.z=golf_ball.global_position.z+(cos(_camera_pivot.rotation.y)*clubDistance*0.5)
	
	if Input.is_action_just_pressed("esc"):
		
		if paused:
			paused=false
			Engine.time_scale=1
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			score_card.visible=false
		else:
			if !oob_lab.visible:
				paused=true
				Engine.time_scale=0.0001
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
				score_card.visible=true
		pause_lab.visible=paused
			
	if !transitioning:
		if Input.is_action_pressed("boost") && abs(linear_velocity.z)<0.2 && abs(linear_velocity.x)<0.2 && abs(linear_velocity.y)<0.2:
			club_deco.visible=true
			print(clubDistance)
			if clubDistance<8.5:
				clubDistance+=0.075
			if spring_arm_3d.spring_length<5.5:
				spring_arm_3d.spring_length+=0.025
		if Input.is_action_just_released("boost") && abs(linear_velocity.z)<0.2 && abs(linear_velocity.x)<0.2 && abs(linear_velocity.y)<0.2:
			club_swing.play()
			club_swing.pitch_scale=randf_range(0.9,1.2)
			var clubtween = create_tween()
			clubtween.set_trans(Tween.TRANS_SINE)
			clubtween.tween_property(club_deco,"global_position",golf_ball.global_position,0.1)
			await clubtween.finished
			hit.play()
			hit.pitch_scale=randf_range(0.9,1.2)
			club_deco.global_position=club_location.global_position
			club_deco.visible=false
			print(clubDistance)
			apply_central_force(Vector3(global_position.x-club_location.global_position.x,0,global_position.z-club_location.global_position.z)*launchForce*delta*1000*clubDistance)		
			apply_central_force(Vector3.DOWN)	
			clubDistance=1.0
			spring_arm_3d.spring_length=3
			strokes+=1
		else:
			if boost.playing:
				boost.playing=false
		#if Input.is_action_pressed("rot_left"):
			#apply_central_force(_camera_pivot.global_basis * Vector3(-1, 0, 0)*50)
		#if Input.is_action_pressed("rot_right"):
			#apply_central_force(_camera_pivot.global_basis * Vector3(1, 0, 0)*50)

func _on_body_entered(body: Node) -> void:
	if linear_velocity.x>450  || linear_velocity.x<-450:
		if !body is CSGCombiner3D:
			if body.material==BASIC_GRASS_MATERIAL:
				if !grass_thud.playing:
					grass_thud.play()
					grass_thud.pitch_scale=randf_range(0.9,1.2)
			if body.material==WOOD_MATERIAL:
				wood_thud.play()
				wood_thud.pitch_scale=randf_range(0.9,1.2)
			if body.material==GLASSMATERIAL:
				glass_thud.play()
				glass_thud.pitch_scale=randf_range(3.2,4.0)
	if linear_velocity.y>2 || linear_velocity.y<-2:
		if !body is CSGCombiner3D: 
			if body.material==BASIC_GRASS_MATERIAL:
				if !grass_thud.playing:
					grass_thud.play()
					grass_thud.pitch_scale=randf_range(0.9,1.2)
			if body.material==OUT_OF_BOUNDS_MATERIAL:
				if !grass_thud.playing:
					grass_thud.play()
					grass_thud.pitch_scale=randf_range(0.4,0.7)
			if body.material==WOOD_MATERIAL:
				wood_thud.play()
				wood_thud.pitch_scale=randf_range(0.9,1.2)
			if body.material==GLASSMATERIAL:
				glass_thud.play()
				glass_thud.pitch_scale=randf_range(0.9,1.2)
		else:
			if !grass_thud.playing:
				grass_thud.play()
				grass_thud.pitch_scale=randf_range(0.9,1.2)
	if linear_velocity.z<450 || linear_velocity.z>-450:
		if !body is CSGCombiner3D:
			if body.material==BASIC_GRASS_MATERIAL:
				if !grass_thud.playing:
					grass_thud.play()
					grass_thud.pitch_scale=randf_range(0.9,1.2)
			elif body.material==WOOD_MATERIAL:
				wood_thud.play()
				wood_thud.pitch_scale=randf_range(0.9,1.2)
			if body.material==GLASSMATERIAL:
				glass_thud.play()
				glass_thud.pitch_scale=randf_range(0.9,1.2)
	#if "goal" in body.get_groups() && !transitioning:
		#if body.file_path!=null:
			#complete_level(body.file_path)
		#else:
			#print("ERROR CODE 002: where tf u tryin to go???")
	#if "obstacle" in body.get_groups() && !transitioning:
		#crash_sequence()
	pass

func complete_level(next_level_file)->void:
	
	transitioning=true
	success.play()
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file(next_level_file)
	
func OOB()->void:
	oob_lab.visible=true
	await get_tree().create_timer(3.0).timeout
	oob_lab.visible=false
	
func finsh()->void:
	hud.visible=false
	await get_tree().create_timer(2.5).timeout
	animation_player_2.play("transition")
	
func crash_sequence()->void:
	transitioning=true
	explode.play()
	print("KABOOM")
	await get_tree().create_timer(1.0).timeout
	get_tree().reload_current_scene.call_deferred()
