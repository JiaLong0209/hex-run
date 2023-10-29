extends CharacterBody2D

signal died

@export var move_by_key = true
const speed = 600.0
const JUMP_VELOCITY = -400.0
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction := Vector2.ZERO
var prev_direction := Vector2.ZERO
var active_flashlight = false
var speed_up = 1
var player_vulnerable = true
var player_invulnerable_time = 0.2

func _ready():
	$PointLight2D.visible = active_flashlight
	pass
	
func _physics_process(delta):
	flashlight_handler()
	$PointLight2D.visible = active_flashlight
	speed_up = 1
	if(move_by_key):
		get_move_by_key()
	else:
		get_move_by_mouse(delta)
		
	if(velocity):
		$GPUParticles2D.emitting = true
	
	move_and_slide()
	look_at(get_global_mouse_position())
	
	# rotate
	
#	if get_last_slide_collision() != null:
#		var collider = get_last_slide_collision().get_collider()
#		if collider.is_in_group("Walls"):
#			health -= 10
#			print("Attack")
#
#			print("Your health: %d" % [health])	
#			if(health <= 0):
#				queue_free()
#				print("Die")
#				return

func play_jump():
	$AnimationPlayer.play("Jump")
	pass
	
func play_speed_up():
	var tween = create_tween()
	tween.tween_property($Sprite2D,"scale", Vector2(0.13,0.07), 0.05 )
	tween.tween_property($Sprite2D,"scale", Vector2(0.1,0.1), 0.05 )
	
func flashlight_handler():
	if Input.is_action_just_pressed("Flashlight"):
		active_flashlight = !active_flashlight
	
func get_move_by_key():
	direction = Vector2.ZERO
#	direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

	if Input.is_action_pressed("ui_left"):
		direction.x = -1
	if Input.is_action_pressed("ui_right"):
		direction.x = 1
#	if prev_direction.x == 1 and Input.is_action_pressed("ui_left") and Input.is_action_pressed("ui_right"):
#		direction.x = -1
		
	if Input.is_action_pressed("ui_up"):
		direction.y = -1
	if Input.is_action_pressed("ui_down"):
		direction.y = 1
#	if prev_direction.y == 1 and Input.is_action_pressed("ui_up"):
#		direction.y = -1

	if Input.is_action_pressed("SpeedUp"):
		play_speed_up()
		speed_up = 1.5
		
	if Input.is_action_just_pressed("Jump"):
		play_jump()
		speed_up = 15
		
	prev_direction = direction
	direction = direction.normalized()    
	velocity =  direction * speed * speed_up

func get_move_by_mouse(delta):
	if(Input.is_action_pressed("SpeedUp")):
		play_speed_up()
		speed_up = 1.5
		
	if Input.is_action_just_pressed("Jump"):
		play_jump()
		speed_up = 10
		
	if Input.is_action_pressed("Stop"):
		speed_up = 0
		
	var player_direction = (get_global_mouse_position() - position)
	direction = player_direction.normalized()
	velocity = direction * speed * delta * 100 * speed_up


func _on_hit_box_body_entered(body):
	if body.is_in_group("Walls") and player_vulnerable:
		Global.player_health -= 1
		
		if(Global.player_health <= 0): 
			died.emit()
			queue_free()
			EndMenu.visible = true
			return
			
		$Sprite2D.material.set("shader_parameter/progress", 0.5)
		player_vulnerable = false
		await get_tree().create_timer(player_invulnerable_time).timeout
		$Sprite2D.material.set("shader_parameter/progress", 0)
		player_vulnerable = true
