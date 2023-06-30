extends CanvasLayer


signal safe_to_load

@onready var load_progressBar = $load_ProgressBar

func update_load_progress_bar(new_value : float):
	load_progressBar.value = new_value


# NEED TO FREE SELF!!!