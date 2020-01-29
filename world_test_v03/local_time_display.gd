extends RichTextLabel

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var hour = OS.get_time()["hour"]
	var minute = OS.get_time()["minute"]
	if minute < 10:
		set_text(str(hour)+":0"+str(minute))
	elif minute >= 10:
		set_text(str(hour)+":"+str(minute))
	pass
