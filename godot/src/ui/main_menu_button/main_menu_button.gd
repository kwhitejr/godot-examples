extends TextureButton


func _input(event: InputEvent) -> void:
	if Input.is_action_pressed("open_main_menu"):
		open_main_menu()

func _on_pressed() -> void:
	open_main_menu()

func open_main_menu() -> void:
	print("pressed menu button")
	Events.emit_signal("main_menu_open")
