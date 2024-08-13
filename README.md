<div align="center">

# `📔 GDKitConsole` <img src="https://raw.githubusercontent.com/aemmadi/aemmadi/master/wave.gif" width="30">

![GDScript](https://img.shields.io/badge/-godot-00599C?style=flat-square&logo=godot)

<b>An (unofficial) open source gdscript written plugin for dev console in Godot Engine</b>

</div>


**GDKitConsole** is a simple in-game console for the Godot Engine, designed to assist with debugging and command execution. It allows you to register functions, execute commands, and manage command history directly within the Godot editor.

## Features

- **Toggleable Console**: Show or hide the console with a configurable key.
- **Command History**: Navigate through previous commands using the up and down arrow keys.
- **Command Execution**: Execute registered functions and commands directly from the console.
- **Dynamic Function Registration**: Register and unregister functions or properties to be callable from the console.
- **Configurable Console Key**: Set the key for toggling the console through the Godot Project Settings.

## Configuration

### Setting the Console Key

1. Open **Project Settings** in the Godot editor.
2. Navigate to **General** > **Editor**.
3. Add or modify the following settings:
   - **`console/toggle_key_1`**: Set the primary key for toggling the console. (Default is `KEY_F12`)
   - **`console/toggle_key_2`**: Set an optional secondary key for toggling the console. (Default is disabled)

### Toggling the Console

- Press the configured key (e.g., `§` or any other key set in Project Settings) to show or hide the console.

## Commands

- **`cls`**: Clears the console output.
- **`print_fnc_reg`**: Prints the list of registered functions.

## Registering Functions

- Use the `register_function` method to make functions callable from the console.

	```gdscript
	console.register_function("function_name", self, "method_name")
	```

## Example Usage

Here is an example of how you might use the console in practice:

```gdscript
# In a script where you want to register functions
func _ready():
	var console = get_node("/root/GDKitConsole")
	console.register_function("print_hello", self, "print_hello")
	
func print_hello():
	print("Hello from the console!")
