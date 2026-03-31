extends CharacterBody3D
class_name PlayerController

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@export_group("Drinking")
@export var drink : PlayerDrink

@export_group("Head Bob")
@export var camera : Camera3D
@export var headBobFrequency := 2.0
@export var headBobAmplitude := 0.04
var headBobTime := 0.0
var step : int = 0

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
	
	# head bob positions
	if !drink.isDrinking:
		headBobTime += delta  * velocity.length() * float(is_on_floor())
		camera.transform.origin = HeadBob(headBobTime)
	
func HeadBob(headbob_time):
	var headBobPos = Vector3.ZERO
	headBobPos.y = sin(headbob_time * headBobFrequency) * headBobAmplitude
	headBobPos.x = cos(headbob_time * headBobFrequency / 2) * headBobAmplitude
	return headBobPos
