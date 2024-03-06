shader_type canvas_item;
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

uniform float amount = 0;
uniform bool itsOver = false;


void fragment()
{	float amt;
	amt = 40.0f + (TIME * 4.0f);
	if(TIME > 1.0f){
		amt = 256.0f;
	}
	vec2 grid_uv = round(SCREEN_UV * float(amt)) / float(amt);
	
	vec4 text = texture(screen_texture, grid_uv);
	
	COLOR = text;
}