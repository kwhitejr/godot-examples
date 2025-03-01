extends Node2D


const MAX_HUNGER := 100


func _on_hunger_timer_timeout():
	var hunger : int = GoapWorldState.get_state(GoapConstants.STATE_HUNGER, 0)
	if hunger < MAX_HUNGER:
		hunger += 2
	
	GoapEvents.emit_signal("goap_set_hunger", hunger)
