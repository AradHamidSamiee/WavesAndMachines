extends Node2D

var waiting = Timer.new()

var camera_scale_down_correction = 0

func _ready():
	$hero_002/ColorRect/AnimationPlayer.play("fade_out")
	$hero_002.is_dreaming = 1

func _process(delta):
	camera_scale_in_this_map()

func camera_scale_in_this_map():
	if Input.is_action_just_released("confirm"):
		$hero_002.walk_speed += 500
	if get_node("hero_002/AnimatedSprite").global_position.x > 6500 and get_node("hero_002").movement_direction.x == 1:
		if get_node("hero_002/Camera2D").zoom.x <= 2.2:
			get_node("hero_002/Camera2D").zoom.x += 0.001
			get_node("hero_002/Camera2D").zoom.y += 0.001
		if get_node("hero_002/Camera2D/view_ratio").scale.x <= 100:
			get_node("hero_002/Camera2D/view_ratio").scale.x += 0.1
			get_node("hero_002/Camera2D/view_ratio").scale.y += 0.1
		
	if get_node("hero_002/AnimatedSprite").global_position.x < 12500 and get_node("hero_002").movement_direction.x == -1:
		if get_node("hero_002/Camera2D").zoom.x >= 1:
			get_node("hero_002/Camera2D").zoom.x -= 0.001
			get_node("hero_002/Camera2D").zoom.y -= 0.001
		if get_node("hero_002/Camera2D/view_ratio").scale.x >= 1.7:
			get_node("hero_002/Camera2D/view_ratio").scale.x -= 0.1
			get_node("hero_002/Camera2D/view_ratio").scale.y -= 0.1