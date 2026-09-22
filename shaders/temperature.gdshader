shader_type canvas_item;

const float greenhouse = 0.5;
const float sun_strength = 1.0;
const float axial_tilt = 0.25;
const float albedo_strength = 0.25;

uniform sampler2D prev_texture;
uniform sampler2D elevation_map;
uniform sampler2D terrain_map;

void fragment() {
    vec2 angle = vec2(UV.x * 2.0 * 3.14159, UV.y * 3.14159);
    
    float x = sin(angle.y) * cos(angle.x);
    float y = -cos(angle.y);
    float z = sin(angle.y) * sin(angle.x);

    vec3 sphere_coords = normalize(vec3(x, y, z));

    vec3 sun_dir = vec3(cos(TIME), sin(TIME * 0.1) * 0.25, sin(TIME));
    float irradiance = max(0.0, dot(sphere_coords, sun_dir) * sun_strength);
    //float snow = texture(iChannel1, uv).r;

    // Albedo
    //irradiance *= 1.0 - snow * albedo_strength;

	float terrain = texture(terrain_map, UV).r;
	float elevation = max(0.0, texture(elevation_map, UV).r - 0.5) * 2.0;
    float temp = texture(prev_texture, UV).r;
	float thermal_response = 1.0;
	
	if (terrain < 0.1) {
		thermal_response = 0.5;
	}
	
	temp += irradiance * 0.0125 * (1.0 - elevation * 0.5);
	temp -= 0.002;
	
    vec3 col = vec3(temp);
    
    COLOR = vec4(col,1.0);
}
