@icon("../icons/aggregation.svg")
@tool
class_name UtilityAiAggregation extends UtilityAi

enum AGGREGATION {
	AVG,
	MULT,
	SUM,
	MAX,
	MIN
}

@export var aggregation_type: AGGREGATION = AGGREGATION.MULT

var aggregation_handler = {
	AGGREGATION.MULT: _multiply,
	AGGREGATION.SUM: _sum,
	AGGREGATION.AVG: _average,
	AGGREGATION.MAX: _max,
	AGGREGATION.MIN: _min,
}


func calculate_score() -> float:
	return aggregation_handler[aggregation_type].call()


func _sum():
	var scores := 0.0
	for consideration in get_children():
		if not _is_valid_child(consideration):
			continue
		scores += consideration.calculate_score()

	return scores


func _multiply():
	var number_of_considerations := 0
	var scores := 1.0
	for consideration in get_children():
		if not _is_valid_child(consideration):
			continue
		number_of_considerations += 1
		scores *= consideration.calculate_score()

	if number_of_considerations == 0:
		return 0.0

	return scores


func _average():
	var number_of_considerations := 0
	var sum_of_scores := 0.0
	for consideration in get_children():
		if not _is_valid_child(consideration):
			continue
		number_of_considerations += 1
		sum_of_scores += consideration.calculate_score()

	if number_of_considerations == 0:
		return 0.0

	return sum_of_scores / number_of_considerations


func _max():
	var max_score := 0.0
	for consideration in get_children():
		if not _is_valid_child(consideration):
			continue
		max_score = max(consideration.calculate_score(), max_score)
	return max_score


func _min():
	var min_score := 9999.0
	for consideration in get_children():
		if not _is_valid_child(consideration):
			continue
		min_score = min(consideration.calculate_score(), min_score)

	return min_score


func _is_valid_child(consideration):
	if not (consideration is UtilityAiConsideration or consideration is UtilityAiAggregation):
		push_warning("aggregation %s has a child that is not a consideration: %s" % [self.name, consideration.name])
		return false
	return true


func _get_configuration_warnings():
	var warnings = []
	var considerations = self.get_child_count()

	if considerations == 0:
		warnings.push_back("Aggregation node has no child consideration")

	for consideration in self.get_children():
		if not (consideration is UtilityAiConsideration or consideration is UtilityAiAggregation):
			warnings.push_back("Child needs to be a UtilityAiConsideration or UtilityAiAggregation")

	return warnings
