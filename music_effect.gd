extends Window

var time: float = 0

func _ready() -> void:
	Global.music_notes += 1
	$Sprite2D.scale *= randf_range(1, 2)
	$Sprite2D.modulate = Color(randf_range(0.3, 0.7), randf_range(0.3, 0.7), randf_range(0.3, 0.7))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time += delta
	if time - (floor(time)) < 0.1:
		self.position.y -= 20
	if position.y < -100:
		Global.music_notes -= 1
		queue_free()
