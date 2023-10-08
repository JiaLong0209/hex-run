extends CharacterBody2D


const speed = 600.0
const JUMP_VELOCITY = -400.0
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction := Vector2.ZERO

func maxSum(arr, k:int):
	for i in range(arr.size()):
		arr[i] = arr.slice(i, k+i).reduce(func(acc,cur): return acc + cur, 0)
	print(arr.max())
	

func _ready():
	maxSum([3,5,3,1,1,5,9], 3)
	pass
	
func get_input():
	var isSpeedUp = 1
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
		isSpeedUp = 1.5
	if Input.is_action_just_pressed("Dash"):
		isSpeedUp = 10
		
	direction = direction.normalized()
	velocity =  direction * speed * isSpeedUp
	
	

func _physics_process(delta):
	get_input()
	move_and_slide()
	
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
			queue_free()
			EndMenu.visible = true
			return

func _on_hex_spawner_timeout():
	pass # Replace with function body.
