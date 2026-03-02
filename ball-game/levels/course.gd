extends StaticBody3D
@export var nextScene: PackedScene
@onready var success_particles: GPUParticles3D = $topFloor/SuccessParticles
@onready var success_particles2: GPUParticles3D = $CSGCombiner3D/SuccessParticles

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_3d_body_entered(body: Node3D) -> void:
	Manager.playBallSink()
	if success_particles!=null:
		success_particles.emitting=true
	if success_particles2!=null:
		success_particles2.emitting=true
	await get_tree().create_timer(3.0).timeout
	get_tree().change_scene_to_packed(nextScene)
