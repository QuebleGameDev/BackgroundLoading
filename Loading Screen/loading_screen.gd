extends CanvasLayer


signal safe_to_load

@onready var animPlayer = $AnimationPlayer


func fade_out_loading_screen():
	animPlayer.play("fade_out")
	await animPlayer.animation_finished
	queue_free()
