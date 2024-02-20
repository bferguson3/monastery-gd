shader_type canvas_item;
//render_mode blend_mul;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	//vec2 uv = SCREEN_UV;
	//ALBEDO = vec3(0.3, 0.3, 0.3);
	//ALPHA = 0.5;
	COLOR = vec4(0.2, 0.2, 0.2, 0.5);
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
