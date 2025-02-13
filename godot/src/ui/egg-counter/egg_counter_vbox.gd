extends VBoxContainer

@onready var counter_label := $Counter

#@export var player : CharacterBody2D

var counter_value: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Events.egg_collector_collect_egg.connect(_on_player_collect_egg)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Counter.set_text(str(counter_value))

func _on_player_collect_egg(egg_count: int) -> void:
	counter_value = egg_count
