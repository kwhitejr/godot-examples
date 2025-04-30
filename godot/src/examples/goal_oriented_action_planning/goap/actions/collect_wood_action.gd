extends AbstractAction

class_name CollectWoodAction


func get_clazz() -> String:
	return "CollectWoodAction"
	
	
func is_valid() -> bool:
	return GoapWorldState.get_elements(GoapConstants.GROUP_WOODSTOCK).size() > 0


func get_cost(blackboard) -> int:
	if blackboard.has("position"):
		var closest_tree = GoapWorldState.get_closest_element(GoapConstants.GROUP_WOODSTOCK, blackboard)
		return int(closest_tree.position.distance_to(blackboard.position) / 5)
	return 5


func get_preconditions() -> Dictionary:
	return {}


func get_effects() -> Dictionary:
	return {
		GoapConstants.CONDITIONS.HAS_WOOD: true,
	}


func perform(actor: Hero, delta: float) -> bool:
	var closest_stock = GoapWorldState.get_closest_element(GoapConstants.GROUP_WOODSTOCK, actor)

	if closest_stock:
		if closest_stock.position.distance_to(actor.position) < 10:
			closest_stock.queue_free()
			actor.state.set_has_wood(true)
			return true
		else:
			actor.set_navigation_goal(closest_stock)

	return false
