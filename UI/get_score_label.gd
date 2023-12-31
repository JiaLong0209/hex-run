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
	UI.change_score_text_color(self, Global.score, 0, tw)



func _process(delta: float) -> void:
	pass
