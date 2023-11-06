@icon("../icons/agent.svg")
##
## Utility AI Agent that process and notify the highest utility action available.
##
class_name UtilityAiAgent extends UtilityAi

## Emmited when the highest scored action changed.
signal top_score_action_changed(top_action_id)

## Enable or disable the agent
@export var enabled: bool = true

var _current_top_action
var _action_scores = []
var _score_sorted = false


func _physics_process(delta):
	if not enabled:
		return
	_process_actions()


func _process_actions():
	var actions = self.get_children()

	if actions.size() == 0:
		push_warning("Utility AI agent should have at least one action as child node")
		return

	var top_action = _get_highest_utility_action(actions)

	if top_action != null and top_action.get_action_id() != _current_top_action:
		_current_top_action = top_action.get_action_id()
		top_score_action_changed.emit(_current_top_action)


func _get_highest_utility_action(actions: Array) -> UtilityAiAction:
	var top_action
	var top_action_utility = -1.0

	var all_scores = []

	for action in actions:
		if not (action is UtilityAiAction):
			push_warning("Child '%s' is not an action" % action.name)
			continue
		var score = action.calculate_score()

		all_scores.push_back({
			"action": action.get_action_id(),
			"score": score,
		})

		if score > top_action_utility:
			top_action_utility = score
			top_action = action

	_action_scores = all_scores
	_score_sorted = false

	return top_action


##
## Returns a sorted list with all scores calculated from highest to lowest.
## It does not trigger a re-calculation. It uses the last calculated score.
##
## Array<{ "action": string, "score": float }>
##
func get_all_scores() -> Array:
	if not _score_sorted:
		_action_scores.sort_custom(func(a, b): return a.score > b.score)
		_score_sorted = true
	return _action_scores
