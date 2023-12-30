extends StaticBody2D


var my_scale = 10
var delta_scale = 3
var delta_rotation = PI / 6
var rotate_direction = 1

func _ready():
	match Global.game_difficulty:
		Global.Difficulty.EASY:
			rotate_direction = 0
		
		Global.Difficulty.NORMAL:
			if(Global.score > 10):
				rotate_direction = randi_range(-1,1)
			elif(Global.score > 30):
				rotate_direction = randi_range(-2,2)
		
		Global.Difficulty.HARD:
			var rotate_choice = [1,-1]
			if(Global.score > 10):
				rotate_choice = [2,1,-1,-2]
			elif(Global.score > 20):
				rotate_choice = [4,3,-3,-4]
			elif(Global.score > 30):
				rotate_choice = [6,5,-6,-5]
			elif(Global.score > 40):
				rotate_choice = [12, 9 , -9, -12]
			elif(Global.score > 50):
				rotate_choice = [18, 15 , -18, -15]
			
			rotate_direction = rotate_choice[randi_range(0, len(rotate_choice)-1)]
				

func _physics_process(delta):
	scale = Vector2(my_scale, my_scale)
	my_scale -= delta_scale * delta
	
	rotation += delta_rotation * delta * (Global.score / 10.0) * rotate_direction
	if(delta_scale < 12):
		delta_scale += delta * Global.score / 10.0
		
	if(my_scale < 0):
		queue_free()
 

func _on_score_box_body_entered(body):
	if body.is_in_group("Players"):
		Global.score += 1
		Global.best_score = max(Global.best_score, Global.score)
		Global.popup_score()
		
