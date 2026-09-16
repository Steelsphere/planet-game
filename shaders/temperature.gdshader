shader_type canvas_item;

uniform sampler3D noise_texture;

void fragment() {
	float theta = UV.y * 3.14159;
	float phi = UV.x * 3.14159 * 2.0;
	vec3 unit = vec3(0.0, 0.0, 0.0);

	unit.x = sin(phi) * sin(theta);
	unit.y = cos(theta) * -1.0;
	unit.z = cos(phi) * sin(theta);
	unit = normalize(unit);
	
	COLOR = vec4(1.0 - abs(unit.y) * 0.8) + (texture(noise_texture, unit).r - 0.5) * 0.2;;
}
