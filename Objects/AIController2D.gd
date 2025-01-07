extends AIController2D

# meta-name: AI Controller Logic
# meta-description: Methods that need implementing for AI controllers
# meta-default: true
#extends _BASE_

var direction = Vector2.ZERO
var jump = false
var speed_up = false
@onready var player : Player = $".."
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
	var max_hex_count = 3
	var params = 7
	

	var obs := [
		player.global_position.x,
		player.global_position.y,
		player.speed_up,
		Global.player_health,
		Global.score
	]
	
	for i in range(max_hex_count):
		if i < hexes.size():  # Use actual data if available
			var hex = hexes[i]
			var score_box : Area2D = hex.find_child("ScoreBox")
			var collision_box : CollisionShape2D = score_box.find_child("ScoreCollisionBox")
			var distance = player.global_position.distance_to(collision_box.global_position)
			
			obs += [
				collision_box.global_position.x,
				collision_box.global_position.y,
				distance,
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
	return reward

	
	
func get_action_space() -> Dictionary:
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
