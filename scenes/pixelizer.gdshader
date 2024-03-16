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
	
	text.r *= (amt / 128.0);
	text.g *= (amt / 128.0);
	text.b *= (amt / 128.0);
	
	if(darken){
		text = vec4(0.0, 0.0, 0.0, 1.0);
	}
	
	COLOR = text;
}