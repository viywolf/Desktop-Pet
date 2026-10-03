extends Node2D

const BASE_SPEED := 300.0

@onready var character: Node2D = $MainWindow/Character
@onready var area: Area2D = $MainWindow/Character/Area2D
@onready var popup: Node2D = $MainWindow/WindowPopup
@onready var sprite: AnimatedSprite2D = $MainWindow/Character/Sprite
@onready var main_window: Window = get_window()

@onready var options_scene: PackedScene = preload("res://options_window.tscn")

var speed: float = 300.0
var direction := Vector2.RIGHT
var screen_size := Vector2()
var window_size := Vector2(500, 500)
var character_size := Vector2(200, 200)

var idle_timer: float = 0.0
var is_idling := false

var is_dragging := false
var drag_offset := Vector2()

var is_mouse_in_area := false
var has_right_clicked := false

var saved_local_mouse_pos := Vector2.ZERO

var left_click_held := false

var mouse_in_menu := false

func _ready() -> void:
	Engine.max_fps = 24
	screen_size = Vector2(DisplayServer.screen_get_size())
	$MainWindow.position.y = screen_size.y - character_size.y - 10


func _physics_process(delta: float) -> void:
	var mouse_pos := Vector2(DisplayServer.mouse_get_position())
	var win_pos := Vector2(DisplayServer.window_get_position())
	var offset: Vector2 = mouse_pos - win_pos
	
	var main_window_pos: Vector2 = $MainWindow.position
	var main_window_size: Vector2 = $MainWindow.size
	
	var local_mouse_pos: Vector2 = get_local_mouse_position()
	
	if (mouse_pos.x > main_window_pos.x and mouse_pos.x < main_window_pos.x + main_window_size.x
	and mouse_pos.y > main_window_pos.y and mouse_pos.y < main_window_pos.y + main_window_size.y):
		is_mouse_in_area = true
	else:
		is_mouse_in_area = false
	
	if Input.is_action_just_pressed("ui_up"):
		add_new_window()
	
	# F8 Key
	if Input.is_action_just_pressed("Terminate Program"):
		print("I leave now, bye")
		get_tree().quit()
	
	if is_mouse_in_area:
		if Input.is_action_just_pressed("Left Click"):
			if not mouse_in_menu:
				is_dragging = true
				has_right_clicked = false
				print("Left clicked!")
		elif Input.is_action_just_released("Left Click"):
			is_dragging = false
		elif Input.is_action_just_pressed("Right Click"):
			is_dragging = false
			has_right_clicked = true
			print("Right clicked!")
	
	if is_dragging:
		if saved_local_mouse_pos == Vector2.ZERO:
			saved_local_mouse_pos = local_mouse_pos
		var new_win_pos: Vector2 = mouse_pos - saved_local_mouse_pos
		DisplayServer.window_set_position(Vector2i(new_win_pos))
		$MainWindow.position = Vector2i(new_win_pos)
		return
	else:
		saved_local_mouse_pos = Vector2.ZERO
		
	if has_right_clicked:
		speed = 0
		if popup.visible == false:
			popup.position = mouse_pos
			if get_global_mouse_position().x < 100:
				popup.position = offset + Vector2(50, 0)
				print("Show on right")
			else:
				popup.position = offset - Vector2(50, 0)
				print("Show on left")
			popup.show()
	else:
		popup.hide()
		
	if is_mouse_in_area:
		speed -= 600 * delta
		speed = max(0, speed)
	else:
		if speed < 300.0:
			speed += 300 * delta
			speed = min(speed, 300)
	
	if is_idling:
		sprite.play("await")
		idle_timer -= delta
		if idle_timer <= 0:
			is_idling = false
			speed = BASE_SPEED
			# Play animation
		return
	
	var window_position := Vector2(DisplayServer.window_get_position())
	window_position = $MainWindow.position
	window_position += direction * speed * delta
	window_position.x = clamp(window_position.x, 0, screen_size.x - character_size.x)
	window_position.y = clamp(window_position.y, 0, screen_size.y - character_size.y)
	DisplayServer.window_set_position(Vector2i(window_position))
	$MainWindow.position = Vector2i(window_position)
	
	if is_zero_approx(speed):
		sprite.play("await")
	elif speed < 200:
		if direction == Vector2.RIGHT:
			sprite.play("stop_right")
		elif direction == Vector2.LEFT:
			sprite.play("stop_left")
	else:
		if direction == Vector2.RIGHT:
			sprite.play("run_right")
		elif direction == Vector2.LEFT:
			sprite.play("run_left")
	
	if window_position.x <= 0 or window_position.x >= screen_size.x - character_size.x:
		direction.x *= -1
		try_to_idle()
	if window_position.y <= 0 or window_position.y >= screen_size.y - character_size.y:
		direction.y *= -1
		try_to_idle()

func try_to_idle() -> void:
	if randf() < 0.3:
		is_idling = true
		idle_timer = randf_range(1.0, 3.0)

var count = 0
func add_new_window() -> void:
	var new_window: Window = Window.new()
	var new_sprite2d: Sprite2D = Sprite2D.new()
	new_sprite2d.texture = load("res://icon.svg")
	new_window.add_child(new_sprite2d)
	new_window.unresizable = true
	new_window.borderless = true
	new_window.always_on_top = true
	new_window.transparent = true
	new_window.gui_embed_subwindows = true
	new_window.transparent_bg = true
	new_window.unfocusable = true
	add_child(new_window)
	count += 1
	print(count)


func _on_menu_mouse_entered() -> void:
	mouse_in_menu = true


func _on_menu_mouse_exited() -> void:
	mouse_in_menu = false


func _on_option_button_pressed() -> void:
	var options_window = options_scene.instantiate()
	add_child(options_window)
