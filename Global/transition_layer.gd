extends CanvasLayer

func _onready():
	pass

func change_scene(path : NodePath):
	$AnimationPlayer.play('to_black')
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_file(path)
	$AnimationPlayer.play_backwards("to_black")
	
func reload():
	$AnimationPlayer.play('to_black')
	await $AnimationPlayer.animation_finished
	get_tree().reload_current_scene()
	$AnimationPlayer.play_backwards("to_black")
		
