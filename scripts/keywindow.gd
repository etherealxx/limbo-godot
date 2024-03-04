extends Window

@onready var timer : Timer = $MoveDelay

var ismoving := false
var initialposition : Vector2
var nextposition : Vector2
var queued_moves : Array[NextMoveAndDelay]
var nextmove : NextMoveAndDelay

func makeemptymove() -> NextMoveAndDelay:
	return NextMoveAndDelay.new(Vector2i.ZERO, 0.0, true)

func delaywait():
	timer.start(nextmove.delay)
	
func startmoving():
	initialposition = Vector2(-1,-1)
	ismoving = true

func queuemove(moveposition : Vector2i, delay : float):
	var newqueue = NextMoveAndDelay.new(moveposition, delay)
	queued_moves.append(newqueue)
	
func _ready():
	nextmove = makeemptymove()
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
		
var t = 0.0

func _physics_process(delta):
	if ismoving:
		if nextmove.isempty() and queued_moves.size() > 0:
			nextmove = queued_moves[0]
		if !nextmove.isempty():
			if position == Vector2i(nextmove.nextpos):
				t = 0.0
				ismoving = false
				initialposition = Vector2(-1,-1)
				delaywait()
				queued_moves.pop_front()
				if queued_moves.size() > 0:
					nextmove = queued_moves[0]
			else:
				if initialposition == Vector2(-1,-1):
					initialposition = position
					
				t += delta * 4
		
				position = Vector2i(initialposition.lerp(nextmove.nextpos, t))
				
				#print(position.x, " ", position.y)
				#position = Vector2i(
					#fillwithintime(position.x, nextposition.x, 1.0, delta),
					#fillwithintime(position.y, nextposition.y, 1.0, delta)
				#)

func _on_move_delay_timeout():
	ismoving = true
