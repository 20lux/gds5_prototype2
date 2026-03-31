extends Node3D

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()

	if Input.is_action_just_pressed("pause"):
		if Input.mouse_mode == Input.MouseMode.MOUSE_MODE_CAPTURED:
			get_tree().paused = true
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			print("Game is paused")
		else:
			get_tree().paused = false
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			print("Resuming game")
