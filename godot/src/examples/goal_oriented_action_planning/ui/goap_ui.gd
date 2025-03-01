extends Control

@onready var PauseButton := $VBoxContainer/MarginContainer/HBoxContainer/PauseButton
@onready var ToggleConsoleButton := $VBoxContainer/MarginContainer/HBoxContainer/ToggleConsoleButton
@onready var HungerProgressBar := $VBoxContainer/MarginContainer/HBoxContainer/HungerProgressBar
@onready var GoapScene := $"../.."


func _ready() -> void:
	GoapEvents.goap_set_hunger.connect(_on_goap_set_hunger)
	process_mode = PROCESS_MODE_ALWAYS
	mouse_filter = MOUSE_FILTER_STOP
	set_process_input(true)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if PauseButton.get_global_rect().has_point(event.position):
			print("Mouse clicked on PauseButton!")

func _on_goap_set_hunger(hunger_value: int) -> void:
	HungerProgressBar.value = hunger_value

func _on_reload_button_pressed() -> void:
	GoapEvents.emit_signal("goap_reload")


func _on_pause_button_pressed() -> void:	
	GoapScene.process_mode = PROCESS_MODE_DISABLED if GoapScene.process_mode == PROCESS_MODE_INHERIT else PROCESS_MODE_INHERIT
	PauseButton.text = ("Resume" if GoapScene.process_mode == PROCESS_MODE_DISABLED else "Pause")
	print("LevelScene pause toggled to: ", GoapScene.process_mode == PROCESS_MODE_DISABLED)


func _on_toggle_console_button_pressed() -> void:
	var console = self.get_tree().get_nodes_in_group("console")[0]
	console.visible = not console.visible
	ToggleConsoleButton.text = ("Hide Console" if console.visible else "Show Console")
