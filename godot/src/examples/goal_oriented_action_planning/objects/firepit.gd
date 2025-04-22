extends Node2D


func _process(_delta):
	var formatted_time: String = "%.2f" % $Timer.time_left
	$VBoxContainer/TimeRemainingLabel.text = formatted_time

func _on_timer_timeout():
	queue_free()
