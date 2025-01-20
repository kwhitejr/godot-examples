extends AnimatedSprite2D

@onready var portrait_timer := $"../../../../../../../PortraitTimer"

@export var portait_timer_duration_sec : float = 4.0

enum Idle_Animations { blink = 1, ear_wiggle = 2, smile = 3 }

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.play("idle")
	portrait_timer.start(portait_timer_duration_sec)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_portrait_timer_timeout() -> void:
	# play random idle animation
	var idle_animations = Idle_Animations.keys()
	var random_index: int = randi_range(0, idle_animations.size() - 1)
	var random_idle_animation: String = idle_animations[random_index]
	self.play(random_idle_animation)

func _on_animation_finished() -> void:
	self.play("idle")
	pass # Replace with function body.
