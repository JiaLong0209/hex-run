
extends Node2D
# Called when the node enters the scene tree for the first time.

var history : Dictionary = {
	"scores": [],
	"best_scores": [],
	"scores_means": [],
	"loss": [],
	"final_reward": [],
	
}

enum PlayInfo {
	SCORES = 0,
	BEST_SCORES = 1,
	SCORES_MEANS = 2
}

var scores : Array = history["scores"]
var best_scores : Array = history["best_scores"]
var scores_means : Array = history["scores_means"]
var scores_sum : float = 0
var scores_mean : float = 0.0
var save_path = "res://Logs/history_01.json"


func _ready():
	print("AI Environment")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
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

func get_ai_controller():
	return $Player/AIController2D
	
	

func show_play_info():
	var ai_controller: Node2D = get_ai_controller()
	
	var last_score: int = 0
	var last_mean_score: float = 0.0
	
	if(scores.size() > 1):
		last_score = scores[scores.size()-2]
		last_mean_score = scores_means[scores_means.size()-2]
	
	print("-------AI PLAY INFO-------")
	print("Scores: " + str(scores))
	print("Total play count: " + str(scores.size()))
	print("Current score: %f (%f)"  % [Global.score, Global.score - last_score])
	print("Best Score: " + str(Global.best_score))
	print("Mean score: %f (%f)"  % [scores_means.back(), scores_mean - last_mean_score])
	print("---AI---")
	print("Final Reward: " + str(ai_controller.get_reward()))
	print("-------AI PLAY INFO END------")
	print("")
	
	
func update_history():
	var ai_controller: Node2D = get_ai_controller()
	
	history["scores"] += [Global.score]
	history["best_scores"] += [Global.best_score]
	history["final_reward"] += [ai_controller.get_reward()]
	
	scores = history["scores"]
	best_scores = history["best_scores"]
	scores_means = history["scores_means"]
	scores_sum = 0
	scores_mean = 0

	for score in scores:
		scores_sum += score
	if scores: 
		scores_mean = scores_sum / scores.size()
		
	history["scores_means"] += [scores_mean]

func reset_env():
	$Player.position = Vector2(0, 0)
	
	for hex in get_tree().get_nodes_in_group("Walls"):
		hex.queue_free()
	
	$HexSpawner.wait_time = Global.start_params["wait_time"]
	
func update_reward():  
	var ai_controller: Node2D = get_ai_controller()
	
	var prev_scores = history['scores']
	
	if prev_scores.size():
		var last_score = prev_scores[prev_scores.size()-1]
		
		var diff = abs(last_score - Global.score)
		#
		#if Global.score <= last_score:
			#ai_controller.reward -= 3.0 * (diff)
		#else:
			#ai_controller.reward += 3.0 * (diff)
		#
		#diff = abs(Global.score - Global.best_score)
		#
		#if Global.score <= Global.best_score: 
			#ai_controller.reward -= 5.0 * (diff ** 1.5)
			
		ai_controller.reward += 3.0 * (Global.score)
	

func save_history():
	Global.save_dict_to_json(save_path, history)
	
func _on_player_ai_died():
	update_reward()
	update_history()
	save_history()
	show_play_info()
	reset_env()
	



