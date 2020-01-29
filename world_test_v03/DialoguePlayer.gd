extends Node

class_name DialoguePlayer

signal finished

var title : String = ""
var text  : String = ""

var converation_array : Array
var index_current : int = 0

func start(dialogue_dict):
	converation_array = dialogue_dict.values()
	index_current = 0
	update_DialoguePlayer()

func next():
	index_current += 1
	assert index_current <= converation_array.size()
	update_DialoguePlayer()

func update_DialoguePlayer():
	text = converation_array[index_current].text
	title = converation_array[index_current].name
	if index_current == converation_array.size() - 1:
		emit_signal("finished")