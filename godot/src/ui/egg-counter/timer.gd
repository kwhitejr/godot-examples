extends Label

var time_elapsed := 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time_elapsed += delta
	text = format_seconds(time_elapsed)

func format_seconds(duration: float) -> String:
	var minutes := int(duration / 60)
	var seconds := fmod(duration, 60)
	var milliseconds := fmod(duration, 1) * 100
	return "%02d:%02d:%02d" % [minutes, seconds, milliseconds]
