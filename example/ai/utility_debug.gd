extends Node2D

@export var utility_agent: UtilityAiAgent = null

var elements = {}

var show_only_top = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if utility_agent != null:
		_setup_actions()


func _process(_delta):
	if utility_agent == null or not self.visible:
		return
	if elements.is_empty():
		_setup_actions()
	else:
		_update_scores()


func _setup_actions():
	var scores = utility_agent.get_all_scores()
	for score in scores:
		var container = $PanelContainer/MarginContainer/score_list/action_score.duplicate()
		elements[score.action] = container

		container.get_node("label").text = score.action
		container.get_node("score").text = "%.3f" % score.score
		$PanelContainer/MarginContainer/score_list.add_child(container)
		container.show()


func _update_scores():
	var scores = utility_agent.get_all_scores()
	var top = scores[0].action
	for score in scores:
		var is_top_action = score.action == top
		var container = elements[score.action]
		container.get_node("label").text = score.action
		container.get_node("score").text = "%.3f" % score.score
		container.modulate = Color("#b4d433") if is_top_action else Color("#ffffff")
		_adjust_container_visibility(container, is_top_action)


func _adjust_container_visibility(container, is_top_action):
	if show_only_top:
		$PanelContainer/MarginContainer/score_list/action_score.hide()
		container.visible = is_top_action
		if container.visible:
			container.get_node("label").custom_minimum_size.x = 0
			container.get_node("score").visible = false
	else:
		$PanelContainer/MarginContainer/score_list/action_score.show()
		container.get_node("label").custom_minimum_size.x = 140
		container.get_node("score").visible = true
		container.visible = true
