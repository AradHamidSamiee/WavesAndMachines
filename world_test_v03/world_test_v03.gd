extends Node2D

func _ready():
	get_node("hero_002/chapter_one").show()
	get_node("hero_002/chapter_one").fade_in()

func _on_chapter_one_chapterone_fadein_finished():
	pass
