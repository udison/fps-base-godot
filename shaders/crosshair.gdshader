shader_type canvas_item;

uniform vec4 crosshair_color = vec4(0, 1, 0, 1);

float circle(vec2 pos, float radius) {
	return smoothstep(0.01, 0.0, abs(length(pos)-radius));
}

void fragment() {
	COLOR.rgb = vec3(circle(UV - 0.5, 0.01));
	
	if (COLOR.r == 0.0 && COLOR.g == 0.0 && COLOR.b == 0.0) {
		discard;
	}
}