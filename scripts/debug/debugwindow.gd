extends Window

@onready var inside = $CanvasLayer/insidedebugwindow
@onready var mainscript = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready():
	var xpos := 5.0
	var ypos := 5.0
	var i = 0
	for x in range(20):
		if (i % 3) == 0 and i != 0:
			ypos += 40
			xpos = 5.0
		var newbutton = Button.new()
		newbutton.set_size(Vector2(35,35))
		newbutton.set_text(str(i))
		inside.add_child(newbutton)
		newbutton.global_position = Vector2(xpos, ypos)
		newbutton.pressed.connect(func(): debugclick(i))
		xpos += 40
		i += 1

func debugclick(moveindex):
	mainscript.startrandommove(moveindex)
