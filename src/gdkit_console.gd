extends Node

@export var input_text_edit: TextEdit
@export var output_text_edit: TextEdit

var console_history: Array[String] = []
var function_registry: Dictionary = {}

func _ready() -> void:
	input_text_edit.connect("gui_input", _on_input)

func cls() -> void:
	output_text_edit.text = ""
	
# Print the contents of the function registry
func print_fnc_reg() -> void:
	if function_registry.size() == 0:
		print("Function registry is empty.")
		return

	print("Function Registry:")
	for name in function_registry.keys():
		print("Function " + name + "\n")

# Input handling
func _on_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		_handle_key_event(event)

# Key event processing
func _handle_key_event(event: InputEventKey) -> void:
	match event.keycode:
		KEY_UP:
			_navigate_history()
		KEY_ENTER:
			if event is InputEventWithModifiers and not event.shift_pressed:
				_process_input(input_text_edit.text.strip_edges())

# Navigate through command history
func _navigate_history() -> void:
	if console_history.size() > 0:
		input_text_edit.text = console_history[0]
	output_text_edit.scroll_vertical = 0

# Process and execute the entered command
func _process_input(command_text: String) -> void:
	console_history.push_front(command_text)
	output_text_edit.text += "> " + command_text + "\n"
	
	var parts = command_text.split(" ", true, 2)
	var function_name = parts[0]
	var arguments = ""
	if parts.size() > 1:
		arguments = parts[1]

	if function_name == "cls":
		cls()
	elif function_name == "print_fnc_reg":
		print_fnc_reg()
	elif function_registry.has(function_name):
		_call_registered_function(function_name, arguments)
	else:
		_output_text_edit("Unknown command: " + function_name)

	input_text_edit.text = ""
	output_text_edit.scroll_vertical = INF

# Call a registered function
func _call_registered_function(function_name: String, arguments: String) -> void:
	if function_registry.has(function_name):
		var callable = function_registry[function_name]
		
		callable.call()

# Register a function with debug output
func register_function(name: String, object: Object, method_name: String) -> void:
	function_registry[name] = Callable(object, method_name)

# Unregister a function
func unregister_function(name: String) -> void:
	function_registry.erase(name)

# Output text with proper handling
func _output_text_edit(text: Variant) -> void:
	if text != null:
		output_text_edit.text += str(text) + "\n"
	else:
		output_text_edit.text += "Function call returned null.\n"
