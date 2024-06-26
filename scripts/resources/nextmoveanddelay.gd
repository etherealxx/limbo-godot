extends Resource
class_name NextMoveAndDelay

var nextpos : Vector2i
var delay : float
var speed : float
var nextorder : int
var empty : bool = false

func _init(	_nextpos : Vector2i = Vector2i.ZERO,
			_delay : float = 0.0,
			_speed : float = 0.0,
			_nextorder := -1,
			_empty : bool = false):
				
	nextpos = _nextpos
	delay = _delay
	speed = _speed
	nextorder = _nextorder
	empty = _empty

func isempty():
	return empty
	
func setempty():
	empty = true
#func setup(_nextpos : Vector2i, _delay : float):
	#nextpos = _nextpos
	#delay = _delay
