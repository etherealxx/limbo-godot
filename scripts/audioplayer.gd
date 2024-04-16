extends AudioStreamPlayer

@export var debugplaytest := false
@export var play_at := 0.0

const limbomusic = preload("res://assets/musics/isolation_keypart_cut.mp3")
const deathsfx = preload("res://assets/sfx/geometry-dash-death-sound-effect.mp3")
const winsfx = preload("res://assets/sfx/level-complete-geometry-dash.mp3")

func set_volume(volume): # volume is between 0 and 20. default is 20
	set_volume_db(volume - 20)

func play_music():
	if stream == limbomusic:
		return
	
	stream = limbomusic
	#play(176) # original limbo song
	play(play_at)

func play_sfx(winning := false):
	if stream:
		stop()
	if winning: stream = winsfx
	else: stream = deathsfx
	play()

func _ready():
	if debugplaytest:
		play_music()
