extends Node

#var limboendingscene = preload("res://scenes/limbobackground.tscn")
#var bsodscene = preload("res://scenes/bsod.tscn")

# default values
var sixteen_by_nine_reso := false
var fullscreen_ending := true
var winning_wait_time := 3.0
var bluescreen_wait_time := 7.0
var transparent_background := true
var hide_border_on_maximize := true
var physics_process := true
var small_height_resolution := false
var main_saved_values

func checkvar(varname : String) -> bool:
	var truth := false
	if self.get(varname) == true:
		truth = true
	print("value of variable %s : %s" % [varname, self.get(varname)])
	if self.get(varname) == null:
		push_error("Property not found: " + varname)
	return truth

func tweenprocesschanger(tween : Tween):
	if physics_process:
		tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)

func timerprocesschanger(timer : Timer):
	if physics_process:
		timer.set_timer_process_callback(Timer.TIMER_PROCESS_PHYSICS)
#func config_set_value_from_variable_name(mainnode, configfile, varname):
	#configfile.set_value("settings", varname, mainnode.get(varname))
