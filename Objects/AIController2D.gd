extends AIController2D

# meta-name: AI Controller Logic
# meta-description: Methods that need implementing for AI controllers
# meta-default: true
#extends _BASE_

var direction = Vector2.ZERO
var jump = false
var speed_up = false

#-- Methods that need implementing using the "extend script" option in Godot --#

func find(parent, type):
	for child in parent.get_children():
		if is_instance_of(child, type):
			return child
		var grandchild = find(child, type)
		if grandchild != null:
			return grandchild
	return null
	
func get_obs() -> Dictionary:
	#print("-------get_obs------")
	
	# Get all nodes in the 'Walls' group
	var hexes: Array[Node] = get_tree().get_nodes_in_group("Walls")
	
	# Prepare an observation array for 3 hexes, each with 4 values
	var obs := [self.global_position.x, self.global_position.y]
	var max_hex_count = 2
	var params = 6
	
	# Iterate through up to the first 3 hexes, or fewer if less are present
	for i in range(max_hex_count):
		if i < hexes.size():  # Use actual data if available
			var hex = hexes[i]
			var score_box : Area2D = hex.find_child("ScoreBox")
			var collision_box : CollisionShape2D = score_box.find_child("ScoreCollisionBox")
			obs += [
				collision_box.global_position.x,
				collision_box.global_position.y,
				hex.my_scale,
				hex.delta_scale,
				hex.rotate_direction,
				hex.delta_rotation,
			]
		else:  # Fill remaining slots with zeros if fewer hexes exist
			for j in range(params):
				obs += [0]
	
	# Debug output for verification
	#print("Observed hexes count: ", hexes.size())
	#print("Observation data: ", obs)
	#print("-----end-------")
	
	# Return the observations in a dictionary
	return {"obs": obs}


func get_reward() -> float:	
	#assert(false, "the get_reward method is not implemented when extending from ai_controller") 
	print(reward)
	return reward 
	
func get_action_space() -> Dictionary:
	#assert(false, "the get get_action_space method is not implemented when extending from ai_controller") 
	return {
			"direction" : {
				"size": 2,
				"action_type": "continuous"
			},
			"jump" : {
				"size": 1,
				"action_type": "discrete"
			},
			"speed_up" : {
				"size": 1,
				"action_type": "discrete"
			},
		}
	
func set_action(action) -> void:	
	#assert(false, "the get set_action method is not implemented when extending from ai_controller") 	
	print("Action:")
	print(action)
	direction.x = action["direction"][0]
	direction.y = action["direction"][1]
	jump = action["jump"]
	speed_up = action["speed_up"]
	
	
	
# -----------------------------------------------------------------------------#

#-- Methods that can be overridden if needed --#

#func get_obs_space() -> Dictionary:
# May need overriding if the obs space is complex
#	var obs = get_obs()
#	return {
#		"obs": {
#			"size": [len(obs["obs"])],
#			"space": "box"
#		},
#	}
