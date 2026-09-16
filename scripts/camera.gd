extends Camera3D

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.is_action_pressed("Rotate Camera"):
			var camera_holder = get_parent() as Node3D
			
			camera_holder.rotation_degrees.y = camera_holder.rotation_degrees.y - event.screen_relative.x * 0.25
			camera_holder.rotation_degrees.z = clamp(camera_holder.rotation_degrees.z + event.screen_relative.y * 0.25, -90, 90)
			
	
