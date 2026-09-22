shader_type spatial;

void fragment() {
	ALBEDO = vec3(0.3, 0.7, 1.0);
	
	float atmosphere = 1.0 - dot(NORMAL, VIEW);
	ALPHA = smoothstep(1.0, 0.5, atmosphere) * smoothstep(0.5, 0.8, atmosphere);
}

void light() {
	float light_dot = dot(NORMAL, LIGHT);
	float scattering = max(0.0, light_dot);
	DIFFUSE_LIGHT = mix(vec3(1.0, 0.1, 0.0), vec3(scattering), smoothstep(0.0, 0.2, light_dot)) * smoothstep(-0.2, 0.0, light_dot);
}
