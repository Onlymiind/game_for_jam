shader_type canvas_item;

const vec4 green = vec4(42.0 / 255.0, 1, 0, 1);
const vec4 transparent = vec4(0, 0, 0, 0);

void fragment() {
	COLOR = texture(TEXTURE, UV);
	if (COLOR == green) {
		COLOR = transparent;
	}
}
