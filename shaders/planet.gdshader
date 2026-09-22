shader_type spatial;

uniform float orbital_angle;

uniform sampler2D terrain_map: filter_nearest;
uniform sampler2D elevation_map: filter_nearest;
uniform sampler2D temperature_map;
uniform sampler3D humidity_map;
uniform sampler2D atlas: filter_nearest;

varying vec3 local_pos;

const float tiling = 25.0;

void vertex() {
	local_pos = VERTEX;
	
	//float terrain = texture(terrain_map, local_pos).r;
	//float elevation = texture(elevation_map, local_pos).r;
	
	//if (terrain > 0.5) {
	//	VERTEX *= 1.0 + elevation * 0.05;
	//}
}

vec3 get_texture(vec2 atlas_pos, vec2 uv, float tile_id, float num_tile_variants) {
	float tile_variant = floor(tile_id * num_tile_variants);
	atlas_pos.y += tile_variant * 16.0;
	
	vec2 tex_pos = fract(uv * tiling);
	vec2 texel = tex_pos * 16.0 + atlas_pos;
	
	vec3 color = texelFetch(atlas, ivec2(texel), 0).rgb;
	return color;
}

vec2 cubemap_uv() {
	vec3 p = normalize(local_pos);
	vec3 a = abs(p);

	vec2 uv;

	if (a.x > a.y && a.x > a.z) {
	    // X face
	    uv = p.yz / a.x;
	}
	else if (a.y > a.z) {
	    // Y face
	    uv = p.xz / a.y;
	}
	else {
	    // Z face
	    uv = p.xy / a.z;
	}
	
	return uv;
}

float rand(vec2 co){
  return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

void fragment() {
	float terrain = texture(terrain_map, UV).r;
	float elevation = texture(elevation_map, UV).r;
	float humidity = texture(humidity_map, local_pos).r;
	
	//float temp_variation = (texture(temperature_map, local_pos + vec3(0.0, TIME/20.0, 0.0)).r - 0.5) * 0.5;
	//float ocean_temp_variation = (texture(temperature_map, local_pos + vec3(0.0, TIME/50.0, 0.0)).r - 0.5) * 0.2;
	//float temperature = (1.0 - abs(local_pos.y + sin(TIME/2.0) * 0.25) * 1.1) + temp_variation - elevation * 0.1;
	//float ocean_temperature = (0.9 - abs(local_pos.y + sin(TIME/2.0 - 1.0) * 0.05) * 0.9) + ocean_temp_variation;
	float temp = texture(temperature_map, UV).r;
	
	vec2 cubemap_uv = cubemap_uv();
	vec2 grid_pos = floor(cubemap_uv * tiling);
	float tile_id = rand(grid_pos);
	
	vec3 terrain_color = vec3(0.0);
	vec3 ocean_color = vec3(0.0);
	
	if (terrain > 0.05) {
		vec3 grassland = get_texture(vec2(0.0, 0.0), cubemap_uv, tile_id, 3);
		vec3 mountains = get_texture(vec2(32, 0.0), cubemap_uv, tile_id, 3);
		vec3 snowy_mountains = get_texture(vec2(48, 0.0), cubemap_uv, tile_id, 3);
		vec3 snow = get_texture(vec2(80, 0), cubemap_uv, tile_id, 0);
		vec3 desert = get_texture(vec2(16, 48), cubemap_uv, tile_id, 3);
		vec3 forest = get_texture(vec2(0, 48), cubemap_uv, tile_id, 3);
		vec3 tundra = get_texture(vec2(96, 0), cubemap_uv, tile_id, 0);
		
		terrain_color = mix(desert, grassland, smoothstep(0.4, 0.5, humidity));
		terrain_color = mix(terrain_color, forest, smoothstep(0.6, 0.7, humidity));
		terrain_color = mix(terrain_color, tundra, smoothstep(0.7, 0.8, abs(local_pos.y)));
		terrain_color = mix(terrain_color, mountains, smoothstep(0.6, 0.8, elevation));
		terrain_color = mix(terrain_color, snowy_mountains, smoothstep(0.8, 1.0, elevation));
		
		// Ice
		terrain_color = mix(terrain_color, snow, smoothstep(0.2, 0.1, temp));
		
		//terrain_color = mix(vec3(0.0), terrain_color, min(1.0, elevation * 4.0));
		
		terrain_color = texture(terrain_map, UV).rgb;
		ROUGHNESS = 1.0;
	}
	else {
		vec3 ocean = get_texture(vec2(16.0, 0.0), cubemap_uv, rand(grid_pos + floor(TIME * 2.0)), 3);
		//ocean = mix(vec3(0.1, 0.3, 0.5), ocean, elevation * 2.0);
		vec3 ice = get_texture(vec2(64.0, 0.0), cubemap_uv, tile_id, 0);
		
		ocean_color = mix(ocean, ice, smoothstep(0.1, 0.05, temp));
		
		if (terrain == 0.0) {
			ocean_color = vec3(0.0);
		}
		
		ROUGHNESS = 0.35;
	}
	
	vec3 color = vec3(0.0);
	color = mix(terrain_color, ocean_color, smoothstep(0.3, 0.0, terrain));
	//ROUGHNESS = mix(0.35, 1.0, smoothstep(0.0, 0.1, elevation));
	//ALBEDO = color;
	
	vec3 temp_color = mix(vec3(0.0, 0.0, 1.0), vec3(0.4, 0.7, 1.0), smoothstep(0.0, 0.25, temp));
    temp_color = mix(temp_color, vec3(0.0, 1.0, 0.0), smoothstep(0.25, 0.5, temp));
    temp_color = mix(temp_color, vec3(1.0, 1.0, 0.0), smoothstep(0.5, 0.75, temp));
    temp_color = mix(temp_color, vec3(1.0, 0.0, 0.0), smoothstep(0.75, 1.0, temp));
	
	ALBEDO = mix(temp_color, color, 0.5);
	
	//ALBEDO = texture(temperature_map, UV).rgb;
	//ALBEDO = vec3(temperature);
	//ALBEDO = vec3(luminance);
}
