extends Spatial

export (float) var min_step_size = 50.0

func _process(delta):
	# find the current camera
	var cam_pos = get_viewport().get_camera().global_transform.origin
	var rounded_pos = cam_pos - Vector3(
		fmod(cam_pos.x, min_step_size),
		fmod(cam_pos.y, min_step_size),
		fmod(cam_pos.z, min_step_size)
	)
	
	#global_transform.origin = rounded_pos
	#global_transform.origin.y = 0
