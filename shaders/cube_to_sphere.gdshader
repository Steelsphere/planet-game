shader_type spatial;

uniform sampler2D tex;

void vertex() {
	float dist = sqrt(VERTEX.x * VERTEX.x + VERTEX.y * VERTEX.y + VERTEX.z * VERTEX.z);
	VERTEX = vec3(VERTEX.x / dist, VERTEX.y / dist, VERTEX.z / dist);
}

void fragment() {
	ALBEDO = texture(tex, UV).rgb;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
