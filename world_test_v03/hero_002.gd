extends KinematicBody2D

export (int) var walk_speed = 150

var movement_direction = Vector2(0,0)
var sprite_direction = "idle"
var behind_direction_correction = 0 # to reduce direction animation issues

# main function
func _physics_process(delta):
	controler_loop()
	movement_loop()
	sprite_direction_lopp()

func controler_loop():
	var go_right = Input.is_action_pressed("ui_right")
	var go_up    = Input.is_action_pressed("ui_up")
	var go_left  = Input.is_action_pressed("ui_left")
	var go_down  = Input.is_action_pressed("ui_down")
	
	movement_direction.x = -int(go_left) + int(go_right) #no key will be prior while holding simoltaneously
	movement_direction.y = -int(go_up) + int(go_down)

func movement_loop():
	var motion = movement_direction.normalized() * walk_speed
	move_and_slide(motion, Vector2(0,0))

func sprite_direction_lopp():
	match movement_direction:
		Vector2(-1,0):
			sprite_direction = "left"
			get_node("AnimatedSprite").flip_h = true
			get_node("AnimatedSprite").play("anim_hero_walk_front")
			behind_direction_correction = 0
		Vector2(1,0):
			sprite_direction = "right"
			get_node("AnimatedSprite").flip_h = false
			get_node("AnimatedSprite").play("anim_hero_walk_front")
			behind_direction_correction = 0
		Vector2(0,-1):
			sprite_direction = "up"
			get_node("AnimatedSprite").play("anim_hero_walk_behind")
			behind_direction_correction = 1
		Vector2(0,1):
			sprite_direction = "down"
			get_node("AnimatedSprite").play("anim_hero_walk_front")
			behind_direction_correction = 0
		Vector2(1,-1):
			sprite_direction = "top-right"
			get_node("AnimatedSprite").flip_h = false
			get_node("AnimatedSprite").play("anim_hero_walk_behind")
			behind_direction_correction = 1
		Vector2(-1,-1):
			sprite_direction = "top-left"
			get_node("AnimatedSprite").flip_h = true
			get_node("AnimatedSprite").play("anim_hero_walk_behind")
			behind_direction_correction = 1
		Vector2(1,1):
			sprite_direction = "down-right"
			get_node("AnimatedSprite").flip_h = false
			get_node("AnimatedSprite").play("anim_hero_walk_front")
			behind_direction_correction = 0
		Vector2(-1,1):
			sprite_direction = "down-left"
			get_node("AnimatedSprite").flip_h = true
			get_node("AnimatedSprite").play("anim_hero_walk_front")
			behind_direction_correction = 0
		Vector2(0,0):
			if behind_direction_correction == 0:
				sprite_direction = "idle"
				get_node("AnimatedSprite").play("anim_hero_idle_front")
			elif behind_direction_correction == 1:
				sprite_direction = "idle"
				get_node("AnimatedSprite").play("anim_hero_idle_behind")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
