extends AbstractGoal

class_name CalmDownGoal


func get_clazz() -> String:
	return "CalmDownGoal"
	
func is_valid() -> bool:
	return GoapWorldState.get_state(GoapConstants.STATE_IS_FRIGHTENED, false)


func priority() -> int:
	return 10


func get_desired_state() -> Dictionary:
	return {
		GoapConstants.CONDITIONS.IS_FRIGHTENED: false
	}
