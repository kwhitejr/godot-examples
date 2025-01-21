class_name Player
extends CharacterBody2D

@export var speed : float = 200.0

signal player_idle(normalized : Vector2)
signal player_walk(normalized : Vector2)

var normalized_direction := Vector2()
var click_position := position
var target_position := Vector2()

var MIN_DISTANCE_PIXELS: float = 3.0

#func _ready() -> void:
	

func _physics_process(delta: float) -> void:
	handle_directional_movement()
	handle_click_movement()

func handle_directional_movement() -> void:
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if direction:
		velocity = direction * speed
		normalized_direction = direction.normalized().snapped(Vector2.ONE)
		player_walk.emit(normalized_direction)
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.y = move_toward(velocity.y, 0, speed)
		player_idle.emit(normalized_direction)

	move_and_slide()
	
func handle_click_movement() -> void:
	if Input.is_action_just_pressed("move_to_click"):
		click_position = get_global_mouse_position()
	
	if position.distance_to(click_position) > MIN_DISTANCE_PIXELS:
		target_position = (click_position - position).normalized()
		velocity = target_position * speed
		player_walk.emit(target_position.snapped(Vector2.ONE))
	else:
		player_idle.emit(target_position)
		
	
	move_and_slide()
	

func collect_egg(egg : Egg) -> void:
	Events.emit_signal("collect_egg")
