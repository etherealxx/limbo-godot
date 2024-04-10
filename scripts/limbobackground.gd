extends Control

@onready var topbg : Sprite2D = $BlueBG
@onready var bottombg = $PureBlue

# Called when the node enters the scene tree for the first time.
func _ready():
	RenderingServer.set_default_clear_color(Color("000000"))
	var currentwindow = get_window()
	currentwindow.set_mode(2)
	currentwindow.grab_focus()
	set_tween_topbg()
	set_tween_bottombg()

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

func set_tween_bottombg():
	var tween = create_tween()
	tween.tween_property(bottombg,
	"position:y",
	-1500,
	3.0).as_relative().from_current().set_delay(4.15)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
