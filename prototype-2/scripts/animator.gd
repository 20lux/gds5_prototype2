extends Node3D
class_name PlayerAnimation

@export var animationPlayer : AnimationPlayer
@export var audioPlayer : AudioStreamPlayer3D

func Drink() -> void:
	animationPlayer.pause()
	if !animationPlayer.is_playing():
		audioPlayer.play()
		animationPlayer.speed_scale = 1.1
		animationPlayer.play("drink")
	else:
		audioPlayer.stop()
