extends AbstractAction

class_name CalmDownAction


func get_clazz() -> String:
	return "CalmDownAction"
	
func get_cost(_blackboard) -> int:
	return 1


func get_preconditions() -> Dictionary:
	return {
		GoapConstants.CONDITIONS.IS_PROTECTED: true
	}


func get_effects() -> Dictionary:
	return {
		GoapConstants.CONDITIONS.IS_FRIGHTENED: false
	}


func perform(actor, _delta) -> bool:
	return actor.calm_down()
