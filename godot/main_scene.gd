class_name MainScene
extends Node2D



@onready var top_down_game_scene := preload("res://src/examples/top_down_controller/top_down_controller.tscn")
@onready var goap_game_scene := preload("res://src/examples/goal_oriented_action_planning/goal_oriented_action_planning.tscn")
@onready var top_down_ui_scene := preload("res://src/ui/egg-counter/egg-counter.tscn")
@onready var goap_ui_scene := preload("res://src/ui/goap/goap_ui.tscn")
@onready var game_parent_node := %GameViewport
@onready var ui_parent_node := %UI
@onready var main_menu := %MainMenu

@onready var demo_map := {
	Constants.DEMO.TOP_DOWN_CONTROLLER : top_down_game_scene,
	Constants.DEMO.GOAL_ORIENTED_ACTION_PLANNING : goap_game_scene
}

@onready var ui_map := {
	Constants.DEMO.TOP_DOWN_CONTROLLER : top_down_ui_scene,
	Constants.DEMO.GOAL_ORIENTED_ACTION_PLANNING : goap_ui_scene
}

var demo_instance
var ui_instance

func _ready() -> void:
	Events.main_menu_change_demo.connect(_on_demo_button_pressed)
	Events.main_menu_open.connect(_on_main_menu_open)
	Events.main_menu_resume.connect(_on_main_menu_resume)
	
func start_game(selected_demo: Constants.DEMO) -> void:
	# If demo already exists, remove it
	if demo_instance != null:
		print("change demo")
		game_parent_node.remove_child(demo_instance)
		ui_parent_node.remove_child(ui_instance)
		demo_instance = null
		ui_instance = null
		
	instantiate_demo(selected_demo)
	
	# Hide MainMenu and resume
	set_is_main_menu_open(false)

func instantiate_demo(demo: Constants.DEMO) -> void:
	demo_instance = demo_map[demo].instantiate()
	Events.emit_signal("world_is_game_running", true)
	
	# Add demo to Game scene
	game_parent_node.add_child(demo_instance)
	
	# Make demo first child.
	game_parent_node.move_child(demo_instance, 0)
	
	# Same for UI
	ui_instance = ui_map[demo].instantiate()
	ui_parent_node.add_child(ui_instance)
	ui_parent_node.move_child(ui_instance, 0)
	
func set_is_main_menu_open(is_open: bool) -> void:
	main_menu.visible = is_open
	Engine.time_scale = 0 if is_open else 1

func _on_demo_button_pressed(demo : Constants.DEMO) -> void:
	start_game(demo)
	
func _on_main_menu_open() -> void:
	set_is_main_menu_open(true)

func _on_main_menu_resume() -> void:
	set_is_main_menu_open(false)
