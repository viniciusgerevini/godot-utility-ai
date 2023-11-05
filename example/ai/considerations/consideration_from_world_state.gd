extends UtilityAiConsideration
# this is an example of a custom consideration
# to calculate score from different places, like a global state.

## This is name of the property or method from the world state to use in the consideration.
## Ideally it should return a value between 0.0 and 1.0. Use max_value in case your value exceeds this range.
## This also accepts boolean returns, where false will be 0.0 and true 1.0.
@export var property_name: String = "";

## By default, the consideration expects a value between
## 0.0 and 1.0. If your value does not fit this range you
## can set what is the max value so it's converted to 1.0
@export var max_value: float = 1.0;

func score() -> float:
	var score = _get_value_from_world_state()
	return score / max_value


func _get_value_from_world_state() -> float:
	if property_name == "":
		push_error("Property name not set for consideration '%s' " % self.name)
		return 0.0

	if not (property_name in WorldState):
		push_error("Couldn't find property or method for consideration '%s' in world state " % self.name)
		return 0.0

	var value =  WorldState.call(property_name) if WorldState.has_method(property_name) else WorldState.get(property_name)

	if typeof(value) == TYPE_BOOL:
		return 1.0 if value else 0.0

	return value
