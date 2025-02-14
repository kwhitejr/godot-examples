extends Node
#class_name Events


signal egg_collector_collect_egg(egg_count: int)
signal egg_collector_end_game

signal main_menu_change_demo(demo: Constants.DEMO)
signal main_menu_open
signal main_menu_resume

signal world_is_game_running(is_game_running: bool)
