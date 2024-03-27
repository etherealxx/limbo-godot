extends Node

const polling_rate := 0.1 # (in seconds)
var readytomove_list : Array[bool] = []
var mainscene : Node

func _ready():
	for x in range(8):
		readytomove_list.append((true)) # ready to move for the first time

func get_main():
	mainscene = get_tree().get_root().get_node("Main")
	print(mainscene.get_name())

func startpolling():
	var newtimer = Timer.new()
	newtimer.set_wait_time(polling_rate)
	add_child(newtimer)
	newtimer.timeout.connect(_on_polling)
	newtimer.start()
	
func donemoving_onewindow():
	readytomove_list.append((true))

func movelist_checksize():
	return readytomove_list.size()

func is_allwindow_moved():
	if movelist_checksize() == 8: return true # 8 windows
	else: return false

func allwindow_moving():
	readytomove_list.clear()

func _on_polling():
	if is_allwindow_moved():
		var delaying : int = 0
		for window in mainscene.window_list:
			if window.isdelaying:
				delaying += 1
		if delaying == 8:
			allwindow_moving()
