extends KinematicBody2D

export (int) var walk_speed = 150

var movement_direction = Vector2(0,0)
var sprite_direction = "idle"
var behind_direction_correction = 0 # to reduce direction-based movement animation issues
var ui_SmartphonePanel_popup = 0
var ui_ThoughtsPanel_popup = 0

var smartphone_off_screen = load("res://world_test_v03/assets/props/smartphone/smartphone_off.png")
var smartphone_on_screen = preload("res://world_test_v03/assets/props/smartphone/smartphone_on.png")

var waiting = Timer.new()

var lantern_is_on = 0
var srtphn_i_positioner = 0 #horizontal
var srtphn_j_positioner = 0 #vertical
var texter_menu_is_on_display = 0
var texter_menu_selector = 0

var is_dreaming = 0
var is_at_home  = 0
var is_in_town  = 0
var is_in_corridor = 0

var first_time_dreaming = 1
var dialogue_finished = 0

# main function
func _physics_process(delta):
	controler_loop()
	movement_loop()
	sprite_direction_lopp()
	smartphone_panel_loop()
	thoughts_panel()
	exitgame()
	fast_travel()
	lantern_on()
	smartphone_input_navigation()
	smartphone_messagelist_navigation()
	dialogue_handler()

func dialogue_handler():
	if is_dreaming == 1 and first_time_dreaming == 1:
		$CL/DialogueBox.visible = true
		dream_sequence()
#		first_time_dreaming = 0
	if dialogue_finished == 1:
		$CL/DialogueBox.visible = false

func dream_sequence():
	var count_down_reverse = 0
	get_node("CL/DialogueBox/Panel/Name").text = "Hero:"
	get_node("CL/DialogueBox/Panel/Text").text = "wha.. what is this place?"
	if Input.is_action_just_released("next_dialogue") and count_down_reverse == 0:
		print("done")
		get_node("CL/DialogueBox/Panel/Name").text = "Echo:"
		get_node("CL/DialogueBox/Panel/Text").text = "it is whatever you want it to be"
		count_down_reverse += 1
	if Input.is_action_just_released("next_dialogue") and count_down_reverse == 1:
		dialogue_finished = 1

func smartphone_messagelist_navigation():
	pass

func smartphone_input_navigation():
	# indexing
	if Input.is_action_pressed("ui_down") and srtphn_i_positioner < 1 and srtphn_i_positioner >= 0:
		srtphn_i_positioner += 1
	if Input.is_action_pressed("ui_up") and srtphn_i_positioner <= 1 and srtphn_i_positioner > 0:
		srtphn_i_positioner -= 1
	if Input.is_action_pressed("ui_right") and srtphn_j_positioner < 1 and srtphn_j_positioner >= 0:
		srtphn_j_positioner += 1
	if Input.is_action_pressed("ui_left") and srtphn_j_positioner <= 1 and srtphn_j_positioner > 0:
		srtphn_j_positioner -= 1
	# placing
	if srtphn_i_positioner == 0 and srtphn_j_positioner == 0:
		$CL/UI_SmartphonePanel/calculator_selected.visible = true
		$CL/UI_SmartphonePanel/date_selected.visible = false
		$CL/UI_SmartphonePanel/musica_selected.visible = false
		$CL/UI_SmartphonePanel/texter_selected.visible = false
		if Input.is_action_just_released("confirm"):
			_on_calculator_pressed()
	if srtphn_i_positioner == 0 and srtphn_j_positioner == 1:
		$CL/UI_SmartphonePanel/date_selected.visible = true
		$CL/UI_SmartphonePanel/musica_selected.visible = false
		$CL/UI_SmartphonePanel/texter_selected.visible = false
		$CL/UI_SmartphonePanel/calculator_selected.visible = false
		if Input.is_action_just_released("confirm"):
			_on_date_pressed()
	if srtphn_i_positioner == 1 and srtphn_j_positioner == 0:
		$CL/UI_SmartphonePanel/musica_selected.visible = true
		$CL/UI_SmartphonePanel/date_selected.visible = false
		$CL/UI_SmartphonePanel/texter_selected.visible = false
		$CL/UI_SmartphonePanel/calculator_selected.visible = false
		if Input.is_action_just_released("confirm"):
			_on_musica_pressed()
	if srtphn_i_positioner == 1 and srtphn_j_positioner == 1:
		$CL/UI_SmartphonePanel/texter_selected.visible = true
		$CL/UI_SmartphonePanel/date_selected.visible = false
		$CL/UI_SmartphonePanel/musica_selected.visible = false
		$CL/UI_SmartphonePanel/calculator_selected.visible = false
		if Input.is_action_just_released("confirm"):
			_on_texter_pressed()

