extends AbstractGoal

class_name CalmDownGoal


func is_valid() -> bool:
	return GoapWorldState.get_state("is_frightened", false)


func priority() -> int:
	return 10


func get_desired_state() -> Dictionary:
	return {
		"is_frightened": false
	}
