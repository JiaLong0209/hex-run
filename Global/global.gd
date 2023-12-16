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

var best_score := 0:
	set(value):
		best_score = value
		stat_change.emit()	


var is_fullscreen = true

# 0 = keyboard, 1 = mouse
var move_mode = MoveType.KEYBOARD


#func maxSum(arr, k:int):
	#for i in range(arr.size()):
		#arr[i] = arr.slice(i, k+i).reduce(func(acc,cur): return acc + cur, 0)
	#print(arr.max())

func _ready():
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	
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
		start()
		
	if Input.is_action_just_pressed("game_start"):
		start()
		
	if Input.is_action_just_pressed("clear_best_score"):
		best_score = 0
	
	if Input.is_action_just_pressed("back_to_menu"):
		back_to_menu()
		

func reset():
	player_health = 10
	score = 0
	UI.update()

func start():
	TransitionLayer.change_scene("res://Scenes/world.tscn")
	reset()
	EndMenu.visible = false
	

func back_to_menu():
	reset()
	TransitionLayer.change_scene("res://Scenes/main_menu.tscn")
	EndMenu.visible = false
