extends Control

@onready var key = $Key
@onready var timer : Timer = $DelayTimer

func tween_rotate(degree := 180.0, duration := 0.4):
	var tween = create_tween()
	tween.tween_property(key,
	"rotation_degrees",
	degree,
	duration).as_relative().from_current().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)

func queue_rotate(delay : float, degree : float, duration : float):
	timer.timeout.connect(_on_timer_delay_finished.bind(degree, duration))
	timer.start(delay)

func _on_timer_delay_finished(degree, duration):
	tween_rotate(degree, duration)
