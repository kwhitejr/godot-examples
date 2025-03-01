class_name CalmDownGoal extends AbstractGoal


var _actor

func _init(actor) -> void:
	_actor = actor

func get_clazz() -> String:
	return "CalmDownGoal"
	
func is_valid() -> bool:
	return _actor._state.get_value(GoapConstants.HERO_STATE_IS_FRIGHTENED)

func priority() -> int:
	return 10

func get_desired_state() -> Dictionary:
	return {
		GoapConstants.CONDITIONS.IS_FRIGHTENED: false
	}
