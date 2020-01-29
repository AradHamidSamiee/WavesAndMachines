extends KinematicBody2D

export (int) var walk_speed = 150
export (int) var run_speed  = 150
var screen_size #size of game window
var idle  = 1
var front = 1
var toggle_movement_mode = 1 # 1->walk / 0->run
#var movement = Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	
	screen_size = get_viewport_rect().size
#	set_process(true)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	var velocity = Vector2() #the player's movement vector
	
	# idle and direction
	if idle == 1:
		if front == 1:
			get_node("AnimatedSprite").play("anim_hero_idle_front")
		elif front == 0:
			get_node("AnimatedSprite").play("anim_hero_idle_behind")
	
	#Right
	if Input.is_action_pressed("ui_right"):
		idle = 0
		velocity.x += 1
		get_node("AnimatedSprite").flip_h = false
		get_node("AnimatedSprite").play("anim_hero_walk_front")
	elif Input.is_action_just_released("ui_right"):
		idle = 1
		front = 1
	
	#Left
	if Input.is_action_pressed("ui_left"):
		idle = 0
		velocity.x -= 1
		get_node("AnimatedSprite").flip_h = true
		get_node("AnimatedSprite").play("anim_hero_walk_front")
	elif Input.is_action_just_released("ui_left"):
		idle = 1
		front = 1
	
	#Up
	if Input.is_action_pressed("ui_up"):
		idle = 0
		velocity.y -= 1
		get_node("AnimatedSprite").play("anim_hero_walk_behind")
	elif Input.is_action_just_released("ui_up"):
		idle = 1
		front = 0
	if Input.is_action_pressed("ui_up") and Input.is_action_pressed("ui_left"):
		idle = 0
		velocity.y -= 1
		velocity.x -= 1
		get_node("AnimatedSprite").play("anim_hero_walk_behind")
	
	#Down
	if Input.is_action_pressed("ui_down"):
		idle = 0
		velocity.y += 1
		get_node("AnimatedSprite").play("anim_hero_walk_front")
	elif Input.is_action_just_released("ui_down"):
		idle = 1
		front = 1
	
	#Speed Assignment
	if velocity.length() > 0 and toggle_movement_mode == 1:
		velocity = velocity.normalized() * run_speed
	if velocity.length() > 0 and toggle_movement_mode == 0:
		velocity = velocity.normalized() * walk_speed
	
	position += (velocity * delta)
	position.x = clamp(position.x, 0, 2000) #0,2000 means the total area of movement ability - min, Max
	position.y = clamp(position.y, 0, 2000) #0,2000 means the total area of movement ability - min, Max
	
#	if Input.is_action_pressed("ui_up"):
#		movement.y -= walk_speed * delta
#	elif Input.is_action_pressed("ui_down"):
#		movement.y += walk_speed * delta
#	elif Input.is_action_pressed("ui_left"):
#		movement.x -= walk_speed * delta
#	elif Input.is_action_pressed("ui_right"):
#		movement.x += walk_speed * delta
#	else:
#		movement.y = 0
#		movement.x = 0
#	movement = move_and_slide(movement)
	
	pass
