extends Node3D
class_name CameraController

@export var playerController : PlayerController
var inputRotation : Vector3
var mouseInput : Vector2
var mouseSensitivity : float = 0.005

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mouseInput.x += -event.screen_relative.x * mouseSensitivity
		mouseInput.y += -event.screen_relative.y * mouseSensitivity

func _process(_delta: float) -> void:
	inputRotation.x = clampf(inputRotation.x + mouseInput.y, deg_to_rad(-90), deg_to_rad(85))
	inputRotation.y += mouseInput.x
	
	# rotate camera controller (up/down)
	transform.basis = Basis.from_euler(Vector3(inputRotation.x, 0.0, 0.0))
	
	# rotate player (left/right)
	playerController.global_transform.basis = Basis.from_euler(Vector3(0.0, inputRotation.y, 0.0))
	
	mouseInput = Vector2.ZERO
