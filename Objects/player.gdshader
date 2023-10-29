shader_type canvas_item;

uniform vec3 color : source_color = vec3(1);
uniform float 	progress : hint_range(0.0, 1.0, 0.05) = 0;

void fragment() {
	vec4 cur = texture(TEXTURE, UV);
	vec4 target_color = mix(cur, vec4(color, cur.a), progress);
	COLOR = target_color;
}