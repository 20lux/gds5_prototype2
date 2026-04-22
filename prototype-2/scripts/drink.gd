extends Node3D
class_name PlayerDrink

@export_group("Audio Visual Parameters")
@export var audioPlayer : AudioStreamPlayer3D
@export var canvas : ShaderMaterial
var dir = 0
static var isDrinking : bool = false

@export_group("Player Body Transform Parameters")
@export var mouth : Node3D
@export var rightHand : Node3D
@export_range(1, 50, 1) var handSpeed : float = 1
@export var head : Node3D
@export_range(1, 50, 1) var headSpeed : float = 1
@export var theVoid : Node3D

var target : Node3D
var chaos : float = 1.0
var radius : float = 1.0
var attenuation : float = 1.0
@export var deprecation : float = 1.0

func _ready() -> void:
	transform = rightHand.transform
	canvas.set_shader_parameter("radius", radius)

func _physics_process(delta: float) -> void:
	if !PlayerController.isInVortex:
		var drink = self.get_children(false)
		for i in drink.size():
			drink[i].show()

		if Input.is_action_pressed("action", true):
			isDrinking = true
			target = mouth
			audioPlayer.play()
			SetDir(1)
		else:
			isDrinking = false
			SetDir(-1)
			target = rightHand
			
		Drink(delta)
	else:
		var drink = self.get_children(false)
		for i in drink.size():
			drink[i].hide()

func SetDir(_dir: int):
	dir = _dir
	return dir

func ModulateChaos(ch: float, att: float) -> void:
	chaos = clampf(chaos + ch * dir, 0.0, 32.0)
	attenuation = clampf(attenuation + att * dir, 1.0, 5.0)
	
	canvas.set_shader_parameter("chaos", chaos)
	canvas.set_shader_parameter("attenuation", attenuation)

func Drink(delta) -> void:
	ModulateChaos(0.025, 0.01)
	transform = transform.interpolate_with(target.transform, delta * handSpeed)
