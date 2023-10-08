extends Control


func _ready():
	visible = false
	
	var canvas_rid = get_canvas_item()
#	var z = get_tree().get_nodes_in_group("Walls").size()
#	print(z)
	
	RenderingServer.canvas_item_set_z_index(canvas_rid, 10000)
	



func _on_restart_button_pressed():
	visible = false
	get_tree().reload_current_scene()
	Score.reset()

func _on_back_button_pressed():
	visible = false
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

func _on_quit_button_pressed():
	get_tree().quit()
