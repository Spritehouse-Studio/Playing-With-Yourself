// Cuts out of a canvas item the shape of an input texture
shader_type canvas_item;

// The texture mask to cut out of the canvas item
uniform sampler2D mask_texture;

void fragment() {
	vec4 mask_color = texture(mask_texture, UV);
	COLOR.a = mask_color.a;
}
