extends Node

signal stat_change

enum MoveType {
	KEYBOARD,
	MOUSE
}

enum Difficulty {
	EASY = 0,
	NORMAL = 1,
	HARD = 2
}

var game_difficulty = Difficulty.NORMAL
var diff_list = [Difficulty.EASY,Difficulty.NORMAL,Difficulty.HARD]

var player_health := 10 :
	set(value):
		player_health = value
		stat_change.emit()	

var score := 0:
	set(value):
		score = value
		stat_change.emit()	

var all_best_score = {
	Difficulty.EASY : 0,
	Difficulty.NORMAL : 0,
	Difficulty.HARD : 0,
}

var best_score := 0:
	set(value):
		all_best_score[game_difficulty] = value
		stat_change.emit()	
	get:
		return all_best_score[game_difficulty]

var is_fullscreen = true

# 0 = keyboard, 1 = mouse
var move_mode = MoveType.KEYBOARD
var global_camera_zoom = Vector2(1.0, 1.0)

@onready var get_score_label = preload('res://UI/get_score_label.tscn')
@onready var jump_effects = preload("res://Objects/jump_effects.tscn")

#func maxSum(arr, k:int):
	#for i in range(arr.size()):
		#arr[i] = arr.slice(i, k+i).reduce(func(acc,cur): return acc + cur, 0)
	#print(arr.max())

func _ready():
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	Engine.max_fps = 0

func _process(_delta):
	if Input.is_action_just_pressed("full_screen"):
		toggle_screen_mode()
	
	if Input.is_action_just_pressed("change_move_mode"):
		toggle_move_mode()
	
	if Input.is_action_just_pressed("change_next_game_difficulty"):
		change_game_difficulty(1)
	
	if Input.is_action_just_pressed("change_prev_game_difficulty"):
		change_game_difficulty(-1)
	
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
		
	if Input.is_action_just_pressed("zoom_in"):
		camera_zoom(1.1)
	
	if Input.is_action_just_pressed("zoom_out"):
		camera_zoom(1 / 1.1)


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

func get_player():
	if(get_tree().get_nodes_in_group("Players")):
		var player = get_tree().get_nodes_in_group("Players")[0] as CharacterBody2D 
		return player
	else:
		return null

func popup_score():
	var s = get_score_label.instantiate()
	var player = get_player()
	var random_position = Vector2(randi_range(-50, 0), randi_range(-50, 0))
	s.position = player.position + random_position
	add_child(s)

func show_jump_effects():
	var jump_effects = jump_effects.instantiate()
	var player = get_player()
	jump_effects.position = player.position
	jump_effects.rotation = rad_to_deg(randf_range(0, 2 * PI))
	add_child(jump_effects)
	
	
	
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

func change_game_difficulty(count: int):
	if(get_tree().current_scene.name != 'MainMenu'): return
	var diff_index = diff_list.find(game_difficulty)
	game_difficulty = diff_list[(diff_index+count) % len(diff_list)]
	UI.update()
 
func camera_zoom(value: float): 
	var player = get_player() as Player
	if(! player): return
	var camera = player.get_node("Camera2D")
	#var alter_zoom = Vector2(camera.zoom.x + value, camera.zoom.y + value)
	var alter_zoom = camera.zoom * value
	if(alter_zoom.x < 0.66): 
		alter_zoom = camera.zoom
	
	var tween = get_tree().create_tween().set_parallel(true)
	tween.tween_property(camera, "zoom", alter_zoom, 0.15)
	global_camera_zoom = alter_zoom


 
