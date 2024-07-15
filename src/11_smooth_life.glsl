#iChannel0 "self"
#iChannel2 "file://../assets/pebbles.png"

#define id(val) vec4(val, val, val, 1.0)

const float PI = 3.14159265358979;

const float INNER_RADIUS = 5.0;
const float OUTER_RADIUS = 3.0 * INNER_RADIUS;

const int KERNEL_SIZE = int(OUTER_RADIUS);

const float B1 = 0.257;
const float B2 = 0.335;

const float D1 = 0.365;
const float D2 = 0.549;

const float ALPHA_N = 0.028;
const float ALPHA_M = 0.147;

const float dt = 0.3;

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

vec2 integrate(vec2 uv) {
    float inner_sum = 0.0, annulus_sum = 0.0, inner_w_sum = 0.0, annulus_w_sum = 0.0;
    for (int i = -KERNEL_SIZE; i <= KERNEL_SIZE; i++) {
        for (int j = -KERNEL_SIZE; j <= KERNEL_SIZE; j++) {

            float d = length(vec2(i, j));
            if (d > (OUTER_RADIUS + 0.5)) {
                continue;
            }

            vec2 current_uv = fract(uv + vec2(i, j) / iResolution.xy);
            float val = texture(iChannel0, current_uv).r;

            if (d <= (INNER_RADIUS + 0.5)) {
                float w = smooth_edge(d, INNER_RADIUS);
                inner_sum += val * w;
                inner_w_sum += w;
            }

            if (d >= (INNER_RADIUS - 0.5) && d <= (OUTER_RADIUS + 0.5)) {
                float w = smooth_edge(d, OUTER_RADIUS);
                annulus_sum += val * w;
                annulus_w_sum += w;
            }
        }
    }

    return vec2(inner_sum / inner_w_sum, annulus_sum / annulus_w_sum);
}

void main(void) {
    vec2 size = iResolution.xy;
    vec2 uv = gl_FragCoord.xy / size;

    if (iFrame < 5) {
        float val = texture(iChannel2, uv).r;
        gl_FragColor = id(val);
        return;
    }

    vec2 mn = integrate(uv);
    float s = S(mn.y, mn.x);

    float old_val = texture(iChannel0, uv).r;
    float new_val = old_val + dt * (2.0 * s - 1.0);
    vec4 color = id(new_val);
    color = clamp(color, 0.0, 1.0);

    if(iMouse.z > 0.0) {
        float d = length(gl_FragCoord.xy - iMouse.xy);
        if(d <= OUTER_RADIUS) {
            float val = sigmoid(d, INNER_RADIUS, 0.5);
            color = id(val);
        }
    }

    gl_FragColor = color;
}