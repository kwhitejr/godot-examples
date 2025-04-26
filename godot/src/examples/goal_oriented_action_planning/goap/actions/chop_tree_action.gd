extends AbstractAction

class_name ChopTreeAction


func get_clazz() -> String:
	return "ChopTreeAction"
	
func is_valid() -> bool:
	return GoapWorldState.get_elements(GoapConstants.GROUP_TREE).size() > 0


func get_cost(blackboard) -> int:
	if blackboard.has("position"):
		var closest_tree = GoapWorldState.get_closest_element(GoapConstants.GROUP_TREE, blackboard)
		return int(closest_tree.position.distance_to(blackboard.position) / 7)
	return 3


func get_preconditions() -> Dictionary:
	return {}


func get_effects() -> Dictionary:
	return {
		GoapConstants.CONDITIONS.HAS_WOOD: true
	}


func perform(actor: Hero, delta: float) -> bool:
	var _closest_tree = GoapWorldState.get_closest_element(GoapConstants.GROUP_TREE, actor)

	if _closest_tree:
		if _closest_tree.position.distance_to(actor.position) < 20:
				if actor.chop_tree(_closest_tree):
					actor.state.set_has_wood(true)
					return true
				return false
		else:
			actor.set_navigation_goal(_closest_tree)
			#actor.move_to(actor.position.direction_to(_closest_tree.position), delta)

	return false
