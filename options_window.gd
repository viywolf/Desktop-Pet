extends Window

var mouse_in_top_bar := false
var mouse_down := false

func _ready() -> void:
	for i in range($ScrollContainer/VBoxContainer.get_children().size()):
		var current_child = $ScrollContainer/VBoxContainer.get_child(i)
		if current_child.name == "VolumeSlider":
			current_child.value = Settings.volume
		if current_child is CheckBox:
			if i < 5:
				current_child.button_pressed = Settings.audio_playing[i - 3]
			elif i == 8:
				current_child.button_pressed = Settings.stop_movement
			elif i == 10:
				current_child.button_pressed = Settings.music_effects

func _physics_process(_delta: float) -> void:
	var mouse_pos := Vector2(DisplayServer.mouse_get_position())
	var offset: Vector2 = mouse_pos - Vector2(60, 20)
	
	if mouse_down:
		self.position = offset
	
	if Input.is_action_pressed("Left Click"):
		if mouse_in_top_bar:
			mouse_down = true
			
	if Input.is_action_just_released("Left Click"):
		mouse_down = false
		
	check_check_boxes()
	update_volume_percentage()


func _on_close_button_pressed() -> void:
	queue_free()


func _on_top_bar_mouse_entered() -> void:
	mouse_in_top_bar = true


func _on_top_bar_mouse_exited() -> void:
	mouse_in_top_bar = false

func check_check_boxes() -> void:
	Settings.is_audio_playing = false
	for i in range($ScrollContainer/VBoxContainer.get_child_count()):
		var current_child = $ScrollContainer/VBoxContainer.get_child(i)
		if current_child.name == "VolumeSlider":
			Settings.volume = current_child.value
		if current_child is CheckBox:
			if i < 7:
				Settings.audio_playing[i - 3] = current_child.button_pressed
				if current_child.button_pressed == true:
					Settings.is_audio_playing = true
			elif i == 8:
				Settings.stop_movement = current_child.button_pressed
				Settings.stop_movement_setting_changed = true
			elif i == 10:
				Settings.music_effects = current_child.button_pressed

func update_volume_percentage() -> void:
	$ScrollContainer/VBoxContainer/VolumeLabel.text = "Volume: " + str(int($ScrollContainer/VBoxContainer/VolumeSlider.value * 100 * 2)) + "%"
