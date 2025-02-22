extends Control

@onready var PauseButton := $VBoxContainer/MarginContainer/HBoxContainer/PauseButton
@onready var ToggleConsoleButton := $VBoxContainer/MarginContainer/HBoxContainer/ToggleConsoleButton
@onready var HungerProgressBar := $VBoxContainer/MarginContainer/HBoxContainer/HungerProgressBar


func _ready() -> void:
	GoapEvents.goap_set_hunger.connect(_on_goap_set_hunger)

func _on_goap_set_hunger(hunger_value: int) -> void:
	HungerProgressBar.value = hunger_value

func _on_reload_button_pressed() -> void:
	GoapEvents.emit_signal("goap_reload")


func _on_pause_button_pressed() -> void:
	print("pause button")
	var scene = $"../..".get_tree()
	GoapEvents.emit_signal("goap_toggle_pause")
	#scene.paused = not scene.paused
	PauseButton.text = ("Resume" if scene.paused else "Pause")


func _on_toggle_console_button_pressed() -> void:
	var console = self.get_tree().get_nodes_in_group("console")[0]
	console.visible = not console.visible
	ToggleConsoleButton.text = ("Hide Console" if console.visible else "Show Console")
