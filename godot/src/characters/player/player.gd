class_name Player
extends CharacterBody2D

@export var speed : float = 200.0

signal player_idle(primary_direction : Vector2)
signal player_walk(primary_direction : Vector2)

var primary_direction : Vector2

func _physics_process(delta: float) -> void:

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if direction:
		velocity = direction * speed
		primary_direction = direction.normalized().snapped(Vector2.ONE)
		player_walk.emit(primary_direction)
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.y = move_toward(velocity.y, 0, speed)
		player_idle.emit(primary_direction)

	move_and_slide()

func collect_egg(egg : Egg) -> void:
	Events.emit_signal("collect_egg")
