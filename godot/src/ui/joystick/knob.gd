extends Sprite2D

@onready var parent := $".."

@export var max_length := 50
@export var dead_zone := 5

var is_button_down: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	max_length *= parent.scale.x

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_button_down:
		var global_mouse_position := get_global_mouse_position()
		if global_mouse_position.distance_to(parent.global_position) <= max_length:
			global_position = global_mouse_position
		else: 
			var angle = parent.global_position.angle_to_point(global_mouse_position)
			global_position.x = parent.global_position.x + cos(angle) * max_length
			global_position.y = parent.global_position.y + sin(angle) * max_length
		set_parent_vector()
	else:
		global_position = lerp(global_position, parent.global_position, delta*30)
		parent.position_vector = Vector2.ZERO

func set_parent_vector() -> void:
	var x_difference = global_position.x - parent.global_position.x
	if (abs(x_difference) >= dead_zone):
		parent.position_vector.x = x_difference / max_length
		
	var y_difference = global_position.y - parent.global_position.y
	if (abs(y_difference) >= dead_zone):
		parent.position_vector.y = y_difference / max_length

func _on_button_button_down() -> void:
	print("button is down")
	is_button_down = true

func _on_button_button_up() -> void:
	print("button is down")
	is_button_down = false
