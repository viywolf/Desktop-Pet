extends Node

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for i in range(Settings.audio_playing.size()):
		var this_sound: AudioStreamPlayer = get_child(i)
		if Settings.audio_playing[i]: 
			if this_sound.playing == false:
				this_sound.play()
		else:
			this_sound.stop()
