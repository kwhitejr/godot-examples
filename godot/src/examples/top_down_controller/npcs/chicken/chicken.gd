extends CharacterBody2D

enum CHICKEN_STATE { IDLE, WALK }

@export var speed : float = 50.0
@export var idle_time : float = 4.0
@export var walk_time : float = 2.0
@export var egg_time : float = 3.0

@onready var movement_timer := $MovementTimer
@onready var egg_timer := $EggTimer

signal idle(direction : Vector2)
signal walk(direction : Vector2)

var direction : Vector2 = Vector2.ZERO
var chicken_state : CHICKEN_STATE = CHICKEN_STATE.IDLE

var egg_scene := preload("res://src/examples/top_down_controller/objects/egg.tscn")

func _ready():
	handle_chicken()
	egg_timer.start(egg_time)
	
func _physics_process(delta: float) -> void:
	velocity = direction * speed
	
	move_and_slide()

func get_random_direction() -> Vector2:
	return Vector2(randf_range(-1,1), randf_range(-1,1))

func handle_chicken() -> void:
	if (chicken_state == CHICKEN_STATE.IDLE):
		direction = get_random_direction()
		chicken_state = CHICKEN_STATE.WALK
		walk.emit(direction)
		movement_timer.start(randf_range(walk_time-1, walk_time+1))
	elif (chicken_state == CHICKEN_STATE.WALK):
		var previous_direction = direction
		direction = Vector2.ZERO
		chicken_state = CHICKEN_STATE.IDLE
		idle.emit(previous_direction)
		movement_timer.start(randf_range(idle_time-1, idle_time+1))
		
func handle_lay_egg() -> void:
	var egg_instance = egg_scene.instantiate()
	# Set egg position to chicken position...
	egg_instance.position = Vector2(position.x, position.y)
	# ...but spawn it into the parent scene (the level).
	get_parent().add_child(egg_instance)
	egg_timer.start(randf_range(egg_time-1, egg_time+1))

func _on_egg_timer_timeout() -> void:
	handle_lay_egg()

func _on_movement_timer_timeout() -> void:
	handle_chicken()
