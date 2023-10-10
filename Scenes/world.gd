extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	print("hello world")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_player_died():
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property($Ground/Decoration, "scale",  Vector2(3,3) , 0.1)
	tween.tween_property($Camera2D2, "zoom", Vector2(0.75,0.75), 0.2)
	tween.set_parallel(false)
	
	tween.tween_property($Ground/Decoration, "position",  Vector2(-60,0) , 0.03).set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property($Ground/Decoration, "position",  Vector2(80,0) , 0.04)
	tween.tween_property($Ground/Decoration, "position",  Vector2(0,0) , 0.01)
	tween.tween_property($Ground/Decoration, "position",  Vector2(-60,0) , 0.03)
	tween.tween_property($Ground/Decoration, "position",  Vector2(80,0) , 0.04)
	tween.tween_property($Ground/Decoration, "position",  Vector2(0,0) , 0.01)
	tween.tween_property($Ground/Decoration, "modulate:a",  0 , 0.5)
