extends Node2D


@onready var GoapScene := $"."

const MAX_HUNGER := 100

func _ready() -> void:
	GoapEvents.goap_reload.connect(_on_reload_button_pressed)
	GoapEvents.goap_toggle_pause.connect(_on_toggle_pause_button_pressed)

func _on_hunger_timer_timeout():
	var hunger : int = GoapWorldState.get_state(GoapConstants.STATE_HUNGER, 0)
	if hunger < MAX_HUNGER:
		hunger += 2
	
	GoapEvents.emit_signal("goap_set_hunger", hunger)

func _on_reload_button_pressed():
	GoapWorldState.clear_state()
	# warning-ignore:return_value_discarded
	GoapScene.get_tree().reload_current_scene()
	
func _on_toggle_pause_button_pressed():
	GoapScene.get_tree().paused = not GoapScene.get_tree().paused
