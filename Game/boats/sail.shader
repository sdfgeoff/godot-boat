shader_type spatial;
render_mode blend_mix,depth_draw_opaque,cull_disabled;

uniform float belly = 0.0;
uniform float luff = 0.0;
uniform float luff_position = 0.0;
uniform sampler2D noise_tex;
uniform sampler2D sail_tex: hint_albedo;

uniform float normal_sample_delta = 0.02;

float sample_luff(vec2 uv, float time){
	vec4 noise = texture(noise_tex, uv * 0.2 + vec2(time, 0));
	vec4 sail_sample = texture(sail_tex, uv);
	float luffing = ((noise.r - 0.5) * luff);
	return pow(sail_sample.a, 1.0/2.2) * (luffing + belly);
}

void vertex(){
	float here = sample_luff(UV, -luff_position);
	float above = sample_luff(UV+vec2(0.0, normal_sample_delta), luff_position);
	float aside = sample_luff(UV+vec2(normal_sample_delta, 0.0), luff_position);
	vec3 norm = NORMAL + vec3(
		0.0,
		above - here,
		here - aside
	) * 0.4;
	
	VERTEX = VERTEX + NORMAL * here;
	NORMAL = normalize(norm);
}

void fragment(){
	ROUGHNESS = 0.9;
	METALLIC = 0.0;
	ALBEDO = texture(sail_tex, UV).rgb;
	TRANSMISSION = mix(vec3(length(ALBEDO)), ALBEDO, 1.5) * 0.5;
	SPECULAR = 0.2;
}