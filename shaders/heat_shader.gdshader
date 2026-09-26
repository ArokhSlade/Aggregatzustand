shader_type spatial;
render_mode unshaded, fog_disabled;

uniform sampler2D screen_texture : hint_screen_texture;
uniform sampler2D noise_texture;
uniform float speed : hint_range(0.001, 0.2) = 0.1;
uniform float strength : hint_range(0.001, 0.03) = 0.02;
uniform vec2 direction;

void fragment() {
	float noise = texture(noise_texture, UV + TIME * speed).r * strength;
	vec2 distortion = vec2(noise)*direction;
	ALBEDO = texture(screen_texture, SCREEN_UV + distortion - strength/2.0).rgb;
}
