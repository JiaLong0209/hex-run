class_name Player
extends CharacterBody2D

signal died

const speed = 600.0
const JUMP_VELOCITY = -400.0
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction := Vector2.ZERO
var pre_direction := Vector2.ZERO
var pre_position := Vector2.ZERO
var active_flashlight = false
var speed_up = 1
var jump_speed = 15
var player_vulnerable = true
var player_invulnerable_time = 0.2

@onready var player_sprite = $Sprite2D

func _ready():
	$PointLight2D.visible = active_flashlight
	$Camera2D.zoom = Global.global_camera_zoom
	$Sprite2D.material.set("shader_parameter/progress", 0)
	Global.player_health = Global.health
	
	
	
	
	
func _physics_process(delta):
	flashlight_handler()
	$PointLight2D.visible = active_flashlight
	speed_up = 1
	if(!Global.move_mode):
		get_move_by_key()
	else:
		get_move_by_mouse(delta)
		
	if(velocity):
		$GPUParticles2D.emitting = true
	
	pre_position = position
	move_and_slide()
	if(direction != Vector2.ZERO):
		pre_direction = direction
	
	if(Global.move_mode == Global.MoveType.MOUSE):
		look_at(get_global_mouse_position())
	elif(Global.move_mode == Global.MoveType.KEYBOARD):
		#look_at(velocity + position)
		rotate_by_position(velocity + position)
	
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

func rotate_by_position(p_position: Vector2):
	var temp_direction = p_position - position
	if(temp_direction == Vector2.ZERO):
		temp_direction = pre_direction
	
	temp_direction = temp_direction.normalized()
	var c = acos(temp_direction.x)
	var s = asin(temp_direction.y)
	var deg 
	if s < 0:
		deg = s
		if c >= PI * 3/5:
			deg = -deg
			player_sprite.flip_h = false
			player_sprite.flip_v = false
	else:
		deg = c
	
	var tw = get_tree().create_tween()
	tw.tween_property(self,"rotation" , deg, 0.2)

func play_jump():
	$AnimationPlayer.play("Jump")
	Global.show_jump_effects()
	
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
		player_sprite.flip_h = true
		player_sprite.flip_v = true
		direction.x = -1
	if Input.is_action_pressed("ui_right"):
		player_sprite.flip_h = true
		player_sprite.flip_v = false
		#player_sprite.scale.x = -0.1
		direction.x = 1
#		direction.x = -1
		
	if Input.is_action_pressed("ui_up"):
		direction.y = -1
	if Input.is_action_pressed("ui_down"):
		direction.y = 1
#		direction.y = -1

	if Input.is_action_pressed("SpeedUp"):
		play_speed_up()
		speed_up = 1.5
		
	if Input.is_action_just_pressed("Jump"):
		play_jump()
		speed_up = jump_speed
		
	direction = direction.normalized()    
	
	velocity =  direction * speed * speed_up

func get_move_by_mouse(delta):
	if(Input.is_action_pressed("SpeedUp")):
		play_speed_up()
		speed_up = 1.5
		
	if Input.is_action_just_pressed("Jump"):
		play_jump()
		speed_up = jump_speed
		
	if Input.is_action_pressed("Stop"):
		speed_up = 0
		
	var player_direction = (get_global_mouse_position() - position)
	direction = player_direction.normalized()
	velocity = direction * speed * delta * 120 * speed_up


func _on_hit_box_body_entered(body):
	if body.is_in_group("Walls") and player_vulnerable and !Global.practice_mode:
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
