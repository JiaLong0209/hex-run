extends Control

#@onready var play_button = $CenterContainer/VBoxContainer/PlayButton
#@onready var quit_button = $CenterContainer/VBoxContainer/QuitButton
#@onready var arr = [play_button, quit_button]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	print(arr)
	pass
		

func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/world.tscn")
	Score.reset()
	Life.reset()

func _on_quit_button_pressed():
	get_tree().quit()

