extends Control

@onready var key = $Key
@onready var timer : Timer = $DelayTimer

var key_colors = [
	"fa0000", "ff35ee", # fa0000 was replaced bcoz it looks too similiar to the orange # e75757 backup
	"b200ff", "1516fb",
	"1afeff", "27ff1a",
	"fffe39", "ff8c00",
	]
	
#func keyshader_set_targetcolor(keyshader : Shader, target: String):
	#keyshader.set("shader_parameter/u_color_key", Color(target))
#
#func keyshader_set_replacementcolor(keyshader : Shader, target: String):
	#keyshader.set("shader_parameter/u_replacement_color", Color(target))
#
#func keyshader_set_tolerance(keyshader : Shader, tolerance: float):
	#keyshader.set("shader_parameter/u_tolerance", tolerance)

func _ready():
	key.material = key.material.duplicate() # make unique
	
func tween_rotate(degree := 180.0, duration := 0.4):
	var tween = create_tween()
	tween.tween_property(key,
	"rotation_degrees",
	degree,
	duration).as_relative().from_current().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)

func queue_rotate(delay : float, degree : float, duration : float):
	timer.timeout.connect(_on_timer_delay_finished.bind(degree, duration))
	timer.start(delay)

func _on_timer_delay_finished(degree, duration):
	tween_rotate(degree, duration)

func desaturize_color(colorcode : String):
	var new_color = Color(colorcode)
	new_color.s -= 0.3 # saturation
	return new_color

func flash_green():
	var keyshader : ShaderMaterial = key.get_material()
	keyshader.set_shader_parameter("u_color_key1", Color("ff0006")) # the orange part of the default orange key
	keyshader.set_shader_parameter("u_color_key2", Color("eee42b")) # the yellow part of the default orange key
	keyshader.set_shader_parameter("u_replacement_color1", Color("00ea00"))
	keyshader.set_shader_parameter("u_replacement_color2", desaturize_color("00ea00"))
	keyshader.set_shader_parameter("u_tolerance", 0.855)
	keyshader.set_shader_parameter("u_interpolation_factor", 0.0)
	
	var tween = create_tween()
	tween.tween_property(keyshader,
	"shader_parameter/u_interpolation_factor",
	1.0, # final value
	0.5) # duration
	tween.tween_property(keyshader,
	"shader_parameter/u_interpolation_factor",
	0.0, # final value
	0.5).set_delay(0.1) # duration
	tween.parallel().tween_property(keyshader,
	"shader_parameter/u_tolerance",
	0.0, # final value
	0.7) # duration

func _input(event): # debug
	if event.is_action_pressed("debugshuffle"): # F key
		flash_green()

func shift_color(index):

	var keyshader : ShaderMaterial = key.get_material()
	keyshader.set_shader_parameter("u_color_key1", Color("ff0006"))
	keyshader.set_shader_parameter("u_color_key2", Color("eee42b"))
	#if key_colors[index] == "e75757":
		#keyshader.set_shader_parameter("u_color_key", Color("eee42b"))
	keyshader.set_shader_parameter("u_replacement_color1", Color(key_colors[index]))
	keyshader.set_shader_parameter("u_replacement_color2", desaturize_color(key_colors[index]))
	keyshader.set_shader_parameter("u_tolerance", 0.855)
	keyshader.set_shader_parameter("u_interpolation_factor", 0.0)
	
	var tween = create_tween()
	tween.tween_property(keyshader,
	"shader_parameter/u_interpolation_factor",
	1.0, # final value
	1.0) # duration
