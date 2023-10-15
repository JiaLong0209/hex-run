extends Button
class_name ButtonContainer
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var tw = create_tween()
	tw.set_parallel()
	if self.is_hovered():
		tw.tween_property(self, "position:x", -get_parent().size.x * 0.25, 0.1)
		tw.tween_property(self, "size:x", get_parent().size.x * 1.5, 0.1)
#		tw.tween_property(self, "theme_override_styles/normal", get_parent().size.x * 1.5, 0.1)
	else:
		tw.tween_property(self, "position:x", 0, 0.1)
		tw.tween_property(self, "size:x", get_parent().size.x, 0.1)
		
	pass
