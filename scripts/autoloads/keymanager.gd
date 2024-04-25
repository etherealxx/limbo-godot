extends Node

const polling_rate := 0.05 # (in seconds)
const debugmode := false
var readytomove_list : Array[bool] = []
var mainscene : Node
var ispolling := false
var orbitcenterpos : Vector2i
var correctkeychosen : bool
var checkreducemoves_initiated := false
var reducedwindows_finished := 0
var pollingtimer : Timer

func _ready():
	for x in range(8):
		readytomove_list.append((true)) # ready to move for the first time

func set_correctkey(keybool):
	correctkeychosen = keybool
	if pollingtimer:
		pollingtimer.queue_free()

func get_main():
	mainscene = get_tree().get_root().get_node("Main")
	if debugmode: print(mainscene.get_name())

func startpolling():
	if not ispolling:
		ispolling = true
		pollingtimer = Timer.new()
		pollingtimer.set_wait_time(polling_rate)
		add_child(pollingtimer)
		pollingtimer.timeout.connect(_on_polling)
		VariableKeeper.timerprocesschanger(pollingtimer)
		pollingtimer.start()
	
func donemoving_onewindow():
	readytomove_list.append((true))

func movelist_checksize():
	return readytomove_list.size()

func is_allwindow_moved():
	if movelist_checksize() % 8 == 0 and movelist_checksize() > 0: # multiple of 8
		return true # 8 windows
	else: return false

func allwindow_moving():
	readytomove_list.clear()
	if debugmode: print("window is moving")

func _on_polling():
	if is_allwindow_moved():
		var delaying : int = 0
		for window in mainscene.window_list:
			if window.isdelaying:
				delaying += 1
		if delaying == 8:
			allwindow_moving()

func get_orbitcenterpos():
	return orbitcenterpos
	
func set_orbitcenterpos(value : Vector2i):
	orbitcenterpos = value

#func _exit_tree():
	#if pollingtimer:
		#pollingtimer.queue_free()
		
func _physics_process(_delta):
	if LimboAudio.is_playing_limbo_music() and not checkreducemoves_initiated:
		if LimboAudio.get_playback_position() >= 14.3:
			checkreducemoves_initiated = true
			print("reducemove request sent")
			for window in mainscene.window_list:
				window.checkreducemove()

func prepare_finished():
	reducedwindows_finished += 1
	if reducedwindows_finished >= 8:
		for window in mainscene.window_list:
			window.finishing_move()
