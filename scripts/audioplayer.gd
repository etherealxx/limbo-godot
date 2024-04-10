extends AudioStreamPlayer

const limbomusic = preload("res://LIMBO.mp3")

func play_music():
	if stream == limbomusic:
		return
	
	stream = limbomusic
	play(176)
