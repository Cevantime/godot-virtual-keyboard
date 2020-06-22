extends CanvasLayer

signal key_pressed(k)
signal validated
signal back
signal left
signal right
signal accidental_focus
signal disconnected

onready var keyboard_container = $Panel/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer

var active = false
var connected_control = null

func _ready():
	for k in get_tree().get_nodes_in_group("keyboard_key"):
		k.connect("key_pressed", self, "_on_key_pressed")
	for k in get_tree().get_nodes_in_group("keyboard_action"):
		k.focus_mode = Control.FOCUS_NONE
		k.connect("focus_entered", self, "_on_key_focus_entered", [k])
		k.connect("gui_input", self, "_on_gui_input")
	
func _on_key_pressed(k):
	emit_signal("key_pressed", k)


func _on_Enter_pressed():
	emit_signal("validated")
	
func enter():
	for k in get_tree().get_nodes_in_group("keyboard_action"):
		k.focus_mode = Control.FOCUS_ALL
	$AnimationPlayer.play("enter")
	active = true
	keyboard_container.get_child(0).grab_focus()
	
func exit():
	for k in get_tree().get_nodes_in_group("keyboard_action"):
		k.focus_mode = Control.FOCUS_NONE
	$AnimationPlayer.play_backwards("enter")
	active = false


func _on_right():
	emit_signal("right")
	
func _on_left():
	emit_signal("left")
	
func _on_back():
	emit_signal("back")


func _on_Left_pressed():
	_on_left()


func _on_Right_pressed():
	_on_right()


func _on_Shift_pressed():
	pass # Replace with function body.


func _on_Del_pressed():
	_on_back()
	
func _on_gui_input(event):
	if event.is_pressed() and event is InputEventJoypadButton:
		match event.button_index:
			JOY_R:
				emit_signal("right")
			JOY_L:
				emit_signal("left")
			JOY_BUTTON_1:
				emit_signal("back")
			JOY_BUTTON_2:
				emit_signal("validated")
			JOY_BUTTON_3:
				emit_signal("key_pressed", " ")
	


func _on_key_focus_entered(_k):
	if not active:
		emit_signal("accidental_focus")
	
	
