extends Node3D
class_name PlayerDrink

@export_group("Audio Visual Parameters")
@export var audioPlayer : AudioStreamPlayer3D
@export var canvas : ShaderMaterial

@export_group("Player Body Transform Parameters")
@export var mouth : Node3D
@export var rightHand : Node3D
@export_range(1, 50, 1) var handSpeed : float = 1
@export var head : Node3D
@export_range(1, 50, 1) var headSpeed : float = 1
@export var theVoid : Node3D

var target : Node3D
var dir : float = 0
var chaos : float = 1.0
var radius : float = 0.1
var attenuation : float = 1.0
var isDrinking : bool = false

func _ready() -> void:
	transform = rightHand.transform

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("action", true):
		target = mouth
		isDrinking = true
		dir = 1
		audioPlayer.play()
	else:
		target = rightHand
		isDrinking = false
		dir = 0
		
	Drink(delta)


func ModulateChaos(delta, ch: float,att: float) -> void:
	clampf(chaos, 0.0, 32.0)
	clampf(attenuation, 1.0, 5.0)
	
	chaos += ch * dir
	attenuation += att * dir
	
	canvas.set_shader_parameter("chaos", chaos)
	canvas.set_shader_parameter("attenuation", attenuation)

func Drink(delta) -> void:
	ModulateChaos(delta, 0.0025, 0.01)
	transform = transform.interpolate_with(target.transform, delta * handSpeed)

func SinkIntoTheVoid(delta) -> void:
	pass
