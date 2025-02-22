extends AbstractAction

class_name FindFoodAction


func get_clazz() -> String:
	return "FindFoodAction"


func get_cost(_blackboard) -> int:
	return 1


func get_preconditions() -> Dictionary:
	return {}


func get_effects() -> Dictionary:
	return {
		GoapConstants.CONDITIONS.IS_HUNGRY: false
	}


func perform(actor, delta) -> bool:
	var closest_food = GoapWorldState.get_closest_element(GoapConstants.GROUP_FOOD, actor)

	if closest_food == null:
		return false

	if closest_food.position.distance_to(actor.position) < 20:
		var current_hunger = GoapWorldState.get_state(GoapConstants.STATE_HUNGER)
		GoapWorldState.set_state(GoapConstants.STATE_HUNGER, current_hunger - closest_food.nutrition)
		closest_food.queue_free()
		return true

	actor.move_to(actor.position.direction_to(closest_food.position), delta)
	return false
