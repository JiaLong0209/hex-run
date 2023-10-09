extends Timer

var hex_scene = preload("res://Objects/hex.tscn")
#var rng = RandomNumberGenerator.new()


func _ready():
	call_deferred("spawn")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func spawn():
	var hex_node = hex_scene.instantiate()
	hex_node.rotation = (PI / 6) * randi_range(0, 11)
	get_tree().current_scene.add_child(hex_node)


func _on_timeout():
	if(self.wait_time > 0.4):
		self.wait_time -= 0.01 * 1.2
	spawn()
