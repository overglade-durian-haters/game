shader_type canvas_item;

uniform float alpha_threshold : hint_range(0.0, 1.0, 0.001) = 0.5;

void fragment() {
    COLOR.a = step(alpha_threshold, COLOR.a);
}