extends Node2D

const BASE_SPEED := 300.0

@onready var character: Node2D = $Character
@onready var area: Area2D = $Character/Area2D
@onready var popup: Node2D = $WindowPopup

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

func _ready() -> void:
	Engine.max_fps = 24
	screen_size = Vector2(DisplayServer.screen_get_size())


func _physics_process(delta: float) -> void:
	var mouse_pos := Vector2(DisplayServer.mouse_get_position())
	var win_pos := Vector2(DisplayServer.window_get_position())
	var offset: Vector2 = mouse_pos - win_pos
	
	if is_mouse_in_area:
		if Input.is_action_just_pressed("Left Click"):
			is_dragging = true
			has_right_clicked = false
		if Input.is_action_just_released("Left Click"):
			is_dragging = false
		if Input.is_action_just_pressed("Right Click"):
			is_dragging = false
			has_right_clicked = true
	
	if is_dragging:
		var new_win_pos: Vector2 = mouse_pos - offset
		DisplayServer.window_set_position(Vector2i(new_win_pos))
		return
		
	if has_right_clicked:
		speed = 0
		if popup.visible == false:
			popup.position = offset
			popup.show()
	else:
		popup.hide()
		
	if is_mouse_in_area:
		speed -= 300 * delta
		speed = max(0, speed)
	else:
		if speed < 300.0:
			speed += 300 * delta
			speed = min(speed, 300)
	
	if is_idling:
		idle_timer -= delta
		if idle_timer <= 0:
			is_idling = false
			speed = BASE_SPEED
			# Play animation
		return
	
	var window_position := Vector2(DisplayServer.window_get_position())
	window_position += direction * speed * delta
	window_position.x = clamp(window_position.x, 0, screen_size.x - character_size.x)
	window_position.y = clamp(window_position.y, 0, screen_size.y - character_size.y)
	DisplayServer.window_set_position(Vector2i(window_position))
	
	if window_position.x <= 0 or window_position.x >= screen_size.x - character_size.x:
		direction.x *= -1
		try_to_idle()
	if window_position.y <= 0 or window_position.y >= screen_size.y - character_size.y:
		direction.y *= -1
		try_to_idle()


func _on_area_2d_mouse_entered() -> void:
	is_mouse_in_area = true


func _on_area_2d_mouse_exited() -> void:
	is_mouse_in_area = false


func try_to_idle() -> void:
	if randf() < 0.3:
		is_idling = true
		idle_timer = randf_range(1.0, 3.0)
