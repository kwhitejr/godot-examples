extends AnimatedSprite2D
class_name TrollAnimations


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.play("idle")

# Probably a bug here. If player is not moving, then x = 0
func _should_flip_animation(direction: Vector2) -> bool:
	return direction.x < 0


func _on_troll_troll_die(direction: Vector2) -> void:
	self.flip_h = _should_flip_animation(direction)
	self.play("die")


func _on_troll_troll_idle(direction: Vector2) -> void:
	self.flip_h = _should_flip_animation(direction)
	self.play("idle")


func _on_troll_troll_run(direction: Vector2) -> void:
	self.flip_h = _should_flip_animation(direction)
	self.play("run")


func _on_troll_troll_walk(direction: Vector2) -> void:
	self.flip_h = _should_flip_animation(direction)
	self.play("walk")


func _on_troll_troll_attack(direction: Vector2) -> void:
	self.flip_h = _should_flip_animation(direction)
	self.play("attack")
