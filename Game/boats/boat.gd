tool
extends RigidBody

var sails = []
var booms = []
var hull = null

var sails_mats = []

var init = false

func _ready():
	print("INITING")
	sails = get_children_in_group(self, "sails")
	booms = get_children_in_group(self, "boom")
	hull = get_children_in_group(self, "hull")[0]

	for sail in sails:
		var new_mat = sail.mesh.surface_get_material(0).duplicate()
		sails_mats.append(new_mat)
		sail.mesh.surface_set_material(0, new_mat)
	init = true


func _process(delta):
	if not init:
		_ready()
	var wind_local_vec = Vector2(
		$wind.transform.basis.z.x,
		$wind.transform.basis.z.z
	)
	var wind_speed = 2.0
	var wind_local_angle = $wind.transform.basis.get_euler().y
	update_booms(wind_local_angle)
	update_sails(wind_local_angle, wind_speed)
	update_hull(wind_local_angle, wind_speed)
	
	var steer = 0.0
	if Input.is_action_pressed("ui_left"):
		steer += 1.0
	if Input.is_action_pressed("ui_right"):
		steer -= 1.0

	var x = (wind_local_angle) / PI
	x = 1.0 - abs(x)
	var thrust = sqrt(x) - 0.2*pow(x, 2.0) - 0.5*x - 0.1
	linear_velocity *= 0.98
	apply_central_impulse(-global_transform.basis.z * thrust * 0.5)
	angular_velocity.y *= 0.2
	angular_velocity.y += steer * linear_velocity.length_squared() * 0.03
	


func update_sails(angle, wind_speed):
	angle = angle + PI
	if angle > PI:
		angle -= PI*2
	var percent = angle / PI

	var flow = sign(percent) * pow(abs(percent), 0.5)
	for sail_mat in sails_mats:
		sail_mat.set_shader_param("luff",  (max(1.0 - abs(flow*2), 0) * 2 + 0.3) )
		sail_mat.set_shader_param("belly", flow * -2 * wind_speed)
		sail_mat.set_shader_param("luff_position", 
			sail_mat.get_shader_param("luff_position") - wind_speed / 500.0
		)


func update_hull(wind_angle, wind_speed):
	wind_angle = wind_angle / PI
	var hull_angle = wind_angle - pow(wind_angle, 7.0)
	hull_angle *= wind_speed * 0.3
	
	hull.transform.basis = Basis(Vector3(0, 0, 1), hull_angle)

func update_booms(wind_angle):
	# Figure out where to put the sails:
	var boom_angle = PI/2 + wind_angle / 2.0
	if boom_angle > PI/2:
		boom_angle -= PI
	boom_angle = max(min(boom_angle, PI/2), -PI/2)
	#var boom_percent = boom_angle / (PI/2)
	#boom_percent += (randf() - 0.5) * pow((1.0 - boom_percent), 4.0) * 0.05
	#boom_angle = boom_percent * (PI/2)

	for boom in booms:
		var current = boom.transform.basis.get_euler().y
		var diff = abs(current - boom_angle) * 3.0 + 1.0
		var actual = lerp(current, boom_angle, 0.2 / diff)
		boom.transform.basis = Basis(Vector3(0, 1, 0), actual)

func get_children_in_group(parent, group_name, recursive=true):
	var out_array = []
	for child in parent.get_children():
		if group_name in child.get_groups():
			out_array.append(child)
		if recursive:
			out_array += get_children_in_group(child, group_name, recursive)
	return out_array