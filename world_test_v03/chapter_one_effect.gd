extends Sprite

signal chapterone_fadein_finished

func fade_in():
	get_node("AnimationPlayer").play("chapter_fadein")

func _ready():
	pass

func _on_AnimationPlayer_animation_finished(anim_name):
	emit_signal("chapterone_fadein_finished")
