extends Node

const windowsize := 150
const margin := 50

@onready var audioplayer = $AudioStreamPlayer

var window_list : Array[Window]
var window_pos_list : Array[Vector2i]

var step_map = { # from quasar098's server.py
	0:  {0: 4, 1: 5, 2: 6, 3: 7, 4: 0, 5: 1, 6: 2, 7: 3},  # mirror across x axis
	1:  {0: 1, 1: 2, 2: 3, 3: 4, 4: 5, 5: 6, 6: 7, 7: 0},  # move right column to left and cross
	2:  {0: 7, 1: 0, 2: 1, 3: 2, 4: 3, 5: 4, 6: 5, 7: 6},  # move left column to right and cross
	3:  {0: 5, 1: 4, 4: 1, 5: 0, 2: 7, 3: 6, 6: 3, 7: 2},  # two x patterns
	4:  {0: 3, 1: 2, 2: 1, 3: 0, 4: 7, 5: 6, 6: 5, 7: 4},  # mirror across y axis
	5:  {0: 7, 1: 6, 2: 5, 3: 4, 4: 3, 5: 2, 6: 1, 7: 0},  # right+right stuff
	6:  {0: 1, 1: 5, 5: 4, 4: 0, 2: 3, 3: 7, 7: 6, 6: 2},  # left+left stuff
	7:  {1: 0, 5: 1, 4: 5, 0: 4, 3: 2, 7: 3, 6: 7, 2: 6},  # right+left stuff
	8:  {1: 0, 5: 1, 4: 5, 0: 4, 2: 3, 3: 7, 7: 6, 6: 2},  # left+right stuff
	9:  {0: 6, 1: 7, 2: 4, 3: 5, 4: 2, 5: 3, 6: 0, 7: 1},  # cross 2 wide blocks
	10: {0: 5, 1: 6, 2: 7, 3: 3, 4: 4, 5: 0, 6: 1, 7: 2},  # swap top left 3 and bottom right 3
	11: {0: 0, 1: 4, 2: 5, 3: 6, 4: 1, 5: 2, 6: 3, 7: 7},  # swap top right 3 and bottom left 3
	12: {0: 1, 1: 2, 2: 3, 3: 4, 4: 5, 5: 6, 6: 7, 7: 0}
}

func pickwindow(index) -> Window:
	return window_list[index - 1]

func queueshufflewindow(pattern, delay):
	var i = 0
	for window in window_list:
		var targetwindowindex = step_map[pattern][i]
		window.queuemove(window_pos_list[targetwindowindex], delay)
		#window.nextposition = window_pos_list[targetwindowindex]
		i += 1

func emptyqueuewindow():
	for window in window_list:
		window.clearqueue()

func startrandommove():
	emptyqueuewindow()
	var shufflepattern = randi_range(0, step_map.size() - 1)
	queueshufflewindow(shufflepattern, 0.3)
		
	for window in window_list:
		window.startmoving()

func _ready():
	audioplayer.play(176)
	
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
		window_pos_list.append(window_instance.position)
		await get_tree().create_timer(0.2).timeout
	
	## 5 second delay, minus 0.2 * 8
	#await get_tree().create_timer(3.4).timeout
	
	#pickwindow(1).nextposition = pickwindow(8).position
	#print(Time.get_time_string_from_system())
	#print(pickwindow(8).position)
	#pickwindow(1).startmoving()
		
	### get random shuffle pattern
	#var i = 0
	#for x in range(20):
		#var shufflepattern = randi_range(0, step_map.size() - 1)
		##if i == 5:
			##shufflewindow(0)
			##await get_tree().create_timer(0.6).timeout
		##else:
		#queueshufflewindow(shufflepattern, 0.3)
		#i += 1
		#
	#for window in window_list:
		#window.startmoving()
	##shufflewindow(0)
		
		
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