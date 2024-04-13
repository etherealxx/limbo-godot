extends Control

var percentage := 0

@export var debug := false
@onready var sixteenbyninecontrol = $SixteenbyNine
@onready var percentlabel = $SixteenbyNine/HBoxContainer/VBoxContainer/HBoxContainer2/percentcomplete
@onready var percenttimer = $PercentTimer
@onready var quittimer = $QuitTimer

func _ready():
	ProjectSettings.set("display/window/per_pixel_transparency/allowed", false)
	get_viewport().set_transparent_background(false)
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	var currentwindow = get_window()
	self.set_size(currentwindow.get_size())
	if VariableKeeper.sixteen_by_nine_reso or debug:
		sixteenbyninecontrol.set_size(Vector2((currentwindow.size.y * 16 / 9), currentwindow.size.y))
		sixteenbyninecontrol.position.x = currentwindow.size.x / 2 - sixteenbyninecontrol.size.x / 2
	else:
		pass
	currentwindow.set_flag(Window.FLAG_TRANSPARENT, false)
	quittimer.start(VariableKeeper.bluescreen_wait_time)
	await get_tree().create_timer(0.5).timeout
	percenttimer.start()

func _on_quit_timer_timeout():
	get_tree().quit()

func _input(event): # debug
	if event.is_action_pressed("quit"):
		get_tree().quit()
		queue_free()

func _on_percent_timer_timeout():
	percentage += randi_range(3, 9)
	percentlabel.set_text(str(percentage) + "% complete")
	percenttimer.start(randf_range(0.7, 1.4))
