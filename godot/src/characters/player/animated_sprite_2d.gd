extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.play("idle_down")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_player_player_idle(primary_direction : Vector2) -> void:
	if (primary_direction == Vector2.UP):
		self.play("idle_up")
	elif (primary_direction == Vector2.DOWN):
		self.play("idle_down")
	elif (primary_direction == Vector2.LEFT):
		self.play("idle_left")
	elif (primary_direction == Vector2.RIGHT):
		self.play("idle_right")
	pass

func _on_player_player_walk(primary_direction : Vector2) -> void:
	if (primary_direction == Vector2.UP):
		self.play("walk_up")
	elif (primary_direction == Vector2.DOWN):
		self.play("walk_down")
	elif (primary_direction == Vector2.LEFT):
		self.play("walk_left")
	elif (primary_direction == Vector2.RIGHT):
		self.play("walk_right")
	pass
