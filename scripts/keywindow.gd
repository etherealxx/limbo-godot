extends Window

var ismoving := false
var nextposition : Vector2i

func startmoving():
	ismoving = true

func fillwithintime(value_to_fill, target_value, target_time, delta):
	if value_to_fill < target_value:

		# Calculate increment per frame to reach target in one second
		var incrementPerSecond = float(target_value) / target_time # 1.0 represents one second
		var incrementPerFrame = incrementPerSecond * delta
		
		# Round the increment to the nearest integer
		var roundedIncrement = round(incrementPerFrame)
		
		# Increment number
		value_to_fill += int(roundedIncrement)
		
		# Ensure number does not exceed the target value
		if value_to_fill >= target_value:
			value_to_fill = target_value
			print("Number reached target value: ", target_value)
		
		return value_to_fill
	else:
		return value_to_fill
		
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if ismoving:
		if position == nextposition:
			ismoving = false
		else:
			print(position.x, " ", position.y)
			position = Vector2i(
				fillwithintime(position.x, nextposition.x, 1.0, delta),
				fillwithintime(position.y, nextposition.y, 1.0, delta)
			)
		
