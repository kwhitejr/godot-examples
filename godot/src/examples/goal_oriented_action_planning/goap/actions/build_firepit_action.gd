extends AbstractAction

class_name BuildFirepitAction

const Firepit = preload("res://src/examples/goal_oriented_action_planning/objects/firepit.tscn")


func get_clazz() -> String:
	return "BuildFirepitAction"
	
func get_cost(_blackboard) -> int:
	return 1


func get_preconditions() -> Dictionary:
	return {
		GoapConstants.CONDITIONS.HAS_WOOD: true
	}


func get_effects() -> Dictionary:
	return {
		GoapConstants.CONDITIONS.HAS_FIREPIT: true
	}


func perform(actor: Hero, delta: float) -> bool:
	var _closest_spot = GoapWorldState.get_closest_element(GoapConstants.GROUP_FIREPIT_SPOT, actor)

	if _closest_spot == null:
		return false

	if _closest_spot.position.distance_to(actor.position) < 20:
			var firepit = Firepit.instantiate()
			actor.get_parent().add_child(firepit)
			firepit.position = _closest_spot.position
			firepit.z_index = _closest_spot.z_index
			actor.state.set_has_wood(false)
			actor.make_idle(actor.position.direction_to(firepit.position))
			return true

	actor.set_navigation_goal(_closest_spot)
	#actor.move_to(actor.position.direction_to(_closest_spot.position), delta)

	return false
