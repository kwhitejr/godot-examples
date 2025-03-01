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
class_name Hero extends CharacterBody2D


signal hero_idle(direction : Vector2)
signal hero_walk(direction : Vector2)
signal hero_run(direction : Vector2)
signal hero_attack(direction : Vector2)
signal hero_die(direction : Vector2)

const MAX_HUNGER := 100
var last_direction : Vector2 = Vector2.RIGHT
@onready var state : HeroState = HeroState.new()

func _ready() -> void:
  # Here is where I define which goals are available for this
  # npc. In this implementation, goals priority are calculated
  # dynamically. Depending on your use case you might want to
  # have a way to define different goal priorities depending on
  # npc.
	var agent = GoapAgent.new()
	agent.init(
		self, 
		[
			KeepFirepitBurningGoal.new(),
			KeepFedGoal.new(self),
			CalmDownGoal.new(self),
			RelaxGoal.new()
		],
		state
	)
	add_child(agent)

func _process(_delta) -> void:
	$HeroUI/VBoxContainer/Fear.visible = state.meets_precondition(GoapConstants.HERO_STATE_IS_FRIGHTENED, true)
	$HeroUI/VBoxContainer/Hunger.visible = state.get_hunger_count() >= 50

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
	if state.meets_precondition(GoapConstants.HERO_STATE_IS_FRIGHTENED, false):
		return true

	if $CalmDownTimer.is_stopped():
		$CalmDownTimer.start()

	return false


func _on_detection_radius_body_entered(body) -> void:
	if body.is_in_group(GoapConstants.GROUP_TROLL):
		state.set_state(GoapConstants.HERO_STATE_IS_FRIGHTENED, true)


func _on_calm_down_timer_timeout() -> void:
	state.set_state(GoapConstants.HERO_STATE_IS_FRIGHTENED, false)


func _on_hunger_timer_timeout() -> void:
	var hunger : int = state.get_hunger_count()
	if hunger < MAX_HUNGER:
		hunger += 2
	state.set_hunger_count(hunger)
	GoapEvents.emit_signal("goap_set_hunger", hunger)
