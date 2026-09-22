shader_type spatial;

uniform sampler3D noise1: repeat_enable, filter_nearest;
uniform sampler3D noise2;

varying vec3 local_pos;

mat3 rotate_y(float angle) {
	return mat3(
		vec3(cos(angle), 0.0, sin(angle)),
		vec3(0.0, 1.0, 0.0),
		vec3(-sin(angle), 0.0, cos(angle))
	);
}

void vertex() {
	local_pos = VERTEX * rotate_y(-TIME * 0.05);
}

void fragment() {
	float clouds1 = texture(noise1, local_pos).r;
	ALPHA = smoothstep(0.6, 1.0, clouds1);
}
