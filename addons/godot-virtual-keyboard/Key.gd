tool
extends Button

signal key_pressed(k)

export(String) var character = "" setget set_character

func _on_Key_pressed():
	emit_signal("key_pressed", character)

func set_character(k):
	character = k.substr(0, 1)
	text = character


func _on_Key_renamed():
	if Engine.is_editor_hint:
		set_character(name)

