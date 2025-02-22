extends AbstractGoal

class_name KeepFirepitBurningGoal


func get_clazz() -> String:
	return "KeepFirepitBurningGoal"

func is_valid() -> bool:
	return GoapWorldState.get_elements(GoapConstants.GROUP_FIREPIT).size() == 0


func priority() -> int:
	return 1


func get_desired_state() -> Dictionary:
	return {
		GoapConstants.CONDITIONS.HAS_FIREPIT: true
	}
