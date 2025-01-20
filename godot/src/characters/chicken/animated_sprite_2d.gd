extends AnimatedSprite2D


enum FACING_DIRECTION { LEFT, RIGHT }

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.play("idle")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_chicken_idle(direction: Vector2) -> void:
	self.flip_h = (get_facing_direction(direction) == FACING_DIRECTION.LEFT)
	self.play("idle")

func _on_chicken_walk(direction: Vector2) -> void:
	self.flip_h = (get_facing_direction(direction) == FACING_DIRECTION.LEFT)
	self.play("walk")

func get_facing_direction(direction: Vector2) -> FACING_DIRECTION:
	if (direction.x < 0): 
		return FACING_DIRECTION.LEFT
	else:
		return FACING_DIRECTION.RIGHT
