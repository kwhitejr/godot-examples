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

@export var navigation_goal : Node
@onready var state : HeroState = HeroState.new()

const MAX_HUNGER := 100
const MOVEMENT_SPEED := 4000.0

var last_direction : Vector2 = Vector2.RIGHT

func _ready() -> void:
	#navigation_goal = GoapWorldState.get_closest_element(GoapConstants.GROUP_FIREPIT_SPOT, self)
	navigation_goal = $"../Woodstock3"
	$NavigationAgent2D.target_position = navigation_goal.global_position
	
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

func _process(_delta: float) -> void:
	$HeroUI/VBoxContainer/Fear.visible = state.meets_precondition(GoapConstants.HERO_STATE_IS_FRIGHTENED, true)
	$HeroUI/VBoxContainer/Hunger.visible = state.get_hunger_count() >= 50
	
func _physics_process(delta: float) -> void:
	if !$NavigationAgent2D.is_target_reached():
		var nav_point_direction = to_local($NavigationAgent2D.get_next_path_position()).normalized()
		last_direction = nav_point_direction
		hero_run.emit(nav_point_direction)
		velocity = nav_point_direction * MOVEMENT_SPEED * delta
		move_and_slide()

func make_idle(direction: Vector2) -> void:
	hero_idle.emit(direction)

func move_to(direction: Vector2, delta: float) -> void:
	last_direction = direction
	hero_run.emit(direction)
	# warning-ignore:return_value_discarded
	move_and_collide(direction * delta * 100)

func set_navigation_goal(goal: Node) -> void:
	navigation_goal = goal
	#$NavigationAgent2D.target_position = navigation_goal.global_position


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
