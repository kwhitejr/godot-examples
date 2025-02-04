extends CanvasLayer

@onready var screen_size := DisplayServer.window_get_size()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	are_children_visible(false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	#if screen_size.x < screen_size.y:
		#print("Portrait mode detected")
		#hide_children()
	#else:
		#print("Landscape mode detected")

func are_children_visible(are_visible: bool):
	for child in get_children():
		child.visible = are_visible

func _input(event):
	if event is InputEventScreenTouch:
		if event.pressed:
			are_children_visible(true)
