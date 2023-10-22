extends Button
class_name ButtonContainer

var extend_scale = 1.3
var collision_offset := 0.0
var is_player_enter := false
#var hover_theme = preload("res://Styles/hover.tres")
#var normal_theme = preload("res://Styles/button.tres")
@onready var collision_shape = $Area2D/CollisionShape2D
@onready var normal_size = get_parent().size.x
@onready var extend_size = get_parent().size.x * extend_scale


func _ready():
	pass # Replace with function body.
	
	
func _process(_delta):
	collision_offset = normal_size / 2
	var tw = create_tween()
	tw.set_parallel()
	transform_listener(tw)

func width_extend(tw: Tween):
#	tw.tween_property(self, "theme" , hover_theme, 0.1)
	tw.tween_property(self, "position:x", -normal_size * (extend_scale - 1) / 2, 0.1)
	tw.tween_property(self, "size:x", extend_size, 0.1)
	tw.tween_property(collision_shape, "position:x", collision_offset +  normal_size * (extend_scale - 1) / 2, 0.1)
	tw.tween_property(collision_shape, "shape:height", extend_size, 0.1)
	

func width_reset(tw: Tween):
#	tw.tween_property(self, "theme" , normal_theme, 0.1)
	tw.tween_property(self, "position:x", 0, 0.1)
	tw.tween_property(self, "size:x", normal_size, 0.1)
	tw.tween_property(collision_shape, "position:x", collision_offset, 0.1)
	tw.tween_property(collision_shape, "shape:height", normal_size, 0.1)

func transform_listener(tw: Tween):
	if(is_player_enter || self.is_hovered()):
		width_extend(tw)
	else:
		width_reset(tw)
		
	
func _on_area_2d_body_entered(body):
	if body.is_in_group("Players"):
		is_player_enter = true


func _on_area_2d_body_exited(body):
	if body.is_in_group("Players"):
		is_player_enter = false

