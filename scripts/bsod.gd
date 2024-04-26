extends Control

var percentage := 0

@export var debug := false
@export var debugsmallheight := false

@onready var sixteenbyninecontrol = $SixteenbyNine
@onready var percentlabel = $SixteenbyNine/HBoxContainer/VBoxContainer/HBoxContainer2/percentcomplete
@onready var percenttimer = $PercentTimer
@onready var quittimer = $QuitTimer

var slboot_small = load("res://resources/labelsettings/bsod_slboot_smallheight.tres")

func _ready():
	if debugsmallheight or VariableKeeper.small_height_resolution:
		$SixteenbyNine/HBoxContainer/LeftBorderRect.set_custom_minimum_size(Vector2(131,0))
		$SixteenbyNine/HBoxContainer/VBoxContainer/TopBorderRect.set_custom_minimum_size(Vector2(0,73))
		$SixteenbyNine/HBoxContainer/VBoxContainer/frown.get_label_settings().set_font_size(145)
		$SixteenbyNine/HBoxContainer/VBoxContainer/HBoxContainer/yourpc.set_label_settings(slboot_small)
		$SixteenbyNine/HBoxContainer/VBoxContainer/HBoxContainer2/percentcomplete.set_label_settings(slboot_small)
		
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
	VariableKeeper.timerprocesschanger(quittimer)
	VariableKeeper.timerprocesschanger(percenttimer)
	quittimer.start(VariableKeeper.bluescreen_wait_time)
	await get_tree().create_timer(0.5).timeout
	percenttimer.start()

func _on_quit_timer_timeout():
	get_tree().quit()

func _input(event): # debug
	if event.is_action_pressed("quit"):
		get_tree().quit()

func _on_percent_timer_timeout():
	percentage += randi_range(3, 9)
	percentlabel.set_text(str(percentage) + "% complete")
	percenttimer.start(randf_range(0.7, 1.4))
