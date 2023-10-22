extends StaticBody2D


var my_scale = 10
var delta_scale = 3
var delta_rotation = PI / 6
var rotate_direction = 1

func _ready():
	if(Global.score > 10):
		rotate_direction = randi_range(-1,1)
	elif(Global.score > 30):
		rotate_direction = randi_range(-2,2)
		

func _physics_process(delta):
	scale = Vector2(my_scale, my_scale)
	my_scale -= delta_scale * delta
	
	if(Global.score > 10):
		rotation += delta_rotation * delta * (Global.score / 10.0) * rotate_direction
		if(delta_scale < 12):
			delta_scale += delta * Global.score / 10.0
		
	if(my_scale < 0):
		queue_free()
 

func _on_score_box_body_entered(body):
	if body.is_in_group("Players"):
		Global.score += 1
		UI.update()
		
