extends AnimatableBody3D
@onready var marker_3d: Marker3D = $Marker3D
@onready var marker_3d_2: Marker3D = $Marker3D2
@onready var csg_box_3d: CSGBox3D = $CSGBox3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#await get_tree().create_timer(3.0).timeout
#
	#animation_player.play("new_animation")
	move()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func move() -> void:
	var clubtween = create_tween()
	clubtween.set_trans(Tween.TRANS_SINE)
	clubtween.tween_property(csg_box_3d,"global_position",marker_3d.global_position,1)    
	await clubtween.finished
	var clubtween2= create_tween()
	clubtween2.set_trans(Tween.TRANS_SINE)
	clubtween2.tween_property(csg_box_3d,"global_position",marker_3d_2.global_position,1)    
	await clubtween2.finished
	move()
