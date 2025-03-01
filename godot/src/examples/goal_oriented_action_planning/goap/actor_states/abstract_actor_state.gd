## Abstract base class for actor states in a GOAP system.
## Subclasses must manage actor-specific state and should not instantiate this directly.
class_name AbstractActorState extends Node

## Internal storage for actor state key-value pairs.
var _actor_state : Dictionary = {}
 
func _init():
	assert(false, "AbstractActorState is an abstract class and should not be instantiated directly.")

func get_clazz() -> String:
	print(get_class())
	return "AbstractActorState"

## Returns a copy of the current actor state.
## Enforces immutability.
func get_state() -> Dictionary:
	return _actor_state.duplicate()

func get_value(key: String) -> Variant:
	return _actor_state.get(key)

## Sets a state value for a given key.
## @param key: The state identifier (e.g., "health", "is_alive").
## @param value: The value to set for the key.
func set_state(key: String, value: Variant) -> void:
	_actor_state[key] = value

## Checks if a state matches an expected value.
## @param key: The state identifier to check.
## @param expected_value: The value to compare against.
## @return: True if the state matches, false otherwise.
func has_state(key: String, expected_value: Variant) -> bool:
	return _actor_state.get(key) == expected_value

## Clear state to empty
func clear_state() -> void:
	_actor_state.clear()
