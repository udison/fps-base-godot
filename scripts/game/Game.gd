extends Node3D

func _input(event):
	if Input.is_action_just_released('pause'):
		get_tree().quit()
		
	if Input.is_action_just_released('toggle_screen_mode'):
		var mode = DisplayServer.window_get_mode()
		var windowed = DisplayServer.WINDOW_MODE_WINDOWED
		var fullscreen = DisplayServer.WINDOW_MODE_FULLSCREEN
		
		DisplayServer.window_set_mode(
			windowed if mode == fullscreen else fullscreen
		)
		
		if DisplayServer.window_get_mode() == windowed:
			var viewport = get_viewport()
			viewport.size = Vector2i(1280, 720)
