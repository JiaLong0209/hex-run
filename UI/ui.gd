extends CanvasLayer

var green := Color('55f059')
var red := Color(0.9, 0, 0, 1)
var yellow := Color('fff377')
var blue := Color('2551f5')
var white := Color('fff')
var transition := 0.4

@onready var health_label := $UIContainer/VBoxContainer/HealthContainer/HealthLabel
@onready var score_label := $UIContainer/VBoxContainer/ScoreContainer/ScoreLabel
@onready var health_bar := $HealthBar
@onready var health_sprite := preload("res://Objects/health_sprite.tscn")
@onready var health_container := $UIContainer/VBoxContainer/HealthContainer
@onready var score_container := $UIContainer/VBoxContainer/ScoreContainer
@onready var best_score_label := $UIContainer/VBoxContainer/ScoreContainer2/BestScoreLabel
@onready var best_score_container:= $UIContainer/VBoxContainer/ScoreContainer2
@onready var fps_label := $UIContainer/VBoxContainer2/FPSLabel

func _ready():
	Global.connect("stat_change", update)
	update()


func _process(delta: float) -> void:
	fps_label.text = "FPS: %d" % round(Engine.get_frames_per_second())

func update_player_health_text(tw):
	
	for i in get_tree().get_nodes_in_group("HealthSprites"):
		i.queue_free()
	
	for i in range(Global.player_health):
		var new_sprite = health_sprite.instantiate()
		health_container.add_child(new_sprite)
		
	tw.tween_property(health_bar, "value", Global.player_health, transition / 2.0)
	
	if(Global.player_health <= 3):
		tw.tween_property(health_container, "modulate", red, transition)
	elif(Global.player_health <= 6):
		tw.tween_property(health_container, "modulate", yellow, transition)
	elif(Global.player_health <= 9):
		tw.tween_property(health_container, "modulate", green, transition)
	else:
		tw.tween_property(health_container, "modulate", white, transition)
		
		
func update_score_text(tw):
	score_label.text = "Score: %d" % [Global.score]
	
	if(Global.score < 10):
		tw.tween_property(score_container, "modulate", white, transition)
	elif(Global.score < 30):
		tw.tween_property(score_container, "modulate", green, transition)
	elif(Global.score < 50):
		tw.tween_property(score_container, "modulate", yellow, transition)
	else:
		tw.tween_property(score_container, "modulate", blue, transition)

	
func update_best_score_text(tw):
	best_score_label.text = "Best Score: %d" % [max(Global.score, Global.best_score)]
	if(Global.score < 10):
		tw.tween_property(best_score_container, "modulate", white, transition)
	elif(Global.score < 30):
		tw.tween_property(best_score_container, "modulate", green, transition)
	elif(Global.score < 50):
		tw.tween_property(best_score_container, "modulate", yellow, transition)
	else:
		tw.tween_property(best_score_container, "modulate", blue, transition)

func update(tw = create_tween()):
	tw.set_parallel()
	update_player_health_text(tw)
	update_score_text(tw)
	update_best_score_text(tw)
	
	
