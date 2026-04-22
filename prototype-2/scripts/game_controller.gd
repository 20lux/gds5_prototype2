extends Node3D

@export var pauseMenu : CanvasLayer

func _ready() -> void:
	pauseMenu.hide()
	get_tree().paused = false

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		if !get_tree().paused:
			get_tree().paused = true
			Input.mouse_mode = Input.MOUSE_MODE_CONFINED
			pauseMenu.show()
		elif get_tree().paused:
			_on_resume_pressed()

func _on_resume_pressed() -> void:
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	pauseMenu.hide()

func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()

func _on_quit_pressed() -> void:
	get_tree().quit()
