extends Control

var waiting_menu = Timer.new()
var fadein_correction = 0
var button_correction = 0
var charbtncorrection = 0
var immediate_caseopening_to_buttoncontroller_corrector = 0
var immediate_buttoncontroller_to_charselection_corrector = 0
var immediate_case_to_open_func_intruption_corrector = 0

var time_killer = 0
var logo_popup_done = 0

func _ready():
	get_node("position_handler/AnimatedSprite/sprite_to_hold_buttons").visible = false
	get_node("position_handler/AnimatedSprite/sprite_to_hold_chars").visible = false
	
	# logos to appear and disappear
	$position_handler.visible = false
	$about_RichTextLabel.visible = false
	waiting_menu.set_wait_time(2)
	waiting_menu.set_one_shot(true)
	self.add_child(waiting_menu)
	waiting_menu.start()
	yield(waiting_menu, "timeout")
	meta_vision_logo_popup()
	waiting_menu.set_wait_time(7)
	waiting_menu.set_one_shot(true)
	self.add_child(waiting_menu)
	waiting_menu.start()
	yield(waiting_menu, "timeout")
	$position_handler.visible = true
	$about_RichTextLabel.visible = true
	
	case_idle()

func _process(delta):
	if logo_popup_done == 1:
		case_to_open()
		button_controller()
		character_selection_controller()

func button_controller():
	if immediate_caseopening_to_buttoncontroller_corrector == 1 and immediate_buttoncontroller_to_charselection_corrector == 0:
		# positioning the selector
		if Input.is_action_just_released("ui_down") and button_correction >= 0 and button_correction < 2:
			button_correction += 1
			$position_handler/AnimatedSprite/sprite_to_hold_buttons/button_select_controller.position.y += 40
		if Input.is_action_just_released("ui_up") and button_correction > 0 and button_correction <= 2:
			$position_handler/AnimatedSprite/sprite_to_hold_buttons/button_select_controller.position.y -= 40
			button_correction -= 1
		# functioning selector
		if Input.is_action_pressed("confirm") and button_correction == 0:
			waiting_menu.start()
			yield(waiting_menu, "timeout")
			immediate_buttoncontroller_to_charselection_corrector = 1
			_on_NewGame_pressed()
		if Input.is_action_pressed("confirm") and button_correction == 1:
			_on_Load_pressed()
		if Input.is_action_pressed("confirm") and button_correction == 2:
			immediate_case_to_open_func_intruption_corrector = 1
			_on_Close_pressed()

func character_selection_controller():
	if immediate_buttoncontroller_to_charselection_corrector == 1:
		# indxing
		if Input.is_action_just_released("ui_down") and charbtncorrection >= 0 and charbtncorrection < 2:
			charbtncorrection += 1
		if Input.is_action_just_released("ui_up") and charbtncorrection > 0 and charbtncorrection <= 2:
			charbtncorrection -= 1
		# positioning
		if charbtncorrection == 1:
			$position_handler/AnimatedSprite/sprite_to_hold_chars/char_select_controller.position.x = 100
			$position_handler/AnimatedSprite/sprite_to_hold_chars/char_select_controller.position.y = 30
		if charbtncorrection == 2:
			$position_handler/AnimatedSprite/sprite_to_hold_chars/char_select_controller.position.x = 55
			$position_handler/AnimatedSprite/sprite_to_hold_chars/char_select_controller.position.y = 155
		if charbtncorrection == 0:
			$position_handler/AnimatedSprite/sprite_to_hold_chars/char_select_controller.position.x = 120
			$position_handler/AnimatedSprite/sprite_to_hold_chars/char_select_controller.position.y = -110
		# functioning selector
		if Input.is_action_pressed("confirm") and charbtncorrection == 0:
			_on_hero_pressed()
		if Input.is_action_pressed("confirm") and charbtncorrection == 1:
			print("nothing to do yet")
		if Input.is_action_pressed("confirm") and charbtncorrection == 2:
			print("nothing to do yet")

func case_to_open():
	if immediate_case_to_open_func_intruption_corrector == 0:
		if Input.is_action_just_released("confirm"):
			get_node("position_handler/AnimatedSprite").play("opening")
			waiting_menu.set_wait_time(0.5)
			waiting_menu.set_one_shot(true)
			self.add_child(waiting_menu)
			waiting_menu.start()
			yield(waiting_menu, "timeout")
			get_node("position_handler/AnimatedSprite/sprite_to_hold_buttons").visible = true
			waiting_menu.start()
			yield(waiting_menu, "timeout")
			immediate_caseopening_to_buttoncontroller_corrector = 1

func case_idle():
	get_node("position_handler/AnimatedSprite").play("start")

func meta_vision_logo_popup():
	get_node("metavision_effect").show()
	get_node("metavision_effect/AnimationPlayer").play("fadein_and_out")
	waiting_menu.set_wait_time(6)
	waiting_menu.set_one_shot(true)
	self.add_child(waiting_menu)
	waiting_menu.start()
	yield(waiting_menu, "timeout")
	logo_popup_done = 1

func _on_Close_pressed():
	get_node("position_handler/AnimatedSprite/sprite_to_hold_buttons").visible = false
	get_node("position_handler/AnimatedSprite").play("closing")
	waiting_menu.set_wait_time(0.5)
	waiting_menu.set_one_shot(true)
	self.add_child(waiting_menu)
	waiting_menu.start()
	yield(waiting_menu, "timeout")
	get_node("fadein_effect_ColorRect").show()
	get_node("fadein_effect_ColorRect").fade_in()
	get_tree().quit()

func _on_NewGame_pressed():
	get_node("position_handler/AnimatedSprite/sprite_to_hold_buttons").visible = false
	get_node("position_handler/AnimatedSprite").play("charselection")
	get_node("position_handler/AnimatedSprite/sprite_to_hold_chars").visible = true

func _on_hero_pressed():
	fadein_correction = 1
	get_node("fadein_effect_ColorRect").show()
	get_node("fadein_effect_ColorRect").fade_in()

func _on_fadein_effect_ColorRect_fadein_finished():
	if fadein_correction == 1:
		get_tree().change_scene('res://world_test_v03/dreaming_test.tscn')

func _on_Load_pressed():
	pass # Replace with function body.

func _on_metavision_effect_metavision_effect_finished():
	pass # Replace with function body.
