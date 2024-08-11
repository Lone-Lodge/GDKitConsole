@tool
extends EditorPlugin

var singleton_plugin_path = {
	"GDKitConsole" : "res://addons/GDKitConsole/content/console.tscn",
}
#
func _enter_tree() -> void:
	for plugin_name in singleton_plugin_path.keys():
		add_autoload_singleton(plugin_name, singleton_plugin_path[plugin_name])

func _exit_tree() -> void:
	for plugin_name in singleton_plugin_path.keys():
		remove_autoload_singleton(plugin_name)
