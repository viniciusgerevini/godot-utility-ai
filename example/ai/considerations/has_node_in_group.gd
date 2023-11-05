extends UtilityAiConsideration
#
# This is an example for a custom consideration.
# This script checks if there is any node available in the given group.
#

##
## Target group
##
@export var target_group: String = ""


func score() -> float:
	if target_group == "":
		push_error("Target node not set for consideration '%s' " % self.name)
		return 0.0

	var nodes = get_tree().get_nodes_in_group(target_group)

	return 1.0 if nodes.size() > 0 else 0.0
