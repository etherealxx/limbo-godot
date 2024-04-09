extends Node

const windowsize := 150
const margin := 50

# Called when the node enters the scene tree for the first time.
func _ready():
	var primaryscreenindex = DisplayServer.get_primary_screen()
	var usable_screen_rect = DisplayServer.screen_get_usable_rect(primaryscreenindex)
	var usable_screen_height = usable_screen_rect.size.y
	var usable_screen_width = usable_screen_rect.size.x
	var key_area = usable_screen_rect
	
	if usable_screen_width > usable_screen_height: # standard landscape screen
		key_area.size.x = usable_screen_height # shorthen the width to screen's height
		var key_area_xpos = (usable_screen_width / 2) - (usable_screen_height / 2)
		key_area.position = Vector2i(key_area_xpos, key_area.position.y)
	else:
		pass # implement later
	
	$Window.position = Vector2i(1000,
								1000)
	await get_tree().create_timer(3.0).timeout
	$Window.start_orbiting()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
