extends Window

@onready var timer : Timer = $MoveDelay

var ismoving := false
var initialposition : Vector2
var windoworder : int
var queued_moves : Array[NextMoveAndDelay]
var nextmove : NextMoveAndDelay
var donefirstmove := false
var isdelaying := false

const default_t_speed := 4.75
#var nextposition : Vector2

func set_order(index):
	windoworder = index

func clearqueue():
	queued_moves.clear()
	nextmove = makeemptymove()

func makeemptymove() -> NextMoveAndDelay:
	return NextMoveAndDelay.new(Vector2i.ZERO, 0.0, 0.0, true)

func delaywait():
	timer.start(nextmove.delay)
	
func startmoving():
	initialposition = Vector2(-1,-1)
	ismoving = true

func queuemove(moveposition : Vector2i, delay : float, t_speed : float = default_t_speed):
	var newqueue = NextMoveAndDelay.new(moveposition, delay, t_speed)
	queued_moves.append(newqueue)
	
func _ready():
	nextmove = makeemptymove()

func _input(event):
	if event.is_action_pressed("debugshuffle"): # F key
		get_parent().startrandommove()

var t = 0.0

func _physics_process(delta):
	if ismoving:
		if nextmove.isempty() and queued_moves.size() > 0: # no nextmove queued and queue is not empty
			nextmove = queued_moves[0] # first item in the queue become the nextmove
			queued_moves.pop_front() # removes next move from the queue
		if !nextmove.isempty(): # nextmove is a valid location
			if position != Vector2i(nextmove.nextpos): # window position haven't arrived on the targeted next position
				if initialposition == Vector2(-1,-1): # if initialpos is empty, fill it with current pos
					initialposition = position
				
				# lerp stuff, basically move the window towards the targeted position
				t += delta * nextmove.t_speed # 4.75
				t = clampf(t, 0.0, 1.0)
				position = Vector2i(initialposition.lerp(nextmove.nextpos, t))
				
			else: # window had arrived
				t = 0.0
				ismoving = false
				initialposition = Vector2(-1,-1) # reset/empty initialpos
				
				#if queued_moves.size() > 0:
					#nextmove = queued_moves[0]
					
				nextmove.setempty() # empty the current nextmove so it can be replaced
				KeyManager.donemoving_onewindow()
				donefirstmove = true
				
				#print(position.x, " ", position.y)
				#position = Vector2i(
					#fillwithintime(position.x, nextposition.x, 1.0, delta),
					#fillwithintime(position.y, nextposition.y, 1.0, delta)
				#)
	else: # not moving
		if KeyManager.is_allwindow_moved() and donefirstmove and !isdelaying:
			isdelaying = true
			delaywait() # delay before nextmove
	
func _on_move_delay_timeout():
	ismoving = true
	isdelaying = false

## unused
#func fillwithintime(value_to_fill, target_value, target_time, delta):
	#if value_to_fill < target_value:
#
		## Calculate increment per frame to reach target in one second
		#var incrementPerSecond = float(target_value) / target_time # 1.0 represents one second
		#var incrementPerFrame = incrementPerSecond * delta
		#
		## Round the increment to the nearest integer
		#var roundedIncrement = round(incrementPerFrame)
		#
		## Increment number
		#value_to_fill += int(roundedIncrement)
		#
		## Ensure number does not exceed the target value
		#if value_to_fill >= target_value:
			#value_to_fill = target_value
			#print("Number reached target value: ", target_value)
		#
		#return value_to_fill
	#else:
		#return value_to_fill
