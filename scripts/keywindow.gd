extends Window

@onready var timer : Timer = $MoveDelay
@onready var key := $CanvasLayer/InsideWindow

var debugmessage := false
var ismoving := false
var initialposition : Vector2
var windoworder : int
var xth_move := 0
var queued_moves : Array[NextMoveAndDelay]
var nextmove : NextMoveAndDelay
var donefirstmove := false
var isdelaying := false
var waitingfordelay := false

const default_speed := 2.0
#var nextposition : Vector2

# orbiting stuff
var halfsize : Vector2i
var orbitcenterpos : Vector2i
#var entry_angle
var orbit_d := 0.0
var orbitoval_a := 300.0  # Horizontal radius of orbit
var orbitoval_b := 200.0  # Vertical radius of orbit
var orbiting := false
var orbit_speed := 0.25

func _ready():
	nextmove = makeemptymove()
	get_viewport().set_transparent_background(true)
	halfsize = Vector2i(
		roundi(size.x / 2),
		roundi(size.y / 2),
	)

func get_order():
	return windoworder

func get_last_order():
	if queued_moves.size() > 0:
		return queued_moves.back().nextorder
		#if debugmessage: print("nextorder %d" % queued_moves[-1].nextorder)
	else:
		return windoworder
		
func set_order(index):
	windoworder = index

func clearqueue():
	queued_moves.clear()
	nextmove = makeemptymove()
	xth_move = 0
	if debugmessage: print("window %d, queue cleared" % windoworder)

func makeemptymove() -> NextMoveAndDelay:
	return NextMoveAndDelay.new(Vector2i.ZERO, 0.0, 0.0, -1, true)

func delaywait():
	timer.start(nextmove.delay)
	
func startmoving():
	initialposition = Vector2(-1,-1)
	move()

func queuemove(moveposition : Vector2i, delay : float, speed : float = default_speed, nextorder := -1):
	var newqueue = NextMoveAndDelay.new(moveposition, delay, speed, nextorder)
	queued_moves.append(newqueue)

func _input(event): # debug
	if event.is_action_pressed("debugshuffle"): # F key
		get_parent().startrandommove()
	elif event.is_action_pressed("debugrotate"): # R key
		key.tween_rotate()

func _on_move_ends():
	initialposition = Vector2(-1,-1)
	windoworder = nextmove.nextorder
	nextmove.setempty() # empty the current nextmove so it can be replaced
	KeyManager.donemoving_onewindow()
	donefirstmove = true
	waitingfordelay = true
	
func move():
	if nextmove.isempty() and queued_moves.size() > 0: # no nextmove queued and queue is not empty
		nextmove = queued_moves[0] # first item in the queue become the nextmove
		queued_moves.pop_front() # removes next move from the queue
		xth_move += 1
		if xth_move == 10 or xth_move == 19:
			key.tween_rotate()
		
		if xth_move == 26:
			queue_orbit_movement()
			key.queue_rotate(float(0.1 * windoworder), 360, 0.6)
			#key.tween_rotate(360, 1.2)
			return
			
		if debugmessage: print("window %d, moving from %v to %v" % [windoworder, position, nextmove.nextpos])
		
	if !nextmove.isempty(): # nextmove is a valid location
		if initialposition == Vector2(-1,-1): # if initialpos is empty, fill it with current pos
			initialposition = position
		
		var tween = create_tween()
		# change the duration later to t_speed
		tween.tween_property(self, "position", nextmove.nextpos, nextmove.speed).set_trans(Tween.TRANS_QUART)
		tween.tween_callback(_on_move_ends)

func _process(delta):
	if waitingfordelay:
		if KeyManager.is_allwindow_moved() and donefirstmove and !isdelaying:
			waitingfordelay = false
			isdelaying = true
			delaywait() # delay before nextmove
			
	if orbiting:
		orbit_d += delta * orbit_speed
		
		position = Vector2i(
			roundi(cos(orbit_d) * orbitoval_a),
			roundi(sin(orbit_d) * orbitoval_b)
		) + orbitcenterpos - halfsize
		
func _on_move_delay_timeout():
	isdelaying = false
	move()
	
func queue_orbit_movement():
	orbitcenterpos = KeyManager.get_orbitcenterpos()
	var preorbit_initialpos = Vector2(position) - Vector2(orbitcenterpos)
	var distance_to_path = preorbit_initialpos.length() - (orbitoval_a + orbitoval_b) / 2.0
	if distance_to_path != 0:
		#var entry_angle = atan2(preorbit_initialpos.y, preorbit_initialpos.x) # old code for shortest path
		var tween = create_tween()
		var entry_angle = deg_to_rad(float(windoworder * 45)) # target angle
		var target_position = Vector2i(cos(entry_angle) * orbitoval_a, sin(entry_angle) * orbitoval_b) + orbitcenterpos - halfsize
		# old tween code for shortest path 👇
		#tween.tween_property(self, "position",
		#(Vector2i(preorbit_initialpos.normalized() * Vector2(orbitoval_a, orbitoval_b)) + orbitcenterpos - halfsize), 1.0).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
		tween.tween_property(self, "position", target_position, 1.0).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
		tween.tween_callback(_on_arriving_in_orbit.bind(entry_angle))
	else:
		orbiting = true
		
func _on_arriving_in_orbit(angle):
	orbit_d = angle
	orbiting = true
