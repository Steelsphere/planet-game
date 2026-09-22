shader_type canvas_item;

void fragment() {
	float temp = texture(TEXTURE, UV).r;
	COLOR = vec4(vec3(temp - 0.0015), 1.0);
}
