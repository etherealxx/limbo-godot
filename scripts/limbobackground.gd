extends Control

@export var debug := false
@export var debug_esc_to_quit := false

@onready var timer = $QuitTimer
@onready var sixteenbyninecontrol = $SixteenbyNine
@onready var topbg : Sprite2D = $SixteenbyNine/BlueBG
@onready var bottombg = $SixteenbyNine/PureBlue
@onready var pcicon = $SixteenbyNine/ThisPcIconCont
@onready var spike = $SixteenbyNine/Spikes
@onready var spikehitbox = $SixteenbyNine/SpikeHitbox

var spikemoveupward := false
var correctkey := false
var movetonextscene := false
var bsodscene : PackedScene

func modenumber():
	if (debug) or (VariableKeeper.checkvar("fullscreen_ending") == false):
		return Window.MODE_MAXIMIZED
	else:
		return Window.MODE_EXCLUSIVE_FULLSCREEN
	
# Called when the node enters the scene tree for the first time.
func _ready():
	
	LimboAudio.play_music()
	correctkey = KeyManager.correctkeychosen
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	RenderingServer.set_default_clear_color(Color("000000"))
	
	var currentwindow = get_window()
	currentwindow.set_flag(Window.FLAG_NO_FOCUS, false)
	currentwindow.set_flag(Window.FLAG_TRANSPARENT, false) # idk if this do anything
	get_viewport().set_transparent_background(false) # fixing windows 10 bug
	currentwindow.set_mode(modenumber())
	currentwindow.move_to_foreground()
	currentwindow.grab_focus()
	set_tween_topbg()
	set_tween_bottombg()
	# for context: var currentwindow = get_window()
	self.set_size(currentwindow.get_size())
	if VariableKeeper.sixteen_by_nine_reso or debug:
		sixteenbyninecontrol.set_size(Vector2((currentwindow.size.y * 16 / 9), currentwindow.size.y))
		sixteenbyninecontrol.position.x = currentwindow.size.x / 2 - sixteenbyninecontrol.size.x / 2
	else:
		pass
	var middlescreen = Vector2(sixteenbyninecontrol.size.x / 2, sixteenbyninecontrol.size.y / 2)
	pcicon.position = middlescreen
	spikehitbox.position.x = middlescreen.x
	set_tween_pcicon()
	bsodscene = load("res://scenes/bsod.tscn")

func set_tween_pcicon():
	var tween = create_tween()
	tween.tween_property(pcicon,
	"position:x",
	-200,
	7.0).as_relative().from_current()
	tween.parallel().tween_property(spikehitbox,
	"position:x",
	-200,
	7.0).as_relative().from_current()

func detach_label():
	var thispclabel = pcicon.get_node("Label")
	var labelpos = thispclabel.global_position
	pcicon.remove_child(thispclabel)
	self.add_child(thispclabel)
	thispclabel.position = labelpos
	var tween = create_tween()
	tween.tween_property(thispclabel,
	"position:y",
	-1500,
	3.0).as_relative().from_current()

func set_tween_topbg():
	var tween = create_tween()
	tween.tween_property(topbg,
	"position:x",
	-300,
	7.0).as_relative().from_current()
	tween.parallel().tween_property(topbg,
	"position:y",
	-1500,
	3.0).as_relative().from_current().set_delay(4.0)
	tween.parallel().tween_callback(detach_label).set_delay(4.0)

func set_tween_bottombg():
	var tween = create_tween()
	tween.tween_property(bottombg,
	"position:y",
	-1500,
	3.0).as_relative().from_current().set_delay(4.15)
	tween.parallel().tween_callback(func(): spikemoveupward = true).set_delay(4.15)
	#tween.parallel().tween_property(spike,
	#"position:y",
	#-875,
	#3.0).as_relative().from_current().set_delay(4.15)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	spike.position.x -= delta * 60 * 6
	if spikemoveupward:
		spike.position.y -= delta * 60 * 5
		spikehitbox.position.y -= delta * 60 * 5
	if movetonextscene:
		movetonextscene = false
		LimboAudio.play_sfx()
		#print("inside tree: " + str(is_inside_tree()))
		#print(get_tree_string_pretty())
		while true:
			if bsodscene:
				get_tree().change_scene_to_packed(bsodscene)
				break
		
func _on_spike_hitbox_body_entered(body):
	if body.name == "PCBody":
		spikemoveupward = false
		if not correctkey:
			movetonextscene = true
		else:
			timer.start(VariableKeeper.winning_wait_time)

func _on_quit_timer_timeout():
	get_tree().quit()

func _input(event): # debug
	if debug_esc_to_quit:
		if event.is_action_pressed("quit"):
			get_tree().quit()
			queue_free()
