extends CharacterBody2D

var is_moving = false

# those are being exported so we can modify
# the initial value in the example
@export var hunger = 0
@export var stress = 0
@export var energy = 100
var is_sleeping = false
var is_eating = false

var looking_for_food = false
var looking_for_shelter = false

var has_food_in_pocked = false

var is_safe = true:
	set(value):
		is_safe = value
		if is_safe and looking_for_shelter:
			looking_for_shelter = false
			_target = null
			$body.play("idle")


var _target


func _process(delta):
	_handle_energy(delta)
	_handle_hunger(delta)
	_handle_stress(delta)
	_handle_target(delta)


func move_to(direction, delta):
	is_moving = true
	$body.play("run")
	if direction.x > 0:
		turn_right()
	else:
		turn_left()

  # warning-ignore:return_value_discarded
	move_and_collide(direction * delta * 100)


func turn_right():
	if not $body.flip_h:
		return

	$body.flip_h = false


func turn_left():
	if $body.flip_h:
		return

	$body.flip_h = true


func _handle_energy(delta: float):
	if is_sleeping:
		energy += delta * 4
		if energy >= 100:
			energy = 100
			wake_up()
	else:
		energy -= delta * 2
		if energy <= 0:
			energy = 0
			sleep()

	$energy_bar.value = energy


func _handle_hunger(delta: float):
	hunger = clampf(hunger + delta * 5, 0, 100)
	$hunger_bar.value = hunger


func _handle_stress(delta: float):
	if is_safe:
		stress -= delta * 4
	else:
		stress += delta * 2

	stress = clampf(stress, 0, 100)

	$stress_bar.value = stress


func _handle_target(delta: float):
	if is_sleeping:
		return
	if not is_instance_valid(_target):
		_target = null
		# if it's still looking for food, try to find a new target
		if looking_for_food:
			find_food()
		return

	if self.global_position.distance_to(_target.global_position) <= 1:
		$body.play("idle")
		if looking_for_food and _target.is_in_group("food"):
			_target.queue_free()
			has_food_in_pocked = true

		looking_for_food = false
		_target = null

		return

	move_to(self.global_position.direction_to(_target.global_position), delta)



func sleep():
	$body.play("sleep")
	is_sleeping = true


func wake_up():
	$body.play("idle")
	is_sleeping = false


func idle():
	$body.play("idle")


func eat():
	is_eating = true
	$body/mushroom.show()
	await get_tree().create_timer(3).timeout
	hunger = 0
	$hunger_bar.value = 0
	has_food_in_pocked = false
	is_eating = false
	$body/mushroom.hide()


func find_food():
	looking_for_food = true
	var closest = _get_closest_food()
	if closest != null:
		_target = closest


func _get_closest_food():
	var closest = null
	var closest_distance = null
	for food in get_tree().get_nodes_in_group("food"):
		var dist = self.global_position.distance_to(food.global_position)
		if closest_distance == null or closest_distance > dist:
			closest_distance = dist
			closest = food

	return closest


func find_shelter():
	looking_for_shelter = true
	var shelter = get_tree().get_nodes_in_group("firepit")[0]
	_target = shelter



func _on_utility_ai_agent_top_score_action_changed(top_action_id):
	print("Action changed: %s" % top_action_id)

	match top_action_id:
		"idle":
			idle()
		"sleep":
			sleep()
		"eat":
			eat()
		"find_food":
			find_food()
		"look_for_shelter":
			find_shelter()
		"go_to_sleep":
			find_shelter()
		"relax":
			# doesn't need to do anything. Already safe.
			pass

