extends StaticBody3D
@onready var success_particles: GPUParticles3D = $CSGCombiner3D/SuccessParticles
@export var nextScene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_3d_body_entered(body: Node3D) -> void:
	success_particles.emitting=true
	await get_tree().create_timer(3.0).timeout
	get_tree().change_scene_to_packed(nextScene)
