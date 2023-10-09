extends Node


func maxSum(arr, k:int):
	for i in range(arr.size()):
		arr[i] = arr.slice(i, k+i).reduce(func(acc,cur): return acc + cur, 0)
	print(arr.max())
	

func _ready():
	maxSum([3,5,3,1,1,5,9], 3)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("game_end"):
		get_tree().quit()
	
	if Input.is_action_just_pressed("game_restart"):
		get_tree().change_scene_to_file("res://Scenes/world.tscn")
		Score.reset()
		Life.reset()
		print('restart')
		
