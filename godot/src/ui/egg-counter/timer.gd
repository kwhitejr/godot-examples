extends Label


var time_elapsed := 0.0
var is_timer_stopped := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Events.egg_collector_end_game.connect(_on_player_end_game)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_timer_stopped == false:
		time_elapsed += delta
		text = format_seconds(time_elapsed)

func format_seconds(duration: float) -> String:
	var minutes := int(duration / 60)
	var seconds := fmod(duration, 60)
	var milliseconds := fmod(duration, 1) * 100
	return "%02d:%02d:%02d" % [minutes, seconds, milliseconds]

func _on_player_end_game():
	is_timer_stopped = true