func lantern_on():
	if Input.is_action_just_released("lantern") and lantern_is_on == 0:
		get_node("lantern").visible = true
		lantern_is_on = 1
	elif Input.is_action_just_released("lantern") and lantern_is_on == 1:
		get_node("lantern").visible = false
		lantern_is_on = 0

func fast_travel():
	if Input.is_action_just_released("n1"):
		get_tree().reload_current_scene()
	elif Input.is_action_just_released("n2"):
		get_tree().change_scene('res://world_test_v03/world_test_v03.tscn')
	elif Input.is_action_just_released("n3"):
		get_tree().change_scene('res://world_test_v03/dreaming_test.tscn')

func exitgame():
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()

func thoughts_panel():
	if Input.is_action_just_released("ui_thoughtspanel") and ui_ThoughtsPanel_popup == 0:
		get_node("UI_ThoughtsPanel").visible = true
		ui_ThoughtsPanel_popup = 1
	elif Input.is_action_just_released("ui_thoughtspanel") and ui_ThoughtsPanel_popup == 1:
		get_node("UI_ThoughtsPanel").visible = false
		ui_ThoughtsPanel_popup = 0

func smartphone_panel_loop():
	if Input.is_action_just_released("ui_smartphonepanel") and ui_SmartphonePanel_popup == 0:
		get_node("CL/UI_SmartphonePanel").visible = true
		
		waiting.set_wait_time(0.1)
		waiting.set_one_shot(true)
		self.add_child(waiting)
		waiting.start()
		yield(waiting, "timeout")
		get_node("CL/UI_SmartphonePanel/AnimatedSprite_Smartphone").play("smartphone_turningon")
		get_node("CL/UI_SmartphonePanel/local_time_display").visible = true
		
		waiting.start()
		yield(waiting, "timeout")
		get_node("CL/UI_SmartphonePanel/calculator").visible = true
		waiting.start()
		yield(waiting, "timeout")
		get_node("CL/UI_SmartphonePanel/date").visible = true
		waiting.start()
		yield(waiting, "timeout")
		get_node("CL/UI_SmartphonePanel/musica").visible = true
		waiting.start()
		yield(waiting, "timeout")
		get_node("CL/UI_SmartphonePanel/texter").visible = true
		ui_SmartphonePanel_popup = 1
		
	elif Input.is_action_just_released("ui_smartphonepanel") and ui_SmartphonePanel_popup == 1:
		get_node("CL/UI_SmartphonePanel/AnimatedSprite_Smartphone").play("smartphone_turningoff")
		
		waiting.set_wait_time(0.05)
		waiting.set_one_shot(true)
		waiting.start()
		yield(waiting, "timeout")
		get_node("CL/UI_SmartphonePanel/calculator").visible = false
		get_node("CL/UI_SmartphonePanel/date").visible = false
		get_node("CL/UI_SmartphonePanel/musica").visible = false
		get_node("CL/UI_SmartphonePanel/texter").visible = false
		get_node("CL/UI_SmartphonePanel/local_time_display").visible = false
		
		waiting.set_wait_time(0.05)
		waiting.set_one_shot(true)
		waiting.start()
		yield(waiting, "timeout")
		get_node("CL/UI_SmartphonePanel").visible = false
		ui_SmartphonePanel_popup = 0

