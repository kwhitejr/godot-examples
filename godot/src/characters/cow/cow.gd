extends CharacterBody2D

enum COW_STATE { IDLE, WALK }

@export var speed : float = 30.0
@export var idle_time : float = 4.0
@export var walk_time : float = 2.0

@onready var timer := $Timer

signal idle(direction : Vector2)
signal walk(direction : Vector2)

var direction : Vector2 = Vector2.ZERO
var cow_state : COW_STATE = COW_STATE.IDLE

func _ready():
	handle_cow()
	
func _physics_process(delta: float) -> void:
	velocity = direction * speed
	
	move_and_slide()

func get_random_direction() -> Vector2:
	return Vector2(randf_range(-1,1), randf_range(-1,1))

func handle_cow() -> void:
	
	if (cow_state == COW_STATE.IDLE):
		direction = get_random_direction()
		cow_state = COW_STATE.WALK
		walk.emit(direction)
		timer.start(randf_range(walk_time-1, walk_time+1))
	elif (cow_state == COW_STATE.WALK):
		var previous_direction = direction
		direction = Vector2.ZERO
		cow_state = COW_STATE.IDLE
		idle.emit(previous_direction)
		timer.start(randf_range(idle_time-1, idle_time+1))

func _on_timer_timeout() -> void:
	handle_cow()
