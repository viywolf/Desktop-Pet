extends Window

var mouse_in_top_bar := false
var mouse_down := false

var saved_mouse_pos: Vector2


func _physics_process(delta: float) -> void:
	var mouse_pos := Vector2(DisplayServer.mouse_get_position())
	var local_mouse_pos = mouse_pos - Vector2(self.size)
	var offset: Vector2 = mouse_pos + saved_mouse_pos #Vector2(60, 20)
	
	if mouse_down:
		self.position = offset
	
	if Input.is_action_pressed("Left Click"):
		if mouse_in_top_bar:
			mouse_down = true
		saved_mouse_pos = local_mouse_pos
			
	if Input.is_action_just_released("Left Click"):
		mouse_down = false


func _on_close_button_pressed() -> void:
	queue_free()


func _on_top_bar_mouse_entered() -> void:
	mouse_in_top_bar = true


func _on_top_bar_mouse_exited() -> void:
	mouse_in_top_bar = false

func check_check_boxes() -> void:
	for i in range($ScrollContainer/VBoxContainer.get_children().size()):
		var current_child = $ScrollContainer/VBoxContainer.get_child(i)
		if current_child is CheckBox:
			if i < 5:
				Settings.audio_playing[i - 1] = current_child.button_pressed
			elif i == 8:
				Settings.stop_movement = current_child.button_pressed
				Settings.stop_movement_setting_changed = true
