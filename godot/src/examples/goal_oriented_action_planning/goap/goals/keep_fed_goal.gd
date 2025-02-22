extends AbstractGoal

class_name KeepFedGoal


func get_clazz() -> String:
	return "KeepFedGoal"
	
# This is not a valid goal when hunger is less than 50.
func is_valid() -> bool:
	return GoapWorldState.get_state(GoapConstants.STATE_HUNGER, 0)  > 50 \
		and GoapWorldState.get_elements(GoapConstants.GROUP_FOOD).size() > 0


func priority() -> int:
	return 1 if GoapWorldState.get_state(GoapConstants.STATE_HUNGER, 0) < 75 else 2


func get_desired_state() -> Dictionary:
	return {
		GoapConstants.CONDITIONS.IS_HUNGRY: false
	}
