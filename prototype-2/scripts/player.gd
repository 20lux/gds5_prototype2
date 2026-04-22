extends CharacterBody3D
class_name PlayerController

const SPEED = 5.0

@export_group("Head Bob")
@export var camera : Camera3D
@export var headBobFrequency := 2.0
@export var headBobAmplitude := 0.04
var headBobTime := 0.0
var step : int = 0

@export_group("Player Vortex Parameters")
static var isInVortex : bool = false
var playerRosePosY_Min : float
var playerRisePosY_Max : float = 15.0
var playerCurrentPosY : float
@export var playerRiseStep : float = 0.5
@export var amp : float = 10.0
var music : AudioEffectFilter
var defaultVol = -6.0
var mute = -72.0
@export var calmAudioStream : AudioStreamPlayer3D
@export var drinkingGlass : Node

@export_group("Intrusive Thoughts")
@export var intrusiveThoughts : Control
var thoughts : Array = ["All is well", 
"You're doing great out there",
"Just keep calm",
"It's alright",
"You're safe",
"It's ok"]
var minScreenVal = 100
var maxScreenX = 1052
var maxScreenY = 548
var textPosX : float = 100
var textPosY : float = 100
var thoughtChanged = false

func _ready() -> void:
	playerRosePosY_Min = position.y
	
	music = AudioServer.get_bus_effect(2, 0)
	AudioServer.set_bus_volume_db(3, mute)
	
	intrusiveThoughts.get_child(0).modulate = Color(1.0, 1.0, 1.0, 0)
	intrusiveThoughts.get_child(0).text = thoughts[randi_range(0, 2)]

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "forward", "back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	
	# head bob positions only works if the player is not drinking (inserted for immersion)
	if !PlayerDrink.isDrinking:
		headBobTime += delta  * velocity.length() * float(is_on_floor())
		camera.transform.origin = HeadBob(headBobTime)
	
	if isInVortex:
		# audio modulation
		music.cutoff_hz = 500.0
		var currentVolMusic = AudioServer.get_bus_volume_db(2)
		if AudioServer.get_bus_volume_db(2) > -72.0:
			AudioServer.set_bus_volume_db(2, currentVolMusic - 0.05)
		
		AudioServer.set_bus_volume_db(3, defaultVol)
			
		IntrusiveThoughtsOn()
	else:
		IntrusiveThoughtsOff()
		music.cutoff_hz = 2000.0
		AudioServer.set_bus_volume_db(2, defaultVol)
		AudioServer.set_bus_volume_db(3, mute)

func HeadBob(headbob_time):
	var headBobPos = Vector3.ZERO
	headBobPos.y = sin(headbob_time * headBobFrequency) * headBobAmplitude
	headBobPos.x = cos(headbob_time * headBobFrequency / 2) * headBobAmplitude
	return headBobPos

func IntrusiveThoughtsOn() -> void:
	if !thoughtChanged:
		intrusiveThoughts.get_child(0).text = thoughts.pick_random()
		thoughtChanged = true
	
	var modPos = 0
	modPos += 0.1
	intrusiveThoughts.position = Vector2(textPosX, textPosY)
	intrusiveThoughts.get_child(0).modulate += Color(1.0, 1.0, 1.0, clampf(modPos, 0, 1.0))

func IntrusiveThoughtsOff() -> void:
	intrusiveThoughts.get_child(0).modulate = Color(1.0, 1.0, 1.0, 0)
	thoughtChanged = false
	textPosX = randf_range(minScreenVal, maxScreenX)
	textPosY = randf_range(minScreenVal, maxScreenY)
