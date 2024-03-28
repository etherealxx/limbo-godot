extends Control

@onready var key = $Key

func tween_rotate():
	var tween = create_tween()
	tween.tween_property(key, "rotation_degrees", 180, 0.4).as_relative().from_current()
