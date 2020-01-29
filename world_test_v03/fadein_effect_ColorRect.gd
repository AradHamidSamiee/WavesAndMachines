extends ColorRect

signal fadein_finished

func fade_in():
	get_node("AnimationPlayer").play("fade_in")

func fade_out():
	get_node("AnimationPlayer").play("fade_out")

func fade_back():
	get_node("AnimationPlayer").play_backwards("fade_in")

func _ready():
	pass

func _on_AnimationPlayer_animation_finished(anime_name):
	emit_signal("fadein_finished")
