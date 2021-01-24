shader_type canvas_item;
render_mode unshaded;

uniform vec4 color1 : hint_color;
uniform vec4 color2 : hint_color;
uniform vec4 color3 : hint_color;
uniform vec4 color4 : hint_color;
uniform float rate : hint_range(1.0,100.0);
uniform float mix_amount : hint_range(0.0,1.0);

//const float custom_cursor = 1.0;

vec4 computeColorSlope(float cursor){
	vec4 color_point;
	if(cursor < 0.25){
		vec4 color_slope = color2 - color1;
		color_point = color1 + cursor * 4.0 * color_slope;
	}
	else if(cursor >= 0.25 && cursor < 0.5){
		vec4 color_slope = color3 - color2;
		color_point = color2 + (cursor - 0.25) * 4.0 * color_slope;
	}
	else if(cursor >= 0.5 && cursor < 0.75){
		vec4 color_slope = color4 - color3;
		color_point = color3 + (cursor-0.5) * 4.0 * color_slope;
	}
	else{
		vec4 color_slope = color1 - color3;
		color_point = color4 + (cursor-0.75) * 4.0 * color_slope;
	}
	return color_point;
}

void fragment(){
	float cursor = (0.5 * sin(TIME/rate)) + 0.5;
//	float cursor = custom_cursor;
	vec4 original_color = texture(TEXTURE, UV);
	vec4 col = original_color;
//	col = mix(original_color, computeColorSlope(cursor), mix_amount);
	col *= computeColorSlope(cursor);
	COLOR = vec4(col.rgb, original_color.a);
}