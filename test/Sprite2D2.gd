extends Node2D

# Properties
var d := 0.0
var a := 50.0  # Horizontal radius
var b := 30.0  # Vertical radius
var speed := 2.0
var initial_position_set := false
var moving_to_path := false
var move_duration := 1.0
var move_timer := 0.0
var initial_position := Vector2()
var entry_angle := 0.0

func _process(delta) -> void:
	if not initial_position_set:
		initial_position_set = true
		initial_position = position - Vector2(75, 75)
		var distance_to_path = initial_position.length() - (a + b) / 2.0
		if distance_to_path > 0:
			# Start moving towards the closest point on the oval-shaped path
			moving_to_path = true
			move_timer = 0.0
			entry_angle = atan2(initial_position.y, initial_position.x)
			return
	
	if moving_to_path:
		move_timer += delta
		var t = move_timer / move_duration
		if t >= 1.0:
			moving_to_path = false
			d = entry_angle  # Set the entry angle for orbiting
		else:
			# Interpolate position towards the closest point on the oval-shaped path
			position = initial_position.lerp(initial_position.normalized() * Vector2(a, b), t) + Vector2(75, 75)
			return
	
	d += delta * speed
	
	position = Vector2(
		cos(d) * a,
		sin(d) * b
	) + Vector2(75, 75)
