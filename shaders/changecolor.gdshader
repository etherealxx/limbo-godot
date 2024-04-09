// credit to Zylann from this post
// https://forum.godotengine.org/t/changing-a-specific-color-in-a-sprite-using-shaders-in-godot-3/29610/4
// with modification

shader_type canvas_item;

// Which color you want to change
uniform vec4 u_color_key : source_color = vec4(0.0, 0.0, 0.0, 1.0);
// Which color to replace it with
uniform vec4 u_replacement_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);
// How much tolerance for the replacement color (between 0 and 1)
uniform float u_tolerance = 0.0;
// Interpolation factor (between 0 and 1)
uniform float u_interpolation_factor = 1.0;

void fragment() {
	// Get color from the sprite texture at the current pixel we are rendering
	vec4 original_color = texture(TEXTURE, UV);
	vec3 col = original_color.rgb;
	// Get a rough degree of difference between the texture color and the color key
	vec3 diff3 = col - u_color_key.rgb;
	float m = max(max(abs(diff3.r), abs(diff3.g)), abs(diff3.b));
	// Change color of pixels below tolerance threshold, while keeping shades if any (a bit naive, there may better ways)
	float brightness = length(col);
	vec3 interpolated_color = mix(col, u_replacement_color.rgb, u_interpolation_factor);
	col = mix(col, interpolated_color * brightness, step(m, u_tolerance));
	// Assign final color for the pixel, and preserve transparency
	COLOR = vec4(col.rgb, original_color.a);
}