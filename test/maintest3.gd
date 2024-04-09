extends Node

const windowsize := 150
const margin := 50
const window_shuffle_delay = 0.05
const debugdontmove = false

@onready var audioplayer = $AudioStreamPlayer

var window_list : Array[Window]
var window_pos_list : Array[Vector2i]

#var step_map = { # from quasar098's server.py , now unused
	#0:  {0: 4, 1: 5, 2: 6, 3: 7, 4: 0, 5: 1, 6: 2, 7: 3},  # mirror across x axis
	#1:  {0: 1, 1: 2, 2: 3, 3: 4, 4: 5, 5: 6, 6: 7, 7: 0},  # move right column to left and cross
	#2:  {0: 7, 1: 0, 2: 1, 3: 2, 4: 3, 5: 4, 6: 5, 7: 6},  # move left column to right and cross
	#3:  {0: 5, 1: 4, 4: 1, 5: 0, 2: 7, 3: 6, 6: 3, 7: 2},  # two x patterns
	#4:  {0: 3, 1: 2, 2: 1, 3: 0, 4: 7, 5: 6, 6: 5, 7: 4},  # mirror across y axis
	#5:  {0: 7, 1: 6, 2: 5, 3: 4, 4: 3, 5: 2, 6: 1, 7: 0},  # right+right stuff # is this the 10th swap?
	#6:  {0: 1, 1: 5, 5: 4, 4: 0, 2: 3, 3: 7, 7: 6, 6: 2},  # left+left stuff
	#7:  {1: 0, 5: 1, 4: 5, 0: 4, 3: 2, 7: 3, 6: 7, 2: 6},  # right+left stuff
	#8:  {1: 0, 5: 1, 4: 5, 0: 4, 2: 3, 3: 7, 7: 6, 6: 2},  # left+right stuff
	#9:  {0: 6, 1: 7, 2: 4, 3: 5, 4: 2, 5: 3, 6: 0, 7: 1},  # cross 2 wide blocks
	#10: {0: 5, 1: 6, 2: 7, 3: 3, 4: 4, 5: 0, 6: 1, 7: 2},  # swap top left 3 and bottom right 3
	#11: {0: 0, 1: 4, 2: 5, 3: 6, 4: 1, 5: 2, 6: 3, 7: 7},  # swap top right 3 and bottom left 3
	#12: {0: 1, 1: 2, 2: 3, 3: 4, 4: 5, 5: 6, 6: 7, 7: 0},  # ?
	#13: {0: 6, 1: 7, 2: 5, 3: 4, 4: 3, 5: 2, 6: 1, 7: 0}   # 10th swap
#}

var step_map_x = [ # from markhermy3100's Shuffler.ts -> https://github.com/MarkHermy3100/LimboKeys/blob/main/assets/scripts/Shuffler.ts
	 [2, 4, 1, 3, 6, 8, 5, 7], # 0: on each 4 block (top and bottom) spin clockwise
	 [2, 4, 1, 3, 7, 5, 8, 6], # 1: top 4 block: spin clockwise. bottom 4 block: spin counterclockwise
	 [3, 1, 4, 2, 6, 8, 5, 7], # 2: top 4 block: spin counterclockwise. bottom 4 block: spin clockwise
	 [3, 1, 4, 2, 7, 5, 8, 6], # 3: on each 4 block (top and bottom) spin clockwise     original comment -> # 4 small rotations
	 [2, 4, 1, 6, 3, 8, 5, 7], # 4: the whole key, as if it was an O, rotate clockwise 
	 [3, 1, 5, 2, 7, 4, 8, 6], # 5: the whole key, as if it was an O, rotate counterclockwise     original comment -> # 2 big rotations
	 [2, 1, 4, 3, 6, 5, 8, 7], # 6: swap columns  original comment -> # Horizontal swaps
	 [4, 3, 2, 1, 8, 7, 6, 5], # 7: on each 4 block (top and bottom) swaps key in an X shape   original comment -> # Diagonal swaps
	 [3, 4, 5, 6, 7, 8, 2, 1], # 8: top 6 block all go downward 1 step, while previous topleft become bottomright and topright become bottomleft
	 [8, 7, 1, 2, 3, 4, 5, 6], # 9: bottom 6 block all go upward 1 step, while previous topleft become bottomright and topright become bottomleft     original comment -> # Top/Bottom row pushes all keys
	 [1, 3, 2, 5, 4, 7, 8, 6], # 10: complicated, topleft stays
	 [1, 3, 2, 5, 4, 8, 6, 7], # 11: complicated, topleft stays, opposite movements of 10
	 [4, 2, 6, 1, 7, 3, 8, 5], # 12: complicated, topright stays
	 [4, 2, 6, 1, 8, 3, 5, 7], # 13: complicated, topright stays, opposite movements of 12
	 [2, 4, 6, 1, 8, 3, 7, 5], # 14: complicated, bottomleft stays
	 [4, 1, 6, 2, 8, 3, 7, 5], # 15: complicated, bottomleft stays, opposite movements of 14
	 [2, 3, 1, 5, 4, 7, 6, 8], # 16: complicated, bottomright stays
	 [3, 1, 2, 5, 4, 7, 6, 8], # 17: complicated, bottomright stays, opposite movements of 16     original comment -> # 8 shuffles
	
	 [5, 6, 7, 8, 1, 2, 3, 4], # 18: each 4 block (top and bottom) swap places    original comment ->  Block swap
	 [8, 7, 6, 5, 4, 3, 2, 1]  # 19: HARD TO LOOK AT     original comment ->  Circular rotation
	 ]
	
