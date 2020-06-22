extends Node


func _enter_tree():
	var keyboard_scene = preload("res://addons/godot-virtual-keyboard/Keyboard.tscn").instance()
	add_child(keyboard_scene)
	keyboard_scene.owner = self
