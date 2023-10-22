extends Control


func _ready():
	visible = false
	
	var canvas_rid = get_canvas_item()
#	var z = get_tree().get_nodes_in_group("Walls").size()
	
	RenderingServer.canvas_item_set_z_index(canvas_rid, 100)


func _on_restart_button_pressed():
	Global.reset()
	TransitionLayer.reload()
	visible = false

func _on_back_button_pressed():
	Global.reset()
	TransitionLayer.change_scene("res://Scenes/main_menu.tscn")
	visible = false

func _on_quit_button_pressed():
	get_tree().quit()
