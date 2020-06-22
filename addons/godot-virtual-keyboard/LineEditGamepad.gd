extends LineEdit

var is_using_gamepad = false
var keyboard_stopped = false
var keyboard_started = false

export(NodePath) var keyboard_path

onready var keyboard = get_node(keyboard_path)

func _on_KeyBoard_key_pressed(k):
	append_at_cursor(k)
	
func connect_to_keyboard():
	if keyboard and keyboard.connected_control != self:
		keyboard.connected_control = self
		keyboard.connect("key_pressed", self, "_on_KeyBoard_key_pressed")
		keyboard.connect("validated", self, "_on_KeyBoard_validated")
		keyboard.connect("left", self, "_on_KeyBoard_left")
		keyboard.connect("right", self, "_on_KeyBoard_right")
		keyboard.connect("back", self, "_on_KeyBoard_back")
		keyboard.connect("accidental_focus", self, "_on_KeyBoard_accidental_focus")
		keyboard.connect("disconnected", self, "_on_KeyBoard_disconnected")
		
func disconnect_keyboard():
	if keyboard and keyboard.connected_control == self:
		keyboard.connected_control == null
		keyboard.disconnect("key_pressed", self, "_on_KeyBoard_key_pressed")
		keyboard.disconnect("validated", self, "_on_KeyBoard_validated")
		keyboard.disconnect("left", self, "_on_KeyBoard_left")
		keyboard.disconnect("right", self, "_on_KeyBoard_right")
		keyboard.disconnect("back", self, "_on_KeyBoard_back")
		keyboard.disconnect("accidental_focus", self, "_on_KeyBoard_accidental_focus")
		keyboard.disconnect("disconnected", self, "_on_KeyBoard_disconnected")
		

func _on_focus_entered():
	if keyboard.connected_control != self:
		keyboard.emit_signal("disconnected")
	if keyboard_stopped:
		keyboard_stopped = false
		return
	caret_force_displayed = true
	connect_to_keyboard()
	if not is_using_gamepad :
		if keyboard.active and keyboard.connected_control == self:
			keyboard.exit()
		return
	if not (keyboard.active and keyboard.connected_control == self):
		keyboard_started = true
		release_focus()
		start_keyboard()
	else:
		stop_keyboard()
		
func _on_focus_exited():
	if keyboard_started:
		keyboard_started = false
		return
	caret_force_displayed = false
	if keyboard.connected_control == self:
		disconnect_keyboard()
		keyboard.connected_control = null
		if keyboard.active:
			stop_keyboard()
		

func start_keyboard():
	keyboard.enter()
	keyboard_stopped = false
	
func stop_keyboard():
	keyboard.exit()
	keyboard_stopped = true
	grab_focus()

func _on_KeyBoard_validated():
	stop_keyboard()
#	disconnect_keyboard()
	
func _on_KeyBoard_back():
	back()

func _on_KeyBoard_disconnected():
	if keyboard.active:
		stop_keyboard()
	disconnect_keyboard()
	keyboard.connected_control = null
	
func _on_KeyBoard_left():
	caret_position -= 1

func _on_KeyBoard_right():
	caret_position += 1

func _on_KeyBoard_accidental_focus():
	grab_focus()

func back():
	delete_char_at_cursor()

	
func _gui_input(event):
	if event is InputEventJoypadButton and event.button_index == JOY_BUTTON_0 and not keyboard.active:
		keyboard_started = true
		release_focus()
		start_keyboard()
		
func _input(event):
	is_using_gamepad = event is InputEventJoypadButton or event is InputEventJoypadMotion


