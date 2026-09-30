extends Node2D

const BASE_SPEED := 300.0

var speed: float = 300.0
var direction := Vector2.RIGHT
var screen_size := Vector2()
var window_size := Vector2(200, 200)

var idle_timer: float = 0.0
var is_idling := false

@onready var area: Area2D = $Character/Area2D
var is_dragging := false
var drag_offset := Vector2()

func _ready() -> void:
	Engine.max_fps = 24
	screen_size = Vector2(DisplayServer.screen_get_size())
	
	area.input_event.connect(_on_area_input)
	


func _physics_process(delta: float) -> void:
	if is_dragging:
		var mouse_pos := Vector2(DisplayServer.mouse_get_position())
		var new_win_pos: Vector2 = mouse_pos - drag_offset
		DisplayServer.window_set_position(Vector2i(new_win_pos))
		return
	
	if is_idling:
		idle_timer -= delta
		if idle_timer <= 0:
			is_idling = false
			speed = BASE_SPEED
			# Play animation
		return
	
	var window_position := Vector2(DisplayServer.window_get_position())
	window_position += direction * speed * delta
	window_position.x = clamp(window_position.x, 0, screen_size.x - window_size.x)
	window_position.y = clamp(window_position.y, 0, screen_size.y - window_size.y)
	DisplayServer.window_set_position(Vector2i(window_position))
	
	if window_position.x <= 0 or window_position.x >= screen_size.x - window_size.x:
		direction.x *= -1
		try_to_idle()
	if window_position.y <= 0 or window_position.y >= screen_size.y - window_size.y:
		direction.y *= -1
		try_to_idle()


func _on_area_input(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			is_dragging = true
			var mouse_pos := Vector2(DisplayServer.mouse_get_position())
			var win_pos := Vector2(DisplayServer.window_get_position())
			drag_offset = mouse_pos - win_pos
		else:
			is_dragging = false


func try_to_idle() -> void:
	if randf() < 0.3:
		is_idling = true
		idle_timer = randf_range(1.0, 3.0)
		var r = randi() % 3
		if r == 0:
			# Animation play idle
			speed = 0
