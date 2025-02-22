#
# This NPC uses GOAP as AI. This script handles
# Only NPC related stuff, like moving and animations.

# All AI related code is inside GoapAgent.
#
# This is optional, but I usually like to have my AI code
# separated from the "dumb" modules that handle the basic low
# level stuff, this allows me to use the same Agent in different
# nodes.
#
extends CharacterBody2D
class_name Hero

signal hero_idle(direction : Vector2)
signal hero_walk(direction : Vector2)
signal hero_run(direction : Vector2)
signal hero_attack(direction : Vector2)
signal hero_die(direction : Vector2)

var last_direction : Vector2 = Vector2.RIGHT

func _ready() -> void:
  # Here is where I define which goals are available for this
  # npc. In this implementation, goals priority are calculated
  # dynamically. Depending on your use case you might want to
  # have a way to define different goal priorities depending on
  # npc.
	var agent = GoapAgent.new()
	agent.init(self, [
		KeepFirepitBurningGoal.new(),
		KeepFedGoal.new(),
		CalmDownGoal.new(),
		RelaxGoal.new()
	])
	
	add_child(agent)

func _process(_delta) -> void:
	$HeroUI/VBoxContainer/Fear.visible = GoapWorldState.get_state(GoapConstants.STATE_IS_FRIGHTENED, false)
	$HeroUI/VBoxContainer/Hunger.visible = GoapWorldState.get_state(GoapConstants.STATE_HUNGER, 0) >= 50

	
func make_idle(direction) -> void:
	hero_idle.emit(direction)


func move_to(direction, delta) -> void:
	last_direction = direction
	hero_run.emit(direction)
	# warning-ignore:return_value_discarded
	move_and_collide(direction * delta * 100)


func chop_tree(tree) -> bool:
	hero_attack.emit(last_direction)
	return tree.chop()


func calm_down() -> bool:
	if GoapWorldState.get_state(GoapConstants.STATE_IS_FRIGHTENED) == false:
		return true

	if $CalmDownTimer.is_stopped():
		$CalmDownTimer.start()

	return false


func _on_detection_radius_body_entered(body) -> void:
	if body.is_in_group(GoapConstants.GROUP_TROLL):
		GoapWorldState.set_state(GoapConstants.STATE_IS_FRIGHTENED, true)


func _on_calm_down_timer_timeout() -> void:
	GoapWorldState.set_state(GoapConstants.STATE_IS_FRIGHTENED, false)
