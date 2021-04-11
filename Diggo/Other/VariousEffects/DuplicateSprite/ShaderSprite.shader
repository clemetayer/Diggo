shader_type canvas_item;
render_mode unshaded;

uniform vec4 color:hint_color;

void fragment(){
	COLOR = vec4(color.rgb,texture(TEXTURE,UV).a);
}