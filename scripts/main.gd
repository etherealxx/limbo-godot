extends Node

const windowsize := 150
const margin := 50

var window_list : Array[Window]

func pickwindow(index) -> Window:
	return window_list[index - 1]

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
		
	print(key_area.position, key_area.size)
	
	var spawn_xpos = key_area.position.x + (key_area.size.x / 2) - windowsize - margin
	var spawn_ypos = key_area.size.y / 8
	var loopstep = 0
	
	for x in range(8):
		var window_instance : Window = load("res://scenes/keywindow.tscn").instantiate()
		add_child(window_instance)
		
		if loopstep > 0:
			if loopstep % 2 == 0:
				spawn_ypos += windowsize + int(margin * 1.5)
				spawn_xpos = key_area.position.x + (key_area.size.x / 2) - windowsize - margin # reset
			else:
				spawn_xpos += windowsize + margin
		
		window_instance.position = Vector2i(spawn_xpos, spawn_ypos)
		
		window_list.append(window_instance)
		loopstep += 1
		await get_tree().create_timer(0.2).timeout

	await get_tree().create_timer(1.0).timeout
	
	pickwindow(1).nextposition = pickwindow(8).position
	pickwindow(1).startmoving()
		
		
		
		
#
#var number : int = 0
#var target = 0
#var timeElapsed = 0
#
#func fillinasecond(target_value, delta):
	#if number < target_value:
		#target = target_value
		#timeElapsed += delta
		#
		## Calculate increment per frame to reach target in one second
		#var incrementPerSecond = float(target) / 1.0 # 1.0 represents one second
		#var incrementPerFrame = incrementPerSecond * delta
		#
		## Round the increment to the nearest integer
		#var roundedIncrement = round(incrementPerFrame)
		#
		## Increment number
		#number += int(roundedIncrement)
		#
		## Ensure number does not exceed the target value
		#if number >= target:
			#number = target
			#print("Number reached target value: ", target)
#
#func _process(delta):
	#fillinasecond(10000, delta)
	#if number < 10000:
		#print(number)
	#
