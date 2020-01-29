extends Control

class_name DialogueBox

signal dialogue_ended

onready var dialogue_player : DialoguePlayer = get_node("DialoguePlayer")

onready var name_label : = get_node("Panel/HBoxContainer/Name") as Label
onready var text_label : = get_node("Panel/HBoxContainer/Text") as Label
onready var button_next : = get_node("Panel/HBoxContainer/ButtonNext") as Button
onready var button_end : = get_node("Panel/HBoxContainer/ButtonEnd") as Button

func update_content() -> void:
	var dialogue_player_name = dialogue_player.title
	name_label.text = dialogue_player_name
	text_label.text = dialogue_player.text

func start(dialogue : Dictionary) -> void:
	button_next.hide()
	button_end.show()
	button_next.grab_focus()
	dialogue_player.start(dialogue)
	update_content()
	show()

func _on_ButtonNext_pressed():
	dialogue_player.next()
	update_content()

func _on_ButtonEnd_pressed():
	emit_signal("dialogue_ended")
	hide()

func _on_DialoguePlayer_finished():
	button_next.hide()
	button_end.grab_focus()
	button_end.show()
