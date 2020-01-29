extends Sprite

signal metavision_effect_finished

func fade_in():
	get_node("AnimationPlayer").play("fadein_and_out")

func _ready():
	pass

func _on_AnimationPlayer_animation_finished(anim_name):
	emit_signal("metavision_effect_finished")
