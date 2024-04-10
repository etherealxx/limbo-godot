// modified from Zylann's shader from this post
// https://forum.godotengine.org/t/changing-a-specific-color-in-a-sprite-using-shaders-in-godot-3/29610/4

shader_type canvas_item;

// First color you want to change
uniform vec4 u_color_key1 : source_color = vec4(0.0, 0.0, 0.0, 1.0);
// Replacement color for the first color key
uniform vec4 u_replacement_color1 : source_color = vec4(0.0, 0.0, 0.0, 1.0);
// Second color you want to change
uniform vec4 u_color_key2 : source_color = vec4(0.0, 0.0, 0.0, 1.0);
// Replacement color for the second color key
uniform vec4 u_replacement_color2 : source_color = vec4(0.0, 0.0, 0.0, 1.0);
// How much tolerance for the replacement colors (between 0 and 1)
uniform float u_tolerance = 0.0;
// Interpolation factor (between 0 and 1)
uniform float u_interpolation_factor = 1.0;

void fragment() {
    // Get color from the sprite texture at the current pixel we are rendering
    vec4 original_color = texture(TEXTURE, UV);
    vec3 col = original_color.rgb;
    // Get a rough degree of difference between the texture color and the color keys
    vec3 diff3_1 = col - u_color_key1.rgb;
    vec3 diff3_2 = col - u_color_key2.rgb;
    float m1 = max(max(abs(diff3_1.r), abs(diff3_1.g)), abs(diff3_1.b));
    float m2 = max(max(abs(diff3_2.r), abs(diff3_2.g)), abs(diff3_2.b));
    // Change color of pixels below tolerance threshold for the first color
    float brightness = length(col);
    vec3 interpolated_color1 = mix(col, u_replacement_color1.rgb, u_interpolation_factor);
    vec3 col1 = mix(col, interpolated_color1 * brightness, step(m1, u_tolerance));
    // Change color of pixels below tolerance threshold for the second color
    vec3 interpolated_color2 = mix(col1, u_replacement_color2.rgb, u_interpolation_factor);
    vec3 final_col = mix(col1, interpolated_color2 * brightness, step(m2, u_tolerance));
    // Assign final color for the pixel, and preserve transparency
    COLOR = vec4(final_col.rgb, original_color.a);
}
