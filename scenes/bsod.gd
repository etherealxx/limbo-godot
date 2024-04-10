extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	LimboAudio.stop()
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	var currentwindow = get_window()
	self.set_size(currentwindow.get_size())

func _on_quit_timer_timeout():
	get_tree().quit()

func _input(event): # debug
	if event.is_action_pressed("quit"):
		get_tree().quit()
