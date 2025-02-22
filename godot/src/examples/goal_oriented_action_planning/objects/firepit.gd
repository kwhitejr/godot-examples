extends Node2D


func _process(_delta):
	$Label.text = str(ceil($Timer.time_left))

func _on_timer_timeout():
	queue_free()
