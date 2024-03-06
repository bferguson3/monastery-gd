shader_type canvas_item;
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

uniform float amount = 0;
uniform bool itsOver = false;


void fragment()
{	float amt;
	if(TIME < 4.0f){
		amt = (127.0f / TIME) ;
	} 
	else { 
		amt = (TIME * 127.0f);
	}
	vec2 grid_uv = floor(SCREEN_UV * float(amt)) / float(amt);
	
	vec4 text = texture(screen_texture, grid_uv);
	
	float rv = sin(TIME / 1.0f) + 0.5;
	float gv = sin(TIME / 3.0f )+ 0.5f;
	float bv = sin(TIME / 7.0f) + 0.5f;
	
	COLOR = vec4(text.r * rv, text.g * gv, text.b * bv, text.a);
}