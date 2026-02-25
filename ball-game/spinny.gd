extends StaticBody3D


@export var spinSpeed:=200.0


func _physics_process(delta: float) -> void:
	rotation_degrees.z+=spinSpeed*delta
	
