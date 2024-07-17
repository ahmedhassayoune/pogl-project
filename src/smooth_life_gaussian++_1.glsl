#include "smooth_life_gaussian++_utils.glsl"

#iChannel0 "self"
#iChannel1 "file://smooth_life_gaussian++_3.glsl"
#iChannel2 "file://../assets/pebbles.png"

float sigmoid(float x, float a, float alpha) {
    return 1.0 / (1.0 + exp(-4.0 * (x - a) / alpha));
}

float smooth_edge(float x, float cutoff) {
    return 1.0 - sigmoid(x, cutoff, 0.5);
}

float sigmoid_ab(float x, float a, float b) {
    return sigmoid(x, a, ALPHA_N) * (1.0 - sigmoid(x, b, ALPHA_N));
}

float sigmoid_mix(float x, float y, float m) {
    return x * (1.0 - sigmoid(m, 0.5, ALPHA_M)) + y * sigmoid(m, 0.5, ALPHA_M);
}

float S(float n, float m) {
    float thresh_b = sigmoid_ab(n, B1, B2);
    float thresh_d = sigmoid_ab(n, D1, D2);
    return sigmoid_mix(thresh_b, thresh_d, m);
}

void main() {
    vec2 size = iResolution.xy;
    vec2 uv = gl_FragCoord.xy / size;

    if (iFrame == 0) {
        float val = texture(iChannel2, uv).r;
        gl_FragColor = id(val);
        return;
    }

    vec2 mn = texture(iChannel1, uv).xy;
    float s = S(mn.y, mn.x);

    vec3 color = texture(iChannel0, uv).rgb;
    color.r = color.r + dt * (2.0 * s - 1.0);
    color.gb = mn;
    color = clamp(color, 0.0, 1.0);

    if(iMouse.z > 0.0) {
        float d = length(gl_FragCoord.xy - iMouse.xy);
        if(d <= OUTER_RADIUS) {
            float val = sigmoid(d, INNER_RADIUS, 0.5);
            color = id(val).rgb;
        }
    }

    gl_FragColor = vec4(color.rgb, 1.0);
}