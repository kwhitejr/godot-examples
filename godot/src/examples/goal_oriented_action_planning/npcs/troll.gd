extends CharacterBody2D


var _target : Vector2

signal troll_idle(direction : Vector2)
signal troll_walk(direction : Vector2)
signal troll_run(direction : Vector2)
signal troll_attack(direction : Vector2)
signal troll_die(direction : Vector2)

func _ready() -> void:
	_pick_random_position()


func _process(delta) -> void:
	if self.position.distance_to(_target) > 1 :
		var direction = self.position.direction_to(_target)

		# warning-ignore:return_value_discarded
		troll_run.emit(direction)
		move_and_collide(direction * delta * 100)
	else:
		troll_idle.emit(_target)
		$RestTimer.start()
		set_process(false)


func _pick_random_position() -> void:
	randomize()
	_target = Vector2(randi() % 445 + 5, randi() % 245 + 5)
	troll_run.emit(_target)


func _on_rest_timer_timeout() -> void:
	_pick_random_position()
	set_process(true)
