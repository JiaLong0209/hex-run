extends Node

signal stat_change

enum MoveType {
	KEYBOARD,
	MOUSE
}

var player_health := 10 :
	set(value):
		player_health = value
		stat_change.emit()	

var score := 0:
	set(value):
		score = value
		stat_change.emit()	

var is_fullscreen = true

# 0 = keyboard, 1 = mouse
var move_mode = MoveType.KEYBOARD


func maxSum(arr, k:int):
	for i in range(arr.size()):
		arr[i] = arr.slice(i, k+i).reduce(func(acc,cur): return acc + cur, 0)
	print(arr.max())
	toggle_screen_mode()

func _ready():
	maxSum([3,5,3,1,1,5,9], 3)
	
func toggle_screen_mode():
	is_fullscreen = !is_fullscreen
	if(is_fullscreen):
		print('FullScreen')
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		print('Windowed')
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func toggle_move_mode():
	if(move_mode == MoveType.KEYBOARD):
		move_mode = MoveType.MOUSE
	else:
		move_mode = MoveType.KEYBOARD

func _process(_delta):
	if Input.is_action_just_pressed("full_screen"):
		toggle_screen_mode()
	
	if Input.is_action_just_pressed("change_move_mode"):
		toggle_move_mode()
	
	if Input.is_action_just_pressed("game_end"):
		get_tree().quit()
	
	if Input.is_action_just_pressed("game_restart"):
		get_tree().change_scene_to_file("res://Scenes/world.tscn")
		Global.reset() 
		print('restart')
		

func reset():
	player_health = 10
	score = 0
	UI.update()
