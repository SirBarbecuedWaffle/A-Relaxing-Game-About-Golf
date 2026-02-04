extends Node3D
@onready var reset_point: Marker3D = $resetPoint
@onready var player: Player = $Player


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_reset_area_body_entered(body: Node3D) -> void:
	await get_tree().create_timer(3.0).timeout
	player.global_position=reset_point.global_position
	player.linear_velocity=Vector3.ZERO
