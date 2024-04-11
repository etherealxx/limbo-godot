extends AudioStreamPlayer

const limbomusic = preload("res://assets/musics/isolation_keypart_cut.mp3")

func play_music():
	if stream == limbomusic:
		return
	
	stream = limbomusic
	#play(176) # original limbo song
	play()
