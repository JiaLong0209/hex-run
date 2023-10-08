extends Control

var score = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	update_score()

func update_score():
	$Label.text = str(score)
	
func reset():
	score = 0
	update_score()
