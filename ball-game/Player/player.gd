extends RigidBody3D
class_name Player
@export_range(5,25) var launchForce:=1000.0
@export_range(50,200) var turnSpeed:=100.0
var transitioning:=false
@onready var success: AudioStreamPlayer = $success
@onready var explode: AudioStreamPlayer = $explode
@onready var boost: AudioStreamPlayer3D = $boost
@onready var _camera_pivot: Node3D = $camera_pivot
@export_range(0.0, 1.0) var mouse_sensitivity = 0.01
@export var tilt_limit = deg_to_rad(45)
@onready var ball_skin: Node3D = $ballSkin
@onready var ball_speen: RigidBody3D = $ballSkin/ballSpeen

@onready var spring_arm_3d: SpringArm3D = $camera_pivot/SpringArm3D
@onready var club_deco: Node3D = $clubLocation/clubDeco

@onready var pause_lab: Label = $Control/pauseLab
@onready var club_location: Marker3D = $clubLocation
@onready var golf_ball: MeshInstance3D = $ballSkin/golfBall
@onready var camera_3d: Camera3D = $camera_pivot/SpringArm3D/Camera3D
var paused:=false
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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
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
		else:
			paused=true
			Engine.time_scale=0.0001
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
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
			var clubtween = create_tween()
			clubtween.set_trans(Tween.TRANS_SINE)
			clubtween.tween_property(club_deco,"global_position",golf_ball.global_position,0.1)
			await clubtween.finished
			club_deco.global_position=club_location.global_position
			club_deco.visible=false
			print(clubDistance)
			apply_central_force(Vector3(global_position.x-club_location.global_position.x,0,global_position.z-club_location.global_position.z)*launchForce*delta*1000*clubDistance)		
			apply_central_force(Vector3.DOWN)	
			clubDistance=1.0
			spring_arm_3d.spring_length=3
		else:
			if boost.playing:
				boost.playing=false
		#if Input.is_action_pressed("rot_left"):
			#apply_central_force(_camera_pivot.global_basis * Vector3(-1, 0, 0)*50)
		#if Input.is_action_pressed("rot_right"):
			#apply_central_force(_camera_pivot.global_basis * Vector3(1, 0, 0)*50)

func _on_body_entered(body: Node) -> void:
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
	
func crash_sequence()->void:
	transitioning=true
	explode.play()
	print("KABOOM")
	await get_tree().create_timer(1.0).timeout
	get_tree().reload_current_scene.call_deferred()
