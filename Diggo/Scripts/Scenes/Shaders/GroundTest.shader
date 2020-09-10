shader_type canvas_item;

uniform sampler2D destroy_texture;

void fragment() {
    vec4 color = texture(TEXTURE, UV);
    color.a *= texture(destroy_texture, UV).a;

    COLOR = color;
}