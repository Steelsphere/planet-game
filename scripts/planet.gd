extends MeshInstance3D

var main_temp_buffer = true

@onready var temperature: SubViewport = $Temperature
@onready var temperature_2: SubViewport = $Temperature2

func _physics_process(delta: float) -> void:
	rotate_y(delta * 0.1)
	
	if main_temp_buffer:
		temperature.render_target_update_mode = SubViewport.UPDATE_ONCE
		main_temp_buffer = false
	else:
		temperature_2.render_target_update_mode = SubViewport.UPDATE_ONCE
		main_temp_buffer = true
		
	var sun_dir = transform.basis * Vector3(0.0, 0.0, 1.0)
	var temp_map = temperature.get_child(0) as ColorRect
	var temp_map_mat = temp_map.material as ShaderMaterial
	temp_map_mat.set_shader_parameter("sun_dir", sun_dir)
