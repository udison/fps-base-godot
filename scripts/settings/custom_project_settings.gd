extends Node

# ===========================
# YOINKED from Rabbit:
# https://dfaction.net/handling-custom-project-settings-using-gdscript/
# ===========================

func _init() -> void:
	add_custom_project_setting(
		"custom_settings/input/stance_mode",
		"hold",
		TYPE_STRING,
		PROPERTY_HINT_ENUM,
		"hold,press"
	)

	var error: int = ProjectSettings.save()
	if error: push_error("Encountered error %d when saving project settings." % error)


func add_custom_project_setting(name: String, default_value, type: int, hint: int = PROPERTY_HINT_NONE, hint_string: String = "") -> void:
	if ProjectSettings.has_setting(name): return

	var setting_info: Dictionary = {
		"name": name,
		"type": type,
		"hint": hint,
		"hint_string": hint_string
	}

	ProjectSettings.set_setting(name, default_value)
	ProjectSettings.add_property_info(setting_info)
	ProjectSettings.set_initial_value(name, default_value)
