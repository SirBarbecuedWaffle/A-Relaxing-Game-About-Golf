extends Node3D
@onready var reset_point: Marker3D = $resetPoint
@onready var player: Player = $Player
@onready var label: Label = $CanvasLayer2/Cruxes/Label
@onready var animation_player: AnimationPlayer = $CanvasLayer2/Cruxes/AnimationPlayer
@onready var plinko_trigger: Area3D = $plinkoTrigger


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func cruxSet(text : String)->void:
	label.text=text
	animation_player.play("showoff")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_reset_area_body_entered(body: Node3D) -> void:
	player.strokes+=1
	player.OOB()
	await get_tree().create_timer(3.0).timeout
	player.global_position=reset_point.global_position
	player.linear_velocity=Vector3.ZERO



func _on_plinko_trigger_body_entered(body: Node3D) -> void:
	cruxSet("Crux Reached\nPlinko Hell")


func _on_plinko_trigger_body_exited(body: Node3D) -> void:
	if body.global_position.y>286.196:
		cruxSet("Crux Completed")


func _on_reverse_plinko_body_entered(body: Node3D) -> void:
	cruxSet("Crux Reached\nThe Slope")


func _on_reverse_plinko_body_exited(body: Node3D) -> void:
	if body.global_position.y>515.49:
		cruxSet("Crux Completed")
