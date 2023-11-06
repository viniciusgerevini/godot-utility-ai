@tool
@icon("../icons/action.svg")
class_name UtilityAiAction extends UtilityAi

@export var _action_id = ""

##
## Id for the action. If not set, it returns the node name.
##
func get_action_id():
	return _action_id if _action_id != "" else self.name


func calculate_score() -> float:
	var considerations = self.get_children()

	if considerations.size() == 0:
		return 0.0


	var consideration = considerations[0]

	return consideration.calculate_score()


func _get_configuration_warnings():
	var warnings = []
	var considerations = self.get_child_count()

	if considerations == 0:
		warnings.push_back("Action node has no child consideration")
	elif considerations > 1:
		warnings.push_back("Action node has more than one child. For multiple considerations use UtilityAiConsiderationAggregation")

	for consideration in self.get_children():
		if not (consideration is UtilityAiConsideration or consideration is UtilityAiAggregation):
			warnings.push_back("Child needs to be a UtilityAiConsideration or UtilityAiAggregation")

	return warnings
