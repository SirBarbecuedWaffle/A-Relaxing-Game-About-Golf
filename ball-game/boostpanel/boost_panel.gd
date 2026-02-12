extends Area3D
@export var launchforce:=400

func _on_body_entered(body: Node3D) -> void:
	body.linear_velocity*=0.3
	body.apply_central_force(-global_transform.basis.x*launchforce*10)		
