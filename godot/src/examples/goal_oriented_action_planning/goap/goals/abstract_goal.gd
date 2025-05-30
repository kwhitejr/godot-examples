#
# Abstract Goal 
# Use as a contract for implemented Goals
#
class_name AbstractGoal extends Node

func get_clazz() -> String:
	print(get_class())
	return "AbstractGoal"

#func _init():
	#assert(false, "AbstractGoal is an abstract class and should not be instantiated directly.")
	
#
# This indicates if the goal should be considered or not.
# Sometimes instead of changing the priority, it is easier to
# not even consider the goal. i.e. Ignore combat related goals
# when there are not enemies nearby.
#
func is_valid() -> bool:
	return true

#
# Returns goals priority. This priority can be dynamic. Check
# `./goals/keep_fed_goal.gd` for an example of dynamic priority.
#
func priority() -> int:
	return 1

#
# Plan's desired state. This is usually referred as desired world
# state, but it doesn't need to match the raw world state.
#
# For example, in your world state you may store "hunger" as a number, but inside your
# goap you can deal with it as "is_hungry".
func get_desired_state() -> Dictionary:
	return {}
