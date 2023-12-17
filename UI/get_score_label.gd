extends RichTextLabel

var transition = 1.0

func _ready() -> void:
	var tw = get_tree().create_tween().set_parallel()
	change_text_color(tw)
	tw.tween_property(self, "position:y", position.y - 200, transition)
	tw.tween_property(self, "modulate:a", 0, transition)
	await get_tree().create_timer(transition).timeout
	queue_free()

func change_text_color(tw):
	if(Global.score < 10):
		tw.tween_property(self, "modulate", UI.white, 0)
	elif(Global.score < 30):
		tw.tween_property(self, "modulate", UI.green, 0)
	elif(Global.score < 50):
		tw.tween_property(self, "modulate", UI.yellow, 0)
	else:
		tw.tween_property(self, "modulate", UI.blue, 0)
	



func _process(delta: float) -> void:
	pass
