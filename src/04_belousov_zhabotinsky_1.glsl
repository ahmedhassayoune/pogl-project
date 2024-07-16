#include "04_belousov_zhabotinsky_utils.glsl"

#iChannel0 "file://04_belousov_zhabotinsky_2.glsl"

struct Gradient {
    vec4 colors[5];
    float positions[5];
};

vec4 interpolate(vec4 color1, vec4 color2, float factor) {
    return mix(color1, color2, factor);
}

vec4 apply_gradient(float val, Gradient gradient) {
    for (int i = 0; i < 4; ++i) {
        if (val >= gradient.positions[i] && val <= gradient.positions[i+1]) {
            float factor = (val - gradient.positions[i]) / (gradient.positions[i+1] - gradient.positions[i]);
            return interpolate(gradient.colors[i], gradient.colors[i+1], factor);
        }
    }
    return gradient.colors[4];
}

void main(void)
{
    float cell_state = texture(iChannel0, gl_FragCoord.xy/(iResolution.xy * scale)).r;
    float val = cell_state / q;
    
    // Define gradient
    Gradient gradient;
    gradient.colors[0] = vec4(0.0, 0.0, 0.0, 1.0); // Black
    gradient.colors[1] = vec4(0.207, 0.071, 0.416, 1.0); // Blue / Purple
    gradient.colors[2] = vec4(0.976, 0.074, 0.384, 1.0); // Pink / Red
    gradient.colors[3] = vec4(1.0, 0.556, 0.267, 1.0); // Yellow / Orange
    gradient.colors[4] = vec4(1.0, 1.0, 1.0, 1.0); // White

    gradient.positions[0] = 0.0;
    gradient.positions[1] = 0.25;
    gradient.positions[2] = 0.5;
    gradient.positions[3] = 0.75;
    gradient.positions[4] = 1.0;
    
    gl_FragColor = apply_gradient(val, gradient);
}