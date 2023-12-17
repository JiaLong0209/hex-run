extends Node2D

var transition = 1.0

func _ready() -> void:
	var tw = get_tree().create_tween().set_parallel()
	var alter_scale = Vector2(0.12, 0.12)
	tw.tween_property(self, "modulate:a", 0, transition)
	#tw.tween_property(self, "rotation", 4 * PI, transition)
	await get_tree().create_timer(transition).timeout
	queue_free()

