@tool
extends EditorPlugin

# Default key settings
const DEFAULT_CONSOLE_KEY_1 : int = KEY_F12
const DEFAULT_CONSOLE_KEY_2 : int = -1  # -1 indicates no secondary key by default

func _enter_tree() -> void:
	_add_default_settings()

func _exit_tree() -> void:
	pass  # No cleanup needed in this case

func _add_default_settings() -> void:
	# Check if the key settings already exist
	if not ProjectSettings.has_setting("GDKitConsole/toggle_key_1"):
		# Add default key settings
		ProjectSettings.set_setting("GDKitConsole/toggle_key_1", DEFAULT_CONSOLE_KEY_1)
		ProjectSettings.set_setting("GDKitConsole/toggle_key_2", DEFAULT_CONSOLE_KEY_2)
		print("Default GDKitConsole key settings added.")

	# Optionally save settings if any changes were made
	if ProjectSettings.has_setting("GDKitConsole/toggle_key_1") and ProjectSettings.get_setting("GDKitConsole/toggle_key_1") != DEFAULT_CONSOLE_KEY_1:
		print("Existing setting found; no changes made.")
	elif ProjectSettings.has_setting("GDKitConsole/toggle_key_2") and ProjectSettings.get_setting("GDKitConsole/toggle_key_2") != DEFAULT_CONSOLE_KEY_2:
		print("Existing setting found; no changes made.")
	else:
		ProjectSettings.save()
