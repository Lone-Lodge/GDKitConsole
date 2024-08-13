@tool
extends EditorPlugin

# Default key settings
const DEFAULT_CONSOLE_KEY_1 : int = KEY_F12
const DEFAULT_CONSOLE_KEY_2 : int = -1  # -1 indicates no secondary key by default

func _enter_tree() -> void:
	if not Engine.is_editor_hint():
		# The plugin is not running in the editor; no need to proceed
		return
	
	_add_default_settings()
	_add_autoload_if_needed()

func _exit_tree() -> void:
	pass  # No cleanup needed in this case

func _add_default_settings() -> void:
	# Check if the key settings already exist
	if not ProjectSettings.has_setting("GDKitConsole/toggle_key_1"):
		# Add default key settings
		ProjectSettings.set_setting("GDKitConsole/toggle_key_1", DEFAULT_CONSOLE_KEY_1)
		ProjectSettings.set_setting("GDKitConsole/toggle_key_2", DEFAULT_CONSOLE_KEY_2)
		print("Default GDKitConsole key settings added.")

	# Save settings if any changes were made
	ProjectSettings.save()

func _add_autoload_if_needed() -> void:
	if not Engine.is_editor_hint():
		return

	var autoload_name = "GDKitConsole"
	var autoload_path = "res://addons/GDKitConsole/content/console.gd"  # Adjust the path to your autoload script or scene

	# Load current autoload settings
	var autoloads = ProjectSettings.get_setting("autoloads")
	
	# Check if the autoload is already present
	if not autoloads.has(autoload_name):
		# Add autoload entry
		autoloads[autoload_name] = autoload_path
		ProjectSettings.set_setting("autoloads", autoloads)
		print("Autoload entry for GDKitConsole added.")

	# Save settings to persist changes
	ProjectSettings.save()
