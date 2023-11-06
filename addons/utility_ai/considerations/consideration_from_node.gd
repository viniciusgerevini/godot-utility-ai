@tool
##
## Calculate consideration score from a node's property or method.
##
class_name UtilityAiConsiderationFromNode extends UtilityAiConsideration

##
## Node with the property or method holding the value for the consideration.
##
@export var node: Node
# TODO make it a list with all properties in node
## This is name of the property or method with the value to use in the consideration.
## Ideally it should return a value between 0.0 and 1.0. Use max_value in case your value exceeds this range.
## This also accepts boolean returns, where false will be 0.0 and true 1.0.
@export var property_name: String = "";

## By default, the consideration expects a value between
## 0.0 and 1.0. If your value does not fit this range you
## can set what is the max value so it's converted to 1.0
@export var max_value: float = 1.0;


func score() -> float:
	var score = _get_value_from_node()
	return score / max_value


func _get_value_from_node() -> float:
	if node == null:
		push_error("Node not set for consideration '%s' " % self.name)
		return 0.0

	if property_name == "":
		push_error("Property name not set for consideration '%s' " % self.name)
		return 0.0

	if not (property_name in node):
		push_error("Couldn't find property or method for consideration '%s' " % self.name)
		return 0.0

	var value =  node.call(property_name) if node.has_method(property_name) else node.get(property_name)

	if typeof(value) == TYPE_BOOL:
		return 1.0 if value else 0.0

	return value


func _get_configuration_warnings():
	var warnings = []

	var considerations = self.get_child_count()

	if node == null:
		warnings.push_back("Target node not set")
	if property_name == "":
		warnings.push_back("Target property name not set")

	return warnings
