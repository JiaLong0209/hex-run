extends CharacterBody2D

signal died

const speed = 600.0
const JUMP_VELOCITY = -400.0
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction := Vector2.ZERO
var move_by_key = true
var speed_up = 1


func _ready():
	pass
	
func get_input():
	direction = Vector2.ZERO
#	direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if Input.is_action_pressed("ui_left"):
		direction.x = -1
	if Input.is_action_pressed("ui_right"):
		direction.x = 1
	if Input.is_action_pressed("ui_up"):
		direction.y = -1
	if Input.is_action_pressed("ui_down"):
		direction.y = 1
	if Input.is_action_pressed("SpeedUp"):
		var tween = create_tween()
		tween.tween_property($Sprite2D,"scale", Vector2(0.13,0.07), 0.05 )
		tween.tween_property($Sprite2D,"scale", Vector2(0.1,0.1), 0.05 )
		speed_up = 1.5
		
	if Input.is_action_just_pressed("Dash"):
		$AnimationPlayer.play("1")
		speed_up = 10
		
	direction = direction.normalized()    
	velocity =  direction * speed * speed_up
	
	

func _physics_process(delta):
	speed_up = 1
	if(move_by_key):
		get_input()
		
	else:
		if(Input.is_action_pressed("SpeedUp")):
			speed_up = 2
		var player_direction = (get_global_mouse_position() - position)
		direction = player_direction.normalized()
		velocity = direction * speed * delta * 100 * speed_up
		
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


func _on_hit_box_body_entered(body):
	if body.is_in_group("Walls"):
		Life.life -= 1
		Life.update_life()

		if(Life.life <= 0): 
			died.emit()
			queue_free()
			EndMenu.visible = true
			return

func _on_hex_spawner_timeout():
	pass # Replace with function body.
