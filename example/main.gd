extends Node2D

enum debug_mode {
	ALL,
	TOP,
	NONE
}

@export var current_debug_mode = debug_mode.ALL

func _ready():
	_set_debug_mode(current_debug_mode)


func _on_firepit_area_body_exited(body):
	body.is_safe = false


func _on_firepit_heat_area_body_entered(body):
	body.is_safe = true


func _on_toggle_debug_pressed():
	match current_debug_mode:
		debug_mode.ALL:
			_set_debug_mode(debug_mode.TOP)
		debug_mode.TOP:
			_set_debug_mode(debug_mode.NONE)
		debug_mode.NONE:
			_set_debug_mode(debug_mode.ALL)


func _set_debug_mode(new_mode: debug_mode):
	current_debug_mode = new_mode
	for d in get_tree().get_nodes_in_group("utility_debug"):
		match current_debug_mode:
			debug_mode.ALL:
				d.show()
				d.show_only_top = false
			debug_mode.TOP:
				d.show()
				d.show_only_top = true
			debug_mode.NONE:
				d.hide()
