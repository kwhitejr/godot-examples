extends AbstractAction

class_name FindCoverAction


func get_cost(_blackboard) -> int:
	return 1


func get_preconditions() -> Dictionary:
	return {}


func get_effects() -> Dictionary:
	return {
		GoapConstants.CONDITIONS.IS_PROTECTED: true
	}


func perform(actor, delta) -> bool:
	var closest_cover = GoapWorldState.get_closest_element("cover", actor)

	if closest_cover == null:
		return false

	if closest_cover.position.distance_to(actor.position) < 1:
		return true

	actor.move_to(actor.position.direction_to(closest_cover.position), delta)
	return false
