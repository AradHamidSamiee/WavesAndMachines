extends Label

func _process(delta):
	fps()

func fps():
	set_text(str("FPS: ", Performance.get_monitor(Performance.TIME_FPS)))
