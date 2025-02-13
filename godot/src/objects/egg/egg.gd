class_name Egg
extends Area2D

var is_collected: bool = false

func _on_body_entered(body):
	if body.name == "Player" and is_collected == false:
		is_collected = true # hack to prevent double pickup
		
		body.collect_egg(self)
		
		var tween = create_tween()
		tween.tween_property(self, "position", position + Vector2(0, -12), 0.1)
		tween.tween_property(self, "modulate:a", 0.0, 0.1)
		tween.tween_callback(self.queue_free)
