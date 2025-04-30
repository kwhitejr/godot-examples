extends AbstractAction

class_name FindCoverAction


func get_clazz() -> String:
	return "FindCoverAction"
	
	
func get_cost(_blackboard) -> int:
	return 1


func get_preconditions() -> Dictionary:
	return {}


func get_effects() -> Dictionary:
	return {
		GoapConstants.CONDITIONS.IS_PROTECTED: true
	}


func perform(actor: Hero, delta: float) -> bool:
	var closest_cover = GoapWorldState.get_closest_element(GoapConstants.GROUP_COVER, actor)

	if closest_cover == null:
		return false

	if closest_cover.position.distance_to(actor.position) < 1:
		actor.make_idle(actor.position.direction_to(closest_cover.position))
		return true

	actor.set_navigation_goal(closest_cover)

	return false
