shader_type canvas_item;

uniform float amount: hint_range(0.0, 1.0) = 1.0;
uniform float flow_speed = 1.0;

void fragment() {
	vec4 main_tex = texture(TEXTURE, mod(UV + TIME * vec2(0.0, -flow_speed), 1.0));

	float step_value = step(UV.y, amount);
	COLOR.rgb = main_tex.rgb;
	COLOR.a = main_tex.a * step_value;
}