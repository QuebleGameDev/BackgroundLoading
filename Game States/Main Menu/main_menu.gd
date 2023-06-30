extends Node2D





func _on_play_button_pressed():
	print("Button pressed")
	Global.load_scene(self, "game_world")
