class_name KeepFedGoal extends AbstractGoal


var _actor

func _init(actor) -> void:
	_actor = actor
	
func get_clazz() -> String:
	return "KeepFedGoal"

	
# This is not a valid goal when hunger is less than 50.
func is_valid() -> bool:
	var hunger_count = _actor._state.get_hunger_count()
	return hunger_count > 50 \
		and GoapWorldState.get_elements(GoapConstants.GROUP_FOOD).size() > 0


func priority() -> int:
	var hunger_count = _actor._state.get_hunger_count()
	return 1 if hunger_count < 75 else 2


func get_desired_state() -> Dictionary:
	return {
		GoapConstants.CONDITIONS.IS_HUNGRY: false
	}
