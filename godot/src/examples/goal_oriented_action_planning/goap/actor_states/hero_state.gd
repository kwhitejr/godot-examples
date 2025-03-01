## Concrete state class for a hero in a GOAP system.
class_name HeroState extends AbstractActorState

## Default state template for reset purposes.
var hero_state := {
	GoapConstants.HERO_STATE_HUNGER_COUNT: 0,
	GoapConstants.HERO_STATE_HAS_WOOD: false,
	GoapConstants.HERO_STATE_IS_FRIGHTENED: false
}

func _init() -> void:
	_actor_state = hero_state.duplicate()  # Start with a copy

## Gets the hero's hunger count.
func get_hunger_count() -> int:
	return _actor_state.get(GoapConstants.HERO_STATE_HUNGER_COUNT, 0)

## Sets the hero's hunger count.
func set_hunger_count(value: int) -> void:
	_actor_state[GoapConstants.HERO_STATE_HUNGER_COUNT] = value

## Checks if the hero has wood.
func has_wood() -> bool:
	return _actor_state.get(GoapConstants.HERO_STATE_HAS_WOOD, false)

## Sets whether the hero has wood.
func set_has_wood(value: bool) -> void:
	_actor_state[GoapConstants.HERO_STATE_HAS_WOOD] = value

## Checks if a precondition is met for GOAP planning.
func meets_precondition(key: String, expected_value: Variant) -> bool:
	return _actor_state.get(key) == expected_value

## Resets the state to its initial values.
func reset() -> void:
	_actor_state = hero_state.duplicate()
