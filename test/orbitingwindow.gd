extends Window

# Properties
var d := 0.0
var a := 500.0  # Horizontal radius
var b := 300.0  # Vertical radius
var speed := 2.0
var initial_position_set := false
var moving_to_path := false
var move_duration := 1.0
var move_timer := 0.0
var before_orbit_initial_position := Vector2()
#var entry_angle := 0.0
var pathing_orbit := false
var orbiting := false

var orbitpos : Vector2i
var halfsize : Vector2i

func _on_arriving_in_orbit(entry_angle):
	d = entry_angle
	orbiting = true
	
func start_orbiting():
	pathing_orbit = true
	initial_position_set = true
	before_orbit_initial_position = Vector2(position) - Vector2(orbitpos)
	var distance_to_path = before_orbit_initial_position.length() - (a + b) / 2.0
	if distance_to_path > 0:
		var entry_angle = atan2(before_orbit_initial_position.y, before_orbit_initial_position.x)
		var tween = create_tween()
		# change the duration later to t_speed
		
		var target_angle = deg_to_rad(0)
		var target_position = Vector2i(cos(target_angle) * a, sin(target_angle) * b) + orbitpos - halfsize
		tween.tween_property(self, "position", target_position, 1.0).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
		#tween.tween_property(self, "position", (Vector2i(before_orbit_initial_position.normalized() * Vector2(a, b)) + orbitpos - halfsize), 1.0).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
		tween.tween_callback(_on_arriving_in_orbit.bind(target_angle))
	else:
		orbiting = true
				
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
	
	orbitpos = Vector2i(key_area.position.x + (key_area.size.x / 2),
								key_area.size.y / 2)
								
	halfsize = Vector2i(
		roundi(size.x / 2),
		roundi(size.y / 2),
	)

func _process(delta) -> void:
	if pathing_orbit:
		#if moving_to_path:
			#move_timer += delta
			#var t = move_timer / move_duration
			#if t >= 1.0:
				#moving_to_path = false
				#d = entry_angle  # Set the entry angle for orbiting
			#else:
				## Interpolate position towards the closest point on the oval-shaped path
				#var temppos = before_orbit_initial_position.lerp(before_orbit_initial_position.normalized() * Vector2(a, b), t) + Vector2(75, 75)
				#position = Vector2i(roundi(temppos.x), roundi(temppos.y))
				#return
		
		if orbiting:
			d += delta * speed
			
			position = Vector2i(
				roundi(cos(d) * a),
				roundi(sin(d) * b)
			) + orbitpos - halfsize

