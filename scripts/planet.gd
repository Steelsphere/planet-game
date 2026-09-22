extends MeshInstance3D

var main_temp_buffer = true

@onready var temperature: SubViewport = $Temperature
@onready var temperature_2: SubViewport = $Temperature2

func _physics_process(delta: float) -> void:
	#rotate_y(delta * 0.1)
	pass
	
func _process(delta: float) -> void:
	if main_temp_buffer:
		temperature.render_target_update_mode = SubViewport.UPDATE_ONCE
		main_temp_buffer = false
	else:
		temperature_2.render_target_update_mode = SubViewport.UPDATE_ONCE
		main_temp_buffer = true
