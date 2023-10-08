extends Control

var life = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	update_life()

func update_life():
	$Label.text = "Life: %s" % [life]
	
func reset():
	life = 10
	update_life()
