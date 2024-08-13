extends Node

@export var input_text_edit: TextEdit  # TextEdit node for user input
@export var output_text_edit: TextEdit  # TextEdit node for console output
@export var root_canvas_layer: CanvasLayer  # CanvasLayer node for toggling console visibility

var console_history: Array[String] = []  # Stores command history
var function_registry: Dictionary = {}  # Maps function names to Callable objects
var history_index: int = -1  # Index for navigating through command history

# Initialization function
func _ready() -> void:
	set_process_input(true)  # Enable input processing
	input_text_edit.connect("gui_input", _on_input)  # Connect input signal

# Toggle console visibility
func _toggle_console() -> void:
	root_canvas_layer.visible = not root_canvas_layer.visible
	if root_canvas_layer.visible:
		input_text_edit.grab_focus()  # Focus on the input field when the console is visible

# Clear console output
func cls() -> void:
	output_text_edit.text = ""

# Print registered functions in the console
func print_fnc_reg() -> void:
	if function_registry.size() == 0:
		_append_to_output("Function registry is empty.")
		return

	_append_to_output("Function Registry:")
	for name in function_registry.keys():
		_append_to_output("Function " + name)

# Handle input events
func _input(ev):
	if Input.is_key_pressed(KEY_F12):
		_toggle_console()  # Toggle the console when F12 is pressed

# Handle key events
func _on_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		_handle_key_event(event)

# Process key events
func _handle_key_event(event: InputEventKey) -> void:
	match event.keycode:
		KEY_UP:
			_navigate_history(-1)  # Navigate history up
		KEY_DOWN:
			_navigate_history(1)  # Navigate history down
		KEY_ENTER:
			if event is InputEventWithModifiers and not event.shift_pressed:
				_process_input(input_text_edit.text.strip_edges())  # Process command on Enter key

# Navigate through command history
func _navigate_history(direction: int) -> void:
	if console_history.size() > 0:
		history_index = clamp(history_index + direction, 0, console_history.size() - 1)
		input_text_edit.text = console_history[history_index]
		_move_caret_to_end()  # Move caret to end of the input field
		output_text_edit.scroll_vertical = 0

# Move caret to the end of the text
func _move_caret_to_end() -> void:
	var line_count = input_text_edit.get_line_count()
	if line_count > 0:
		var end_line = max(line_count - 1, 0)
		var end_column = input_text_edit.get_line(end_line).length()
		input_text_edit.set_caret_line(end_line)
		input_text_edit.set_caret_column(end_column)
	else:
		input_text_edit.set_caret_line(0)
		input_text_edit.set_caret_column(0)

# Process and execute the entered command
func _process_input(command_text: String) -> void:
	console_history.push_front(command_text)  # Add command to history
	history_index = -1  # Reset history index

	_append_to_output("> " + command_text)  # Output command to console

	var parts = command_text.split(" ", true, 2)
	var function_name = parts[0]
	var arguments = ""
	if parts.size() > 1:
		arguments = parts[1]

	match function_name:
		"cls":
			cls()  # Clear console
		"print_fnc_reg":
			print_fnc_reg()  # Print function registry
		_:
			if function_registry.has(function_name):
				_call_registered_function(function_name, arguments)  # Call registered function
			else:
				_append_to_output("Unknown command: " + function_name)  # Unknown command response

	_reset_input()  # Clear input field and scroll output to the bottom

# Call a registered function with arguments
func _call_registered_function(function_name: String, arguments: String) -> void:
	if function_registry.has(function_name):
		var callable = function_registry[function_name]
		var result = null

		if arguments != "":
			var args = arguments.split(" ")
			var parsed_args = _parse_arguments(args)
			print("Calling function:", function_name, ", with arguments:", parsed_args)
			result = callable.callv(parsed_args)
		else:
			print("Calling function:", function_name, ", with no arguments")
			result = callable.call()

		if result != null:
			_append_to_output(str(result))  # Output result to console
	else:
		_append_to_output("Function not found: " + function_name)  # Function not found response

# Parse arguments to convert them to the appropriate types
func _parse_arguments(args: Array) -> Array:
	var parsed_args = []
	for arg in args:
		if arg.is_valid_float():
			parsed_args.append(arg.to_float())
		elif arg.is_valid_int():
			parsed_args.append(arg.to_int())
		else:
			parsed_args.append(arg)
	return parsed_args

# Register a function or property for the console
func register_function(name: String, object: Object, method_name: String) -> void:
	if object.has_method(method_name):
		function_registry[name] = Callable(object, method_name)
	elif object.has_property(method_name):
		function_registry[name] = Callable(object, "get_" + method_name)
	else:
		print("Method or property not found: " + method_name)  # Method/property not found response

# Unregister a function
func unregister_function(name: String) -> void:
	function_registry.erase(name)  # Remove function from registry

# Append text to the console output
func _append_to_output(text: String) -> void:
	output_text_edit.text += text + "\n"  # Append text to output
	output_text_edit.scroll_vertical = INF  # Scroll to bottom

# Reset the input field and scroll output
func _reset_input() -> void:
	input_text_edit.text = ""  # Clear input field
	output_text_edit.scroll_vertical = INF  # Scroll output to bottom
