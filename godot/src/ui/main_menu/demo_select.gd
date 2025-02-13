extends VBoxContainer


@onready var resume_button = $Resume

# This script primarily exists to forward button press signals
func _ready() -> void:
	Events.world_is_game_running.connect(_on_is_game_running)

func _on_top_down_2d_controller_button_pressed() -> void:
	Events.emit_signal("main_menu_change_demo", Constants.DEMO.TOP_DOWN_CONTROLLER)

func _on_goap_button_pressed() -> void:
	Events.emit_signal("main_menu_change_demo", Constants.DEMO.GOAL_ORIENTED_ACTION_PLANNING)

func _on_resume_pressed() -> void:
	Events.emit_signal("main_menu_resume")

func _on_is_game_running(is_game_running: bool) -> void:
	resume_button.disabled = !is_game_running