func pickwindow(index) -> Window:
	return window_list[index - 1]

func queueshufflewindow(pattern, delay, speed):
	var i = 0
	for window in window_list:
		# 0:  {0: 4, -> if pattern is 0, and windoworder is 0, then window 0 will be moved to 4
		var order = window.get_last_order()
		var targetwindowindex = step_map_x[pattern][order - 1]
		window.queuemove(window_pos_list[targetwindowindex - 1], delay, speed, targetwindowindex)
		#window.nextposition = window_pos_list[targetwindowindex]
		i += 1

func emptyqueuewindow():
	for window in window_list:
		window.clearqueue()

func get_random_pattern(excluded_pattern: Array) -> int:
	var pattern = -1
	while pattern in excluded_pattern or pattern == -1:
		pattern = randi_range(0, step_map_x.size() - 1)
	return pattern

func startrandommove(movepattern := -1):
	emptyqueuewindow()

	var excluded_pattern = [8, 9, 18, 19]
	var shufflepattern = get_random_pattern(excluded_pattern)
	#var shufflepattern = randi_range(0, step_map_x.size() - 1)
	if movepattern == -1:
		queueshufflewindow(shufflepattern, 0.1, 0.3)
	else:
		queueshufflewindow(movepattern, 0.1, 0.3)

	KeyManager.allwindow_moving()
	KeyManager.startpolling()
	for window in window_list:
		window.startmoving()

func _ready():
	KeyManager.get_main()
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
		window_instance.set_order(loopstep)
		if loopstep == 0:
			window_instance.debugmessage = true
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
	
	if not debugdontmove:
		## 5 second delay, minus 0.2 * 8
		await get_tree().create_timer(3.4).timeout
		
		#pickwindow(1).nextposition = pickwindow(8).position
		#print(Time.get_time_string_from_system())
		#print(pickwindow(8).position)
		#pickwindow(1).startmoving()
			
		## get random shuffle pattern
		var i = 1
		for x in range(26):
			var excluded_pattern = [8, 9, 18, 19]
			var shufflepattern = get_random_pattern(excluded_pattern)
			#var shufflepattern = randi_range(0, 12) # step_map.size() - 1)
			
			#if i == 5:
				#shufflewindow(0)
				#await get_tree().create_timer(0.6).timeout
			#else:
			
			if i == 6: # 6th swap, bottom 4 swap with top 4
				queueshufflewindow(18, 3 * window_shuffle_delay, 0.5)
			elif i == 10:
				# 10th swap, bottom 6 rotated then become top 6. previous top 2 rotated then become bottom 2.
				# all key rotated in place becoming upside down
				queueshufflewindow(8, 4 * window_shuffle_delay, 0.5)
			elif i == 19: # 19th swap, the opposite of 6th swap
				queueshufflewindow(9, 3 * window_shuffle_delay, 0.5)
			else:
				queueshufflewindow(shufflepattern, window_shuffle_delay, 0.3)
			i += 1
		
		KeyManager.allwindow_moving()
		KeyManager.startpolling()
		for window in window_list:
			window.startmoving()
		#shufflewindow(0)
		
		
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

func _on_debug_timer_timeout():
	print(KeyManager.movelist_checksize())