func controler_loop():
	var go_right = Input.is_action_pressed("move_right")
	var go_up    = Input.is_action_pressed("move_up")
	var go_left  = Input.is_action_pressed("move_left")
	var go_down  = Input.is_action_pressed("move_down")
	
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
			# setting directions for lantern
			get_node("lantern").position.x = -100
			get_node("lantern").position.y = 0
			get_node("lantern").rotation_degrees = 270
		Vector2(1,0):
			sprite_direction = "right"
			get_node("AnimatedSprite").flip_h = false
			get_node("AnimatedSprite").play("anim_hero_walk_front")
			behind_direction_correction = 0
			# setting directions for lantern
			get_node("lantern").position.x = 100
			get_node("lantern").position.y = 0
			get_node("lantern").rotation_degrees = 90
		Vector2(0,-1):
			sprite_direction = "up"
			get_node("AnimatedSprite").play("anim_hero_walk_behind")
			behind_direction_correction = 1
			# setting directions for lantern
			get_node("lantern").position.x = 0
			get_node("lantern").position.y = -100
			get_node("lantern").rotation_degrees = 0
		Vector2(0,1):
			sprite_direction = "down"
			get_node("AnimatedSprite").play("anim_hero_walk_front")
			behind_direction_correction = 0
			# setting directions for lantern
			get_node("lantern").position.x = 0
			get_node("lantern").position.y = 100
			get_node("lantern").rotation_degrees = 180
		Vector2(1,-1):
			sprite_direction = "top-right"
			get_node("AnimatedSprite").flip_h = false
			get_node("AnimatedSprite").play("anim_hero_walk_behind")
			behind_direction_correction = 1
			# setting directions for lantern
			get_node("lantern").position.x = 50
			get_node("lantern").position.y = -50
			get_node("lantern").rotation_degrees = 45
		Vector2(-1,-1):
			sprite_direction = "top-left"
			get_node("AnimatedSprite").flip_h = true
			get_node("AnimatedSprite").play("anim_hero_walk_behind")
			behind_direction_correction = 1
			# setting directions for lantern
			get_node("lantern").position.x = -50
			get_node("lantern").position.y = -50
			get_node("lantern").rotation_degrees = 315
		Vector2(1,1):
			sprite_direction = "down-right"
			get_node("AnimatedSprite").flip_h = false
			get_node("AnimatedSprite").play("anim_hero_walk_front")
			behind_direction_correction = 0
			# setting directions for lantern
			get_node("lantern").position.x = 50
			get_node("lantern").position.y = 50
			get_node("lantern").rotation_degrees = 135
		Vector2(-1,1):
			sprite_direction = "down-left"
			get_node("AnimatedSprite").flip_h = true
			get_node("AnimatedSprite").play("anim_hero_walk_front")
			behind_direction_correction = 0
			# setting directions for lantern
			get_node("lantern").position.x = -50
			get_node("lantern").position.y = 50
			get_node("lantern").rotation_degrees = 225
		Vector2(0,0):
			if behind_direction_correction == 0:
				sprite_direction = "idle"
				get_node("AnimatedSprite").play("anim_hero_idle_front")
			elif behind_direction_correction == 1:
				sprite_direction = "idle"
				get_node("AnimatedSprite").play("anim_hero_idle_behind")

func _ready():
	get_node("CL/UI_SmartphonePanel").visible = false
	get_node("CL/UI_SmartphonePanel/calculator").visible = false
	get_node("CL/UI_SmartphonePanel/date").visible = false
	get_node("CL/UI_SmartphonePanel/musica").visible = false
	get_node("CL/UI_SmartphonePanel/texter").visible = false
	get_node("CL/UI_SmartphonePanel/local_time_display").visible = false
	get_node("CL/UI_SmartphonePanel").texture = load("res://world_test_v03/assets/props/smartphone/smartphone_off.png")
	get_node("UI_ThoughtsPanel").visible = false
	get_node("CL/UI_SmartphonePanel/calculator_selected").visible = false
	get_node("CL/UI_SmartphonePanel/date_selected").visible = false
	get_node("CL/UI_SmartphonePanel/musica_selected").visible = false
	get_node("CL/UI_SmartphonePanel/texter_selected").visible = false
	get_node("CL/UI_SmartphonePanel/texter_display").visible = false
	get_node("lantern").visible = false
	get_node("CL/DialogueBox").visible = false

func _on_calculator_pressed():
	pass

func _on_date_pressed():
	pass

func _on_musica_pressed():
	pass

func _on_texter_pressed():
	if texter_menu_is_on_display == 0:
		texter_menu_is_on_display = 1
		get_node("CL/UI_SmartphonePanel/texter_display").visible = true
	elif texter_menu_is_on_display == 1:
		texter_menu_is_on_display = 0
		get_node("CL/UI_SmartphonePanel/texter_display").visible = false