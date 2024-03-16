shader_type canvas_item;
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

uniform float amount = 0;
uniform bool itsOver = false;

uniform float asdf = 100.0f;
uniform bool darken = false;

void fragment()
{	float amt = amount;
	//amt = (asdf) / TIME;
	vec2 grid_uv = floor(SCREEN_UV * float(amt)) / float(amt);
	
	vec4 text = texture(screen_texture, grid_uv);
	
	COLOR = text;
}