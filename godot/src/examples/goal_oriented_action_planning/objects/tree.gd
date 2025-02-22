extends StaticBody2D


var _health = 3


func chop() -> bool:
	if not $ChopCooldownTimer.is_stopped():
		return false

	_health -= 1
	if _health == 0:
		queue_free()
		return true
	$ChopCooldownTimer.start()
	return false
