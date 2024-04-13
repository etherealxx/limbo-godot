extends AudioStreamPlayer

@export var debugplaytest := false
@export var play_at := 0.0

const limbomusic = preload("res://assets/musics/isolation_keypart_cut.mp3")
const deathsfx = preload("res://assets/sfx/geometry-dash-death-sound-effect.mp3")

func play_music():
	if stream == limbomusic:
		return
	
	stream = limbomusic
	#play(176) # original limbo song
	play(play_at)

func play_sfx():
	if stream:
		stop()
	stream = deathsfx
	play()

func _ready():
	if debugplaytest:
		play_music()
