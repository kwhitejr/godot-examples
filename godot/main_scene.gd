class_name MainScene
extends Node2D


@onready var top_down_game_scene := preload("res://src/examples/top_down_controller/top_down_controller.tscn")
@onready var goap_game_scene := preload("res://src/examples/goal_oriented_action_planning/goal_oriented_action_planning.tscn")
@onready var game_parent_node := %GameViewport
@onready var main_menu := $SubViewportContainer/GameViewport/MainMenu

@onready var demo_map := {
	Constants.DEMO.TOP_DOWN_CONTROLLER : top_down_game_scene,
	Constants.DEMO.GOAL_ORIENTED_ACTION_PLANNING : goap_game_scene
}

func _ready() -> void:
	Events.main_menu_change_demo.connect(_on_demo_button_pressed)
	#Events.main_menu_open.connect(_on_main_menu_open)
	#Events.main_menu_resume.connect(_on_main_menu_resume)
	
func start_game(selected_demo: Constants.DEMO) -> void:
	# Remove Main Menu from game parent
	main_menu.visible = false
	game_parent_node.remove_child(main_menu)
	main_menu.queue_free()
	main_menu = null
	instantiate_demo(selected_demo)

func instantiate_demo(demo: Constants.DEMO) -> void:
	var demo_instance = demo_map[demo].instantiate()
	Events.emit_signal("world_is_game_running", true)
	
	# Add demo to Game scene
	game_parent_node.add_child(demo_instance)
	
	# Make demo first child.
	game_parent_node.move_child(demo_instance, 0)


func _on_demo_button_pressed(demo : Constants.DEMO) -> void:
	print("MainMenu parent:", main_menu.get_parent())
	start_game(demo)
