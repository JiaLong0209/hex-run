extends StaticBody2D

var my_scale = 8
var delta_scale = 3

func _ready():
	pass

func _physics_process(delta):
	scale = Vector2(my_scale, my_scale)
	my_scale -= delta_scale * delta
	
	if(my_scale < 0):
		queue_free()
 
func _on_score_box_body_entered(body):
	if body.is_in_group("Players"):
		Score.score += 1
		Score.update_score()
		
