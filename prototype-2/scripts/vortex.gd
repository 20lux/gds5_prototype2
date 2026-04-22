extends Area3D
class_name VortexController

func _on_body_entered(body: Node3D) -> void:
	if "Player" in body.name:
		PlayerController.isInVortex = true

func _on_body_exited(body: Node3D) -> void:
	if "Player" in body.name:
		PlayerController.isInVortex = false